package com.bottle.pay.modules.api.service;

import com.bottle.pay.common.constant.BillConstant;
import com.bottle.pay.common.entity.R;
import com.bottle.pay.common.exception.NoOnlineBusinessException;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.service.BottleBaseService;
import com.bottle.pay.common.support.redis.RedisCacheManager;
import com.bottle.pay.common.support.redis.RedisLock;
import com.bottle.pay.common.utils.DateUtils;
import com.bottle.pay.modules.api.dao.BillOutMapper;
import com.bottle.pay.modules.api.entity.*;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.biz.entity.BlockBankCardEntity;
import com.bottle.pay.modules.biz.service.BankCardService;
import com.bottle.pay.modules.biz.service.BlockBankCardService;
import com.bottle.pay.modules.external.service.BillOutNotifyService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

import static com.bottle.pay.common.constant.SystemConstant.BIG_DECIMAL_HUNDRED;


@Service("billOutService")
@Slf4j
public class BillOutService extends BottleBaseService<BillOutMapper, BillOutEntity> {

    @Autowired
    private RedisCacheManager redisCacheManager;

    @Autowired
    private BalanceService balanceService;

    @Autowired
    private OnlineBusinessService onlineBusinessService;
    @Autowired
    private BankCardService bankCardService;

    @Autowired
    BillOutNotifyService billOutNotifySercice;

    @Autowired
    private RedisTemplate<String, Object> redisTemplate;

    @Autowired
    private BlockBankCardService blockBankCardService;


    /**
     * 派单给机构
     *
     * @param billOutView
     * @param ip
     * @param userEntity
     * @return
     */
    @Transactional
    public BillOutEntity billsOutAgent(BillOutView billOutView, String ip, SysUserEntity userEntity) {
        Integer randmon = new Random().nextInt();
        //第一步保存订单
        log.info(randmon+"服务器派单 step 1 保存订单，billout:{}", billOutView);
        BillOutEntity bill = saveNewBillOut(billOutView.getMerchantName(), billOutView.getMerchantId(),
                billOutView.getOrderNo(), ip, userEntity.getOrgId(), userEntity.getOrgName(), billOutView.getPrice(),
                billOutView.getBankCardNo(), billOutView.getBankName(), billOutView.getBankAccountName());
        // 第二步 增加商户代付中余额，扣除商户可用余额
        log.info(randmon+"服务器派单 step 2 增加商户代付中余额，扣除商户可用余额，billout:{}", bill);
            billsOutBalanceChangeMerchant(billOutView.getMerchantId(), billOutView.getPrice(),bill.getBillId());
        log.info(randmon+"服务器派单 step 2余额变动成功 增加商户代付中余额，扣除商户可用余额，billout:{}", bill);
        return bill;
    }


    @Transactional
    public BillOutEntity billsOutAgent(BillOutView2 billOutView, String ip, SysUserEntity userEntity) {
        Integer randmon = new Random().nextInt();
        //第一步保存订单
        log.info(randmon+"服务器派单 step 1 保存订单，billout:{}", billOutView);
        BillOutEntity bill = saveNewBillOut(billOutView.getMerchantName(), billOutView.getMerchantId(),
                billOutView.getOrderNo(), ip, userEntity.getOrgId(), userEntity.getOrgName(), billOutView.getPrice(),
                billOutView.getBankCardNo(), billOutView.getBankName(), billOutView.getBankAccountName());
        // 第二步 增加商户代付中余额，扣除商户可用余额
        log.info(randmon+"服务器派单 step 2 增加商户代付中余额，扣除商户可用余额，billout:{}", bill);
        billsOutBalanceChangeMerchant(billOutView.getMerchantId(), billOutView.getPrice(),bill.getBillId());
        log.info(randmon+"服务器派单 step 2余额变动成功 增加商户代付中余额，扣除商户可用余额，billout:{}", bill);
        return bill;
    }

