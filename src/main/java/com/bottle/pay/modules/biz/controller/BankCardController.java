package com.bottle.pay.modules.biz.controller;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.utils.ShiroUtils;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.biz.service.BankCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bottle.pay.common.annotation.SysLog;
import com.bottle.pay.modules.sys.controller.AbstractController;
import com.bottle.pay.common.entity.Page;
import com.bottle.pay.common.entity.R;
import lombok.extern.slf4j.Slf4j;
import tk.mybatis.mapper.util.Assert;


@RestController
@RequestMapping("test/bankCard")
@Slf4j
public class BankCardController extends AbstractController {

    @Autowired
    private BankCardService bankCardService;


    /**
     * 分页获取机构下所有银行卡列表
     *
     * @param params
     * @return
     */
    @RequestMapping("/org/list")
    public Page<BankCardEntity> list(@RequestBody Map<String, Object> params) {
        Long orgId = (Long) Optional.ofNullable(params.get("orgId")).orElse(0L);
        if (orgId <= 0L) {
            throw new RRException("机构ID不能为空");
        }
        return bankCardService.listEntity(params);
    }

    /**
     * 查询专员银行卡列表
     * 可以查询当前登陆的专员银行卡列表
     * 也可查询指定专员银行卡列表
     *
     * @param userId
     * @return
     */
    @RequestMapping("/commissioner/list")
    public List<BankCardEntity> getByUserId(Long userId) {
        userId = Optional.ofNullable(userId).orElse(ShiroUtils.getUserId());
        Assert.notNull(userId, "专员ID不正确");
        return bankCardService.getCardListByBusinessId(userId);
    }


    /**
     * 新增
     *
     * @param bankCard
     * @return
     */
    @SysLog("新增")
    @RequestMapping("/save")
    public R save(@RequestBody BankCardEntity bankCard) {
        return bankCardService.bindCard(bankCard);
    }

    /**
     * 根据id查询详情
     *
     * @param id
     * @return
     */
    @RequestMapping("/info")
    public R getById(Long id) {
        return bankCardService.getEntityById(id);
    }

    /**
     * 启用银行卡
     *
     * @return
     */
    @RequestMapping("/enable")
    public R enableCard(Long userId, String cardNo) {
        return bankCardService.enableCardByUserIdAndCardNo(userId, cardNo);
    }

    /**
     * 禁用银行卡
     *
     * @return
     */
    @RequestMapping("/disable")
    public R disableCard(Long userId, String cardNo) {
        return bankCardService.disableCardByUserIdAndCardNo(userId, cardNo);
    }

    /**
     * 修改
     *
     * @param bankCard
     * @return
     */
//	@SysLog("修改")
//	@RequestMapping("/update")
    public R update(@RequestBody BankCardEntity bankCard) {
        return bankCardService.updateEntity(bankCard);
    }

    /**
     * 删除
     *
     * @param id
     * @return
     */
    @SysLog("删除")
    @RequestMapping("/remove")
    public R batchRemove(@RequestBody Long[] id) {
        return bankCardService.removeBankCard(id);
    }

}
