package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.properties.GlobalProperties;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.modules.api.dao.BalanceMapper;
import com.bottle.pay.modules.api.entity.BalanceEntity;
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
    private BalanceChangeLogService balanceChangeLogService;

    @Autowired
    private GlobalProperties globalProperties;

    private static final String CREATE_LOCK_KEY_PREFIX = "balance:create:";

    /**
     * 此处必须事务才能生效,扣除商户可用余额,增加商户代付中
     *
     * @param amount
     * @param userId
     * @param billId
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    public BalanceEntity billOutMerchantBalance(BigDecimal amount, Long userId, String billId) {
        String key = BillConstant.BILL_OUT_MERCHANT_BALANCE_LOCK + ":" + userId;
        if (globalProperties.isRedisSessionDao()) {
            RedisLock redisLock = new RedisLock(stringRedisTemplate, key);
            if (redisLock.lock()) {
                try {
                    return getAndUpdatePayingBalanceEntity(amount, userId, billId);
                } catch (Exception e) {
                    e.printStackTrace();
                    log.warn("商户余额变动异常" + e.getMessage());
                    if (e instanceof RRException) {
                        throw new RRException(((RRException) e).getMsg());
                    }
                } finally {
                    redisLock.unLock();
                }
            }
        } else {
            try {
                return getAndUpdatePayingBalanceEntity(amount, userId, billId);
            } catch (Exception e) {
                e.printStackTrace();
                log.warn("商户余额变动异常" + e.getMessage());
                if (e instanceof RRException) {
                    throw new RRException(((RRException) e).getMsg());
                }
            }
        }
        throw new RRException("服务繁忙，稍后再试");
    }

    private BalanceEntity getAndUpdatePayingBalanceEntity(BigDecimal amount, Long userId, String billId) {
        BalanceEntity balance = new BalanceEntity(userId);
        synchronized (this) {
            balance = mapper.selectForUpdate(balance);
            if (null != balance) {
                int num = mapper.billoutBalanceMerchantChange(amount, balance.getId());
                if (num < 1) {
                    throw new RRException("商户余额不足，更新失败", 900);
                }
            } else {
                throw new RRException("商户账户不存在，更新失败");
            }
        }
        BalanceEntity balanceAfter = mapper.selectOne(new BalanceEntity(userId));
        log.info("商户余额变动, userId :" + userId + "，amount:" + amount + "beforeBalance:" + balance.getBalance() + "afterBalance:" + balanceAfter.getBalance());
        balanceChangeLogService.saveBanlanceChangeLog(balance, balanceAfter.getBalance(), amount.multiply(new BigDecimal(-1)), billId, "商户余额变动");
        return balanceAfter;
    }


    @Transactional
    public BalanceEntity billOutMerchantChangePayingBalance(BigDecimal amount, Long userId, String billId) {
        String keyLock = BillConstant.BILL_OUT_MERCHANT_BALANCE_LOCK + ":paying:" + userId;
        if (globalProperties.isRedisSessionDao()) {
            RedisLock redisLock = new RedisLock(stringRedisTemplate, keyLock);
            if (redisLock.lock()) {
                try {
                    return getAndUpdatePayingBalanceEntity(amount, userId, billId, keyLock);
                } catch (Exception e) {
                    e.printStackTrace();
                    log.warn("商户支付中余额变动异常" + e.getMessage());
                } finally {
                    redisLock.unLock();
                }

            }
        } else {
            try {
                return getAndUpdatePayingBalanceEntity(amount, userId, billId, keyLock);
            } catch (Exception e) {
                e.printStackTrace();
                log.warn("商户支付中余额变动异常" + e.getMessage());
            }
        }
        throw new RRException("服务繁忙，稍后再试");
    }

    private BalanceEntity getAndUpdatePayingBalanceEntity(BigDecimal amount, Long userId, String billId, String keyLock) {
        BalanceEntity balance = new BalanceEntity(userId);
        synchronized (this) {
            balance = mapper.selectForUpdate(balance);
            mapper.billOutMerchantChangePayingBalance(amount, balance.getId());
        }
        BalanceEntity balanceAfter = mapper.selectOne(new BalanceEntity(userId));
        log.info("商户支付中余额变动, userId :" + userId + "，amount:" + amount + "beforeBalance:" + balance.getBalance() + "afterBalance:" + balanceAfter.getBalance());
        balanceChangeLogService.saveBanlanceChangeLog(balance, balanceAfter.getBalance(), amount, billId, "商户支付中余额变动");
        return balanceAfter;
    }

    /**
     * 此处必须事务才能生效,扣除商户可用余额,增加商户代付中
     *
     * @param amount
     * @param userId
     * @return
     */
    @Transactional(rollbackFor = Exception.class)
    public BalanceEntity billOutBusinessBalance(BigDecimal amount, Long userId, String billId) {
        String key = BillConstant.BILL_BUSINESS_BALANCE_LOCK + ":" + userId;
        if (globalProperties.isRedisSessionDao()) {
            RedisLock redisLock = new RedisLock(stringRedisTemplate, key);
            if (redisLock.lock()) {
                try {
                    return getAndUpdateBusinessBalanceEntity(amount, userId, billId);
                } catch (Exception e) {
                    e.printStackTrace();
                    log.warn("出款员余额变动异常" + e.getMessage());
                    if (e instanceof RRException) {
                        throw new RRException(((RRException) e).getMsg());
                    }
                } finally {
                    redisLock.unLock();
                }
            }
        }else {
            return getAndUpdateBusinessBalanceEntity(amount, userId, billId);
        }
        throw new RRException("服务繁忙，稍后再试");
    }

    private BalanceEntity getAndUpdateBusinessBalanceEntity(BigDecimal amount, Long userId, String billId) {
        BalanceEntity balance = new BalanceEntity(userId);
        synchronized (this) {
            balance = mapper.selectForUpdate(balance);
            if (null != balance) {
                int num = mapper.billoutBalanceBusinessChange(amount, balance.getId());
                if (num < 1) {
                    throw new RRException("出款员更新失败", 900);
                }
            } else {
                throw new RRException("出款员账户不存在，更新失败");
            }
        }
        BalanceEntity balanceAfter = mapper.selectOne(new BalanceEntity(userId));
        log.info("出款员余额变动, userId :" + userId + "，amount:" + amount + "beforeBalance:" + balance.getBalance() + "afterBalance:" + balanceAfter.getBalance());
        balanceChangeLogService.saveBanlanceChangeLog(balance, balanceAfter.getBalance(), amount, billId, "出款员余额变动");
        return balanceAfter;
    }


    /**
     * 创建余额账户
     *
     * @return
     */
    public BalanceEntity createBalanceAccount(Long userId) {
        BalanceEntity balance = mapper.selectOne(new BalanceEntity(userId));
        if (balance != null) {
            log.info("用户:{}余额账户:{}已存在无需再创建", userId, balance.getId());
            return balance;
        }
        SysUserEntity userEntity = super.getUserById(userId);
        RedisLock redisLock = new RedisLock(stringRedisTemplate, CREATE_LOCK_KEY_PREFIX + userId);
        if (redisLock.lock()) {
            try {
                balance = mapper.selectOne(new BalanceEntity(userId));
                if (balance != null) {
                    log.info("用户:{}余额账户:{}已存在无需再创建", userId, balance.getId());
                    return balance;
                }
                Date date = new Date();
                balance = new BalanceEntity();
                balance.setUserName(userEntity.getUsername());
                balance.setUserId(userEntity.getUserId());
                balance.setBalance(BigDecimal.ZERO);
                balance.setBalanceFrozen(BigDecimal.ZERO);
                balance.setBalancePaying(BigDecimal.ZERO);
                balance.setRoleId(userEntity.getRoleId());
                balance.setRoleName(userEntity.getRoleName());
                balance.setBillOutLimit(billOutLimit);
                balance.setCreateTime(date);
                balance.setLastUpdate(date);
                balance.setOrgId(userEntity.getOrgId());
                balance.setOrgName(userEntity.getOrgName());
                mapper.save(balance);
                log.info("userId:{}-{},role:{}-{},orgId:{}-{}创建余额账户成功", userId, userEntity.getUsername(), userEntity.getRoleId(), userEntity.getRoleName(), userEntity.getOrgId(), userEntity.getOrgName());
                return balance;
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                redisLock.unLock();
            }
        }
        log.warn("创建用户:{}余额账户时分布式锁获取失败", userId);
        throw new RRException("创建用户余额账户时异常，请稍后再试");
    }

    /**
     * 根据主键id 或者 userId 更新  可用余额，冻结余额，支付中余额
     * 增加时正数，减少时负数，不更新时就空值
     * 且各余额可为负数
     *
     * @param userId        商户ID
     * @param balance       可用余额
     * @param balanceFrozen 冻结余额
     * @param balancePaying 支付中余额
     * @return
     */
    public boolean updateBalance(Long userId, BigDecimal balance, BigDecimal balanceFrozen, BigDecimal balancePaying) {
        if (userId == null) {
            throw new RRException("更新余额前请设置userId");
        }
        BalanceEntity entity = new BalanceEntity();
        entity.setUserId(userId);
        entity.setBalance(balance);
        entity.setBalanceFrozen(balanceFrozen);
        entity.setBalancePaying(balancePaying);
        entity.setLastUpdate(new Date());
        int num = mapper.updateBalance(entity);
        log.info("更新商户余额userId:{},balance:{},frozen:{},payIng:{}", userId, balance, balanceFrozen, balancePaying);
        return num > 0;

    }


}