    @Async
    @Transactional
    public void billOutBatchAgentByPerson(List<BillOutViewPerson> billOutViewPersonList, String ip, SysUserEntity userEntity) {
        for ( BillOutViewPerson billOutView: billOutViewPersonList) {
//            if (StringUtils.isEmpty(billOutView.getOrderNo()) || StringUtils.isEmpty(billOutView.getOrderNo().trim())) {
//                String orderNo = this.generateBillOutBillId(String.valueOf(userEntity.getUserId()));
//                billOutView.setOrderNo("P" + orderNo);
//            }
            BillOutView billOut = new BillOutView();
            billOut.setBankAccountName(billOutView.getBankAccountName());
            billOut.setBankCardNo(billOutView.getBankCardNo());
            billOut.setBankName(billOutView.getBankName());
            billOut.setMerchantId(userEntity.getUserId());
            billOut.setMerchantName(userEntity.getUsername());
            billOut.setPrice(billOutView.getPrice());
            billOut.setOrderNo(billOutView.getOrderNo());
            // 第一步保存订单,派单给机构
            BillOutEntity bill = this.billsOutAgent(billOut, ip, userEntity);
            if (existBlockCard(billOutView.getBankCardNo(), userEntity.getOrgId())) {
                return ;
            }
            if (bill.getBillType().equals(BillConstant.BillTypeEnum.Auto.getCode())) {
                // 自动派单给出款员
                this.billsOutBusiness(bill);
            }
        }
    }

    /**
     * 自动派单给出款员
     *
     * @param entity
     * @return
     */
    @Async
    public BillOutEntity billsOutBusiness(BillOutEntity entity) {
        Map<OnlineBusinessEntity, BigDecimal> businessOnline = null;
        OnlineBusinessEntity onlineBusinessEntity = null;
        BigDecimal free;
        int tryTimes = 0;
        int onlineAll = onlineBusinessService.count();
        try {
            do {
                Map<OnlineBusinessEntity, BigDecimal> businessOnlineNext = getBusinessFreeBalance(entity);
                if (businessOnlineNext.equals(businessOnline)) break;
                businessOnline = businessOnlineNext;
                free = businessOnline.values().stream().findFirst().get();
                onlineBusinessEntity = businessOnline.keySet().stream().findFirst().get();
                tryTimes++;
                if (tryTimes == onlineAll) break;
            } while (free.subtract(entity.getPrice()).compareTo(BigDecimal.ZERO) == -1);
        } catch (NoOnlineBusinessException e) {
            // 订单改为手动
            BillOutEntity update = new BillOutEntity(entity.getBillId());
            update.setBillType(BillConstant.BillTypeEnum.ByHuman.getCode());
            mapper.updateBillOutByBillId(update);
            return entity;
        }
        // 第三步派单给出款员(事务)，付款银行卡默认为当前开启的银行卡
        entity = updateBillOutToBusiness(entity, onlineBusinessEntity);
        // 第四步增加出款员代付中余额，扣除可用余额 -- redis
        incrBusinessBillOutBalanceRedis(onlineBusinessEntity.getBusinessId(), entity.getPrice());
        //第五步扣除可用余额 -mysql
        return entity;
    }

    /**
     * 人工派单接口
     *
     * @param entity
     * @return
     */
    public BillOutEntity billsOutBusinessByHuman(BillOutEntity entity, OnlineBusinessEntity onlineBusinessEntity) {
        entity.setBillType(BillConstant.BillTypeEnum.ByHuman.getCode());
        incrBusinessBillOutBalanceRedis(onlineBusinessEntity.getBusinessId(), entity.getPrice());
        entity = updateBillOutToBusiness(entity, onlineBusinessEntity);
        return entity;
    }

    /**
     * 订单退回到机构
     *
     * @param entity
     * @return
     */
    @Transactional
    public BillOutEntity billsOutBusinessGoBack(BillOutEntity entity) {
        incrBusinessBillOutBalanceRedis(entity.getBusinessId(), entity.getPrice().multiply(BigDecimal.valueOf(-1)));
        entity.setPosition(BillConstant.BillPostionEnum.Agent.getCode());
        entity.setBillType(BillConstant.BillTypeEnum.GoBackAgent.getCode());
        int i = mapper.updateByBillOutId(entity);
        if (i == 0) {
            log.error("订单保存错误 {}", entity.toString());
            return entity;
        }
        // 扣除出款员付款中
        incrBusinessBillOutBalanceRedis(entity.getBusinessId(), entity.getPrice().multiply(BigDecimal.valueOf(-1)));
        // 增加出款员可用余额 不需要增加可用余额,因为未支付时没扣
        //bankCardService.minusBalance(entity.getBusinessId(), entity.getBusinessBankCardNo(), entity.getPrice().multiply(BigDecimal.valueOf(-1)));
        return entity;
    }

