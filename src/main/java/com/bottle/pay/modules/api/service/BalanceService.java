package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.sys.dao.SysOrgMapper;
import com.bottle.pay.modules.sys.dao.SysRoleMapper;
import com.bottle.pay.modules.sys.dao.SysUserMapper;
import com.bottle.pay.modules.sys.entity.SysOrgEntity;
import com.bottle.pay.modules.sys.entity.SysRoleEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Date;

@Service("balanceService")
@Slf4j
public class BalanceService extends BottleBaseService<BalanceMapper, BalanceEntity> {

    @Value("${merchant.billOutLimit:50000}")
    private BigDecimal billOutLimit;
    @Autowired
    private SysRoleMapper sysRoleMapper;

    @Autowired
    private SysOrgMapper sysOrgMapper;

    @Autowired
    private SysUserMapper sysUserMapper;

    private static final String CREATE_LOCK_KEY_PREFIX = "balance:create:";
    /**
     * 此处必须事务才能生效,扣除商户可用余额,增加商户代付中
     *
     * @param amount
     * @param userId
     * @return
     */
    @Transactional
    public BalanceEntity billOutMerchantBalance(BigDecimal amount, Long userId) {
        BalanceEntity balance = new BalanceEntity(userId);
        synchronized (this) {
            balance = mapper.selectForUpdate(balance);
            mapper.billoutBalanceMerchantChange(amount, balance.getId());
        }
        BalanceEntity balanceAfter = mapper.selectOne(new BalanceEntity(userId));
        log.info("商户余额变动, userId :" + userId + "，amount:" + amount + "beforeBalance:" + balance.getBalance() + "afterBalance:" + balanceAfter.getBalance());
        return balanceAfter;
    }


    @Transactional
    public BalanceEntity billOutMerchantChangePayingBalance(BigDecimal amount, Long userId) {
        BalanceEntity balance = new BalanceEntity(userId);
        synchronized (this) {
            balance = mapper.selectForUpdate(balance);
            mapper.billOutMerchantChangePayingBalance(amount, balance.getId());
        }
        BalanceEntity balanceAfter = mapper.selectOne(new BalanceEntity(userId));
        log.info("商户余额变动, userId :" + userId + "，amount:" + amount + "beforeBalance:" + balance.getBalance() + "afterBalance:" + balanceAfter.getBalance());
        return balanceAfter;
    }

    /**
     * 创建余额账户
     *
     * @return
     */
    public BalanceEntity createBalanceAccount(Long userId) {
        BalanceEntity balance = mapper.selectOne(new BalanceEntity(userId));
        if(balance != null){
            log.info("商户:{}余额账户:{}已存在无需再创建",userId,balance.getId());
            return balance;
        }
        SysUserEntity userEntity = sysUserMapper.getObjectById(userId);
        if (userEntity == null) {
            log.warn("userId:{} 在 user表里没有找到", userId);
            throw new RRException("创建商户余额账户失败");
        }
        long roleId = userEntity.getRoleId();
        SysRoleEntity sysRoleEntity = sysRoleMapper.getObjectById(roleId);
        if (sysRoleEntity == null) {
            log.warn("userId:{}对应角色roleId:{}在角色表里没有找到", userId, roleId);
            throw new RRException("创建商户余额账户失败,role异常");
        }
        SysOrgEntity orgEntity = sysOrgMapper.getObjectById(userEntity.getOrgId());
        if (orgEntity == null) {
            log.warn("绑定银行卡时没找到专员:{}对应机构:{}", userId, userEntity.getOrgId());
            throw new RRException("创建商户余额账户失败，org异常");
        }
        RedisLock redisLock = new RedisLock(stringRedisTemplate,CREATE_LOCK_KEY_PREFIX + userId);
        if(redisLock.lock()){
            try {
                balance = mapper.selectOne(new BalanceEntity(userId));
                if(balance != null){
                    log.info("商户:{}余额账户:{}已存在无需再创建",userId,balance.getId());
                    return balance;
                }
                Date date = new Date();
                balance = new BalanceEntity();
                balance.setUserName(userEntity.getUsername());
                balance.setUserId(userEntity.getUserId());
                balance.setBalance(BigDecimal.ZERO);
                balance.setBalanceFrozen(BigDecimal.ZERO);
                balance.setBalancePaying(BigDecimal.ZERO);
                balance.setRoleId(roleId);
                balance.setRoleName(sysRoleEntity.getRoleName());
                balance.setBillOutLimit(billOutLimit);
                balance.setCreateTime(date);
                balance.setLastUpdate(date);
                balance.setOrgId(userEntity.getOrgId());
                balance.setOrgName(userEntity.getOrgName());
                mapper.save(balance);
                log.info("userId:{}-{},role:{}-{},orgId:{}-{}创建余额账户成功", userId, userEntity.getUsername(), roleId, sysRoleEntity.getRoleName(), userEntity.getOrgId(), userEntity.getOrgName());
                return balance;
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                redisLock.unLock();
            }
        }
        log.warn("创建商户:{}余额账户时分布式锁获取失败",userId);
        throw new RRException("创建商户余额账户时异常，请稍后再试");
    }

    /**
     * 根据主键id 或者 userId 更新  可用余额，冻结余额，支付中余额
     *  增加时正数，减少时负数，不更新时就空值
     *  且各余额可为负数
     * @param id 余额ID  必传
     * @param userId 商户ID
     * @param balance 可用余额
     * @param balanceFrozen 冻结余额
     * @param balancePaying 支付中余额
     * @return
     */
    public boolean updateBalance(Long id, Long userId, BigDecimal balance, BigDecimal balanceFrozen, BigDecimal balancePaying) {
        if (id == null && userId == null) {
            throw new RRException("更新前请设置ID 或者 userId");
        }
        BalanceEntity entity = new BalanceEntity();
        entity.setId(id);
        entity.setUserId(userId);
        entity.setBalance(balance);
        entity.setBalanceFrozen(balanceFrozen);
        entity.setBalancePaying(balancePaying);
        entity.setLastUpdate(new Date());
        int num = mapper.updateBalance(entity);
        log.info("更新商户余额 ID:{},userId:{},balance:{},frozen:{},payIng:{}", id, userId, balance, balanceFrozen, balancePaying);
        if (num > 0) {
            return true;
        }
        return false;

    }


}
