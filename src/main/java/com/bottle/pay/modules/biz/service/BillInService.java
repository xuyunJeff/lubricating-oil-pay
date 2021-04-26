package com.bottle.pay.modules.biz.service;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.properties.GlobalProperties;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.common.utils.CommonUtils;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.common.utils.WebUtils;
import com.bottle.pay.modules.api.entity.BalanceEntity;
import com.bottle.pay.modules.api.service.BalanceService;
import com.bottle.pay.modules.biz.dao.BillInMapper;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.biz.entity.BillInEntity;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

/**
 * @author ZhouChenglin<yczclcn       @       1       6       3       .       com>
 */
@Service("billInService")
@Slf4j
public class BillInService extends BottleBaseService<BillInMapper, BillInEntity> {

    @Autowired
    private BankCardService bankCardService;

    @Autowired
    private BalanceService balanceService;

    @Autowired
    private RedisCacheManager redisCacheManager;

    @Autowired
    private GlobalProperties globalProperties;

    private static final String BILL_IN_ADD = "bill:in:add:";

    private static final String BILL_IN_UPDATE = "bill:in:update:";


    /**
     * 商户提交 待充值订单
     *
     * @param params
     * @return
     */
    public R addBillIn(BillInEntity params) {
        if (BigDecimal.ZERO.compareTo(params.getPrice()) == 0) {
            log.warn("充值订单金额:{}不能是0", params.getPrice());
            throw new RRException("充值订单金额不能是0");
        }
        SysUserEntity userEntity = super.getCurrentUser();
        String ip = WebUtils.getIpAddr();
        if (!super.isOutMerchant()) {
            log.warn("user:{}-{}-{},不是代付商户，不能提交充值订单", userEntity.getUserId(), userEntity.getRoleName(), WebUtils.getIpAddr());
            throw new RRException("不是代付商户，不能提交充值订单");
        }
        BankCardEntity query = new BankCardEntity();
        query.setBankCardNo(params.getBankCardNo());
        query.setBusinessId(params.getBusinessId());
        BankCardEntity inBankCard = bankCardService.selectOne(query);
        if (inBankCard == null || inBankCard.getCardStatus() == 2 || inBankCard.getOrgId() != userEntity.getOrgId()) {
            log.warn("商户:{}-{}-{},充值的银行卡不存在或者是冻结或者是不属于当前商户机构", userEntity.getUserId(), userEntity.getOrgId(), ip);
            throw new RRException("商户充值的银行卡不存在或者是冻结或者是不属于当前商户机构");
        }
        String lockKey = BILL_IN_ADD + userEntity.getUserId();
        int num = 0;
        if (globalProperties.isRedisSessionDao()) {
            RedisLock redisLock = new RedisLock(stringRedisTemplate, lockKey);
            if (redisLock.lock()) {
                try {
                    num = saveBillInOrder(params, userEntity, ip, inBankCard, num);
                } catch (Exception e) {
                    log.warn("商户:{}提交充值订单失败，未获取分布式锁,e: {}", userEntity.getUserId(),e);
                    throw new RRException("提交充值订单失败，请稍后在操作。");
                } finally {
                    redisLock.unLock();
                }
            }
        } else {
            synchronized (lockKey.intern()) {
                try {
                    num = saveBillInOrder(params, userEntity, ip, inBankCard, num);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }
        return CommonUtils.msg(num);
    }

    private int saveBillInOrder(BillInEntity params, SysUserEntity userEntity, String ip, BankCardEntity inBankCard, int num) {
        Date date = new Date();
        params.setBillId(generateBillInBillId(String.valueOf(userEntity.getUserId())));
        params.setThirdBillId("third" + params.getBillId());
        params.setBillStatus(BillConstant.BillStatusEnum.UnPay.getCode());
        params.setCreateTime(date);
        params.setLastUpdate(date);
        params.setMerchantId(userEntity.getUserId());
        params.setMerchantName(userEntity.getUsername());
        params.setBankAccountName(inBankCard.getBankAccountName());
        params.setBankCardNo(inBankCard.getBankCardNo());
        params.setBankName(inBankCard.getBankName());
        params.setOrgId(inBankCard.getOrgId());
        params.setOrgName(inBankCard.getOrgName());
        params.setBusinessId(inBankCard.getBusinessId());
        params.setBusinessName(inBankCard.getBusinessName());
        params.setIp(ip);
        num = mapper.save(params);
        log.info("商户:{}-{}提交充值订单:{}-{}成功", userEntity.getUserId(), ip, params.getId(), params.getBillId());
        return num;
    }


    /**
     * 充值订单确认：成功，失败
     * 机构管理员才能 确认订单
     * 1，修改充值订单状态以及修改时间
     * 2，添加商户可用余额
     * 3，添加出款专员银行卡值
     *
     * @param billId
     * @param statusEnum
     * @return
     */
    @Transactional
    public R confirmBillIn(String billId, String comment, BillConstant.BillStatusEnum statusEnum) {
        SysUserEntity userEntity = super.getCurrentUser();
        if (!(super.isOrgAdmin() || super.isBusiness())) {
            log.warn("user:{}-{}不是机构管理员或出款员,不能确认订单", userEntity.getUserId(), WebUtils.getIpAddr());
            throw new RRException("不是机构管理员或出款员,不能确认订单");
        }
        BillInEntity query = new BillInEntity();
        query.setBillId(billId);
        BillInEntity billInEntity = mapper.selectOne(query);
        if (billInEntity == null || billInEntity.getBillStatus() != BillConstant.BillStatusEnum.UnPay.getCode()) {
            log.warn("充值订单:{}不存在或者已被确认过", billId);
            throw new RRException("充值订单不存在或者已被确认过");
        }
        if (!billInEntity.getOrgId().equals(userEntity.getOrgId())) {
            log.warn("订单:{}的机构{}不属于当前管理员:{}的机构:{}", billId, billInEntity.getOrgId(), userEntity.getUserId(), userEntity.getOrgId());
            throw new RRException("订单的机构不属于当前管理员的机构");
        }
        RedisLock redisLock = new RedisLock(stringRedisTemplate, BILL_IN_UPDATE + billInEntity.getMerchantId());
        if (redisLock.lock()) {
            try {
                BillInEntity update = new BillInEntity();
                update.setId(billInEntity.getId());
                update.setBillId(billId);
                update.setBillStatus(statusEnum.getCode());
                update.setLastUpdate(new Date());
                update.setCreateTime(null);
                if (StringUtils.isNotEmpty(comment)) {
                    comment = Optional.ofNullable(billInEntity.getComment()).orElse("").concat("#" + comment);
                    update.setComment(comment);
                }
                if (statusEnum == BillConstant.BillStatusEnum.Success) {
                    int num = mapper.updateForPay(billInEntity.getId(), billInEntity.getOrgId(), billInEntity.getMerchantId());
                    if (num == 0) return R.error("请不要重复提交");
                    log.info("管理员或出款员:{}-{},确认订单:{}-{},结果:{}", userEntity.getUserId(), WebUtils.getIpAddr(), billId, statusEnum.getCode(), num > 1);
                    //商户可用余额充值
                    BalanceEntity balance = balanceService.createBalanceAccount(billInEntity.getMerchantId());
                    boolean result = balanceService.updateBalance(billInEntity.getMerchantId(), billInEntity.getPrice(), null, null);
                    log.info("更新商户:{}可用余额结果:{}", balance.getUserId(), result);
                    if (!result) {
                        throw new RRException("确认充值订单时，更新商户余额失败");
                    }
                    //更新专员可用余额
                    BankCardEntity bankCardQuery = new BankCardEntity();
                    bankCardQuery.setBusinessId(billInEntity.getBusinessId());
                    bankCardQuery.setBankCardNo(billInEntity.getBankCardNo());
                    BankCardEntity bankCardEntity = bankCardService.selectOne(bankCardQuery);
                    if (bankCardEntity == null) {
                        log.warn("出款专员:{}银行卡:{}未找到", billInEntity.getBusinessId(), billInEntity.getBankCardNo());
                        throw new RRException("出款专员银行卡未找到");
                    }
                    result = bankCardService.addBalance(billInEntity.getBusinessId(), billInEntity.getBankCardNo(), billInEntity.getPrice());
                    if (!result) {
                        throw new RRException("确认充值订单时，更新专员银行卡余额失败");
                    }
                    this.billInBusinessSuccess(billInEntity);
                }
                if (statusEnum == BillConstant.BillStatusEnum.Failed) {
                    int num = mapper.updateForUnPay(billInEntity.getId(), billInEntity.getOrgId(), billInEntity.getMerchantId());
                    if (num == 0) return R.error("请不要重复提交");
                    log.info("管理员或出款员:{}-{},确认订单:{}-{},结果:{}", userEntity.getUserId(), WebUtils.getIpAddr(), billId, statusEnum.getCode(), num > 1);
                }
                return CommonUtils.msg(1);
            } catch (Exception e) {
                e.printStackTrace();
                log.warn("商户:{}充值订单:{}确认异常:{}", billInEntity.getMerchantId(), billId, e.getMessage());
            } finally {
                redisLock.unLock();
            }
        }
        log.warn("商户:{}确认充值订单失败，未获取分布式锁", userEntity.getUserId());
        throw new RRException("确认充值订单失败，请稍后在操作。");
    }


    /**
     * 更新出款员账户余额
     *
     * @param entity
     */
    private void billInBusinessSuccess(BillInEntity entity) {
        balanceService.createBalanceAccount(entity.getBusinessId());
        balanceService.billOutBusinessBalance(entity.getPrice(), entity.getBusinessId(), entity.getBillId());
    }

    /**
     * 生成充值id
     * 订单号：商户id+ yyyyMMDD + 自增
     * 最长20位
     *
     * @return
     */
    private String generateBillInBillId(String merchantId) {
        if (globalProperties.isRedisSessionDao()) {
            String today = DateUtils.format(new Date(), DateUtils.DATE_PATTERN_1);
            String redisKey = BillConstant.BillRedisKey.billInId(merchantId, today);
            long incrId = redisCacheManager.incr(redisKey, 1L, 24L);
            ThreadLocalRandom random = ThreadLocalRandom.current();
            String billId = random.nextInt(10, 99) + merchantId + today + new DecimalFormat("00000").format(incrId) + random.nextInt(10, 99);
            log.info("redis自增 billId" + billId);
            return billId;
        } else {
            return this.getCurrentMerchantLastOrderId(merchantId);
        }
    }


    private String getCurrentMerchantLastOrderId(String merchantId) {
        synchronized (merchantId.intern()) {
            Long lastId = mapper.lastMerchantNewOrder(merchantId);
            String today = DateUtils.format(new Date(), DateUtils.DATE_PATTERN_1);
            ThreadLocalRandom random = ThreadLocalRandom.current();
            DecimalFormat df = new DecimalFormat("00000");//五位序列号
            long incrId = 1L;
            if (lastId != null) {
                incrId = lastId + 1;
            }
            return merchantId + today + random.nextInt(10, 99) + df.format(incrId);
        }
    }

}