    /**
     * 出款成功确认订单
     *
     * @param entity
     * @return
     */
    @Transactional
    public BillOutEntity billsOutPaidSuccess(BillOutEntity entity) {
        log.info("出款成功,billId{}", entity);
        BillOutEntity successEntity = new BillOutEntity(entity.getBillId());
        successEntity.setBillStatus(BillConstant.BillStatusEnum.Success.getCode());
        RedisLock redisLock = new RedisLock(stringRedisTemplate, BillConstant.BILL_OUT_BUSINESS_CHANGE_TO_SUCCESS_LOCK +":"+entity.getBillId());
        if(redisLock.lock()) {
            try {
                int i = mapper.updateBillOutByBillIdForSuccess(successEntity);
                if (i == 0) {
                    log.warn("该订单支付状态已经是最终状态,无需确认订单");
                    throw new RRException("该订单支付状态已经是最终状态,无需确认订单");
                }
            }catch (Exception e){
                e.printStackTrace();
                log.warn("出款订单改变状态异常"+e.getMessage());
            }finally {
                redisLock.unLock();
            }
        }
        // 扣除出款员代付中 -- redis
        incrBusinessBillOutBalanceRedis(entity.getBusinessId(), entity.getPrice().multiply(BigDecimal.valueOf(-1)));
        // 扣除商户代付中
        balanceService.billOutMerchantChangePayingBalance(entity.getPrice().multiply(BigDecimal.valueOf(-1)), entity.getMerchantId(),entity.getBillId());
        bankCardService.minusBalance(entity.getBusinessId(), entity.getBusinessBankCardNo(), entity.getPrice());
        // 出款员扣除余额
        this.billOutBusinessPaySuccess(entity);
        return entity;
    }

    /**
     * 出款员扣除余额
     * @param entity
     */
    private void billOutBusinessPaySuccess(BillOutEntity entity){
        balanceService.createBalanceAccount(entity.getBusinessId());
        balanceService.billOutBusinessBalance(entity.getPrice().multiply(new BigDecimal(-1)),entity.getBusinessId(),entity.getBillId());
    }


    /**
     * 出款失败作废订单
     *
     * @param entity
     * @return
     */
    @Transactional(rollbackFor=Exception.class)
    public BillOutEntity billsOutPaidFailed(BillOutEntity entity) {
        log.info("出款作废,billId{}", entity);
        BillOutEntity failedEntity = new BillOutEntity(entity.getBillId());
        failedEntity.setBillStatus(BillConstant.BillStatusEnum.Failed.getCode());
        int i = mapper.updateBillOutByBillIdForFailed(failedEntity);
        if (i == 0) throw new RRException("该订单支付状态已经是最终状态不可作废");
        // 扣除出款员代付中 -- redis
        incrBusinessBillOutBalanceRedis(entity.getBusinessId(), entity.getPrice().multiply(BigDecimal.valueOf(-1)));
        // 增加可用余额,扣除代付中
        balanceService.billOutMerchantBalance(entity.getPrice().multiply(BigDecimal.valueOf(-1)), entity.getMerchantId(),entity.getBillId());
        //   bankCardService.minusBalance(entity.getBusinessId(),entity.getBusinessBankCardNo(),entity.getPrice().multiply(BigDecimal.valueOf(-1)));
        return entity;
    }


    @Transactional
    public BillOutEntity updateBillOutToBusiness(BillOutEntity entity, OnlineBusinessEntity onlineBusinessEntity) {
        entity.setPosition(BillConstant.BillPostionEnum.Business.getCode());
        entity.setBusinessName(onlineBusinessEntity.getBusinessName());
        entity.setBusinessId(onlineBusinessEntity.getBusinessId());
        BankCardEntity card = bankCardService.getCardOpenedListByBusinessId(onlineBusinessEntity.getBusinessId());
        if (card == null) {
            log.error("在线出款员无开启的银行卡" + onlineBusinessEntity.toString());
            throw new RRException("在线出款员无开启的银行卡");
        }
        entity.setBusinessBankAccountName(card.getBankAccountName());
        entity.setBusinessBankCardNo(card.getBankCardNo());
        entity.setBusinessBankName(card.getBankName());
        int i = mapper.updateBillOutByBillId(entity);
        if (i == 0) {
            log.error("订单保存错误 {}", entity.toString());
            throw new RRException("订单保存错误");
        }


        return entity;
    }

    /**
     * 获取在线出款员的空余余额和对应的在线出款员数据
     *
     * @param entity
     * @return
     */
    public Map<OnlineBusinessEntity, BigDecimal> getBusinessFreeBalance(BillOutEntity entity) {
        // 第一步获取商户绑定的在线出款员
        OnlineBusinessEntity businessOnline = onlineBusinessService.getNextBusiness(entity.getMerchantId());
        // 第二步判断出款员余额是否够出款
        BigDecimal businessTotalBalance = bankCardService.getAllCardsBalanceWithoutFrozen(businessOnline.getBusinessId());
        BigDecimal businessFreeBalance = getBusinessFreeBalance(businessTotalBalance, businessOnline);
        return Collections.singletonMap(businessOnline, businessFreeBalance);
    }

    /**
     * 计算在线出款员的空余余额
     *
     * @param businessTotalBalance
     * @param businessOnline
     * @return
     */
    private BigDecimal getBusinessFreeBalance(BigDecimal businessTotalBalance, OnlineBusinessEntity businessOnline) {
        BigDecimal businessPayingBalance = getBusinessBillOutBalance(businessOnline.getBusinessId());
        return businessTotalBalance.subtract(businessPayingBalance.divide(BIG_DECIMAL_HUNDRED));
    }

    /**
     * 增加商户代付中余额，扣除商户可用余额
     *
     * @param merchantId
     * @param amount
     */
    @Transactional
    public BalanceEntity billsOutBalanceChangeMerchant(Long merchantId, BigDecimal amount,String billId) {
        // step 1: 扣商户可用余额，增加商户代付中余额
        return balanceService.billOutMerchantBalance(amount, merchantId, billId);
    }


    /**
     * Redis 出款员代付中余额变动，返回变动后余额
     * <p>
     * 传入金额后，增加redis中的出款员余额
     *
     * @param businessId
     * @param amount     最小1，分为单位
     */
    public synchronized BigDecimal incrBusinessBillOutBalanceRedis(Long businessId, BigDecimal amount) {
        amount = amount.multiply(BigDecimal.valueOf(100));
        String redisKey = BillConstant.BillRedisKey.billOutBusinessBalance(businessId.toString());
        Object balance = redisCacheManager.get(redisKey);
        if (!ObjectUtils.isEmpty(balance)) {
            BigDecimal balanceAfter = BigDecimal.valueOf(redisCacheManager.incr(redisKey, Double.valueOf(amount.toString())));
            log.info("代付余额变动，变动前余额：" + balance + "分,变动后余额：" + balanceAfter + "分,变动金额：" + amount + "分");
            return balanceAfter.divide(BigDecimal.valueOf(100));
        }
        return getBusinessBillOutBalance(businessId);
    }

    /**
     * 获取出款员代付中余额
     *
     * @param businessId
     * @return 单位分
     */
    public BigDecimal getBusinessBillOutBalance(Long businessId) {
        String redisKey = BillConstant.BillRedisKey.billOutBusinessBalance(businessId.toString());
        Object balance = redisCacheManager.get(redisKey);
        if (ObjectUtils.isEmpty(balance)) {
            BigDecimal businessPaying = mapper.sumByBusinessId(businessId);
            if (businessPaying == null) {
                businessPaying = BigDecimal.ZERO;
            }
            businessPaying = businessPaying.multiply(BIG_DECIMAL_HUNDRED);
            redisCacheManager.set(redisKey, businessPaying);
            return businessPaying;
        }
        return new BigDecimal(String.valueOf(balance));
    }

    /**
     * 生成订单并保存到机构
     *
     * @param merchantName
     * @param merchantId
     * @param thirdBillId
     * @param ip
     * @param agentId
     * @param agentName
     * @param price
     * @param bankCardNo
     * @param bankName
     * @param bankAccountName
     * @return
     */
    public BillOutEntity saveNewBillOut(String merchantName, Long merchantId, String thirdBillId, String ip, Long agentId, String agentName, BigDecimal price, String bankCardNo, String bankName, String bankAccountName) {
        // 验证第三方订单号是否存在

        BillOutEntity entity = new BillOutEntity();

        entity.setCreateTime(new Date());
        entity.setMerchantName(merchantName);
        entity.setMerchantId(merchantId);
        entity.setBillId(generateBillOutBillId(String.valueOf(merchantId)));
        if(!StringUtils.isEmpty(thirdBillId)) {
            entity.setThirdBillId(thirdBillId);
            int count = mapper.selectCount(entity);
            if (count != 0) {
                throw new RRException("订单号已存在，orderNo = " + thirdBillId);
            }
        }else {
            entity.setThirdBillId("P"+entity.getBillId());
        }
        entity.setIp(ip);
        // 第三方服务器派单第一步派单给机构
        entity.setBusinessId(agentId);
        entity.setBusinessName(agentName);
        entity.setBillStatus(BillConstant.BillStatusEnum.UnPay.getCode());
        entity.setNotice(BillConstant.BillNoticeEnum.NotNotice.getCode());
        entity.setPrice(price);
        entity.setBankCardNo(bankCardNo);
        entity.setBankName(bankName);
        entity.setBankAccountName(bankAccountName);
        entity.setBillType(setBillType(price, merchantId).getCode());
        entity.setOrgId(agentId);
        entity.setOrgName(agentName);
        entity.setPosition(BillConstant.BillPostionEnum.Agent.getCode());
        entity.setLastUpdate(new Date());
        entity.setIsLock(0);
        int i = mapper.insert(entity);
        log.info("服务器订单 step 1 :保存，billOut{}", entity);
        if (i == 0) {
            log.error("订单保存错误 {}", entity.toString());
            throw new RRException("订单保存错误");
        }
        return entity;
    }

    /**
     * 判断该订单是自动还是手动：大额？
     *
     * @param price
     * @param merchantId
     * @return
     */
    private BillConstant.BillTypeEnum setBillType(BigDecimal price, Long merchantId) {
        BalanceEntity balance = balanceService.createBalanceAccount(merchantId);
        BigDecimal billOutLimit = balance.getBillOutLimit();
        if (price.compareTo(billOutLimit) == -1) {
            return BillConstant.BillTypeEnum.Auto;
        }
        return BillConstant.BillTypeEnum.HighPrice;
    }


    /**
     * 生成代付id
     * 订单号：商户id+ yyyyMMDD + 随机数 + 自增
     * 最长20位
     *
     * @return
     */
    public String generateBillOutBillId(String merchantId) {
        String today = DateUtils.format(new Date(), DateUtils.DATE_PATTERN_1);
        String redisKey = BillConstant.BillRedisKey.billOutId(merchantId, today);
        long incrId = redisCacheManager.incr(redisKey, 1L, 24L);
        log.info("redis自增" + incrId);
        ThreadLocalRandom random = ThreadLocalRandom.current();
        DecimalFormat df = new DecimalFormat("00000");//五位序列号
        return merchantId + today + random.nextInt(10, 99) + df.format(incrId);
    }

    public Long lastNewOrder(Long id, Long orgId, Long businessId) {
        String redisKey = BillConstant.BillRedisKey.billOutLastOrder(id, orgId, businessId);
        Object lastId = redisCacheManager.get(redisKey);
        if (ObjectUtils.isEmpty(lastId)) {
            lastId = mapper.lastNewOrder(id, orgId, businessId);
            if (ObjectUtils.isEmpty(lastId)) {
                return id;
            }
            redisCacheManager.set(redisKey, lastId, 5L);
        }
        return Long.valueOf(lastId.toString());
    }

    public int updateByBillOutToLock(BillOutEntity bill){
        bill.setIsLock(1);
        return mapper.updateByBillOutToLock(bill);
    }

    /**
     * 判断是否存在银行卡黑名单
     *
     * @param bankCardNo
     * @param orgId
     * @return
     */
    private boolean existBlockCard(String bankCardNo, Long orgId) {
        BlockBankCardEntity query = new BlockBankCardEntity();
        query.setOrgId(orgId);
        query.setBankCardNo(bankCardNo);
        BlockBankCardEntity card = blockBankCardService.selectOne(query);
        return null != card;
    }
}
