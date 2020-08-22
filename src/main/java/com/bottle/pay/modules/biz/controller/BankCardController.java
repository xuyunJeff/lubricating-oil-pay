package com.bottle.pay.modules.biz.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.bottle.pay.common.constant.SystemConstant;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.utils.ShiroUtils;
import com.bottle.pay.modules.biz.entity.BankCardEntity;
import com.bottle.pay.modules.biz.service.BankCardService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;
import com.google.common.collect.Maps;
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
@RequestMapping("apiV1/bankCard")
@Slf4j
public class BankCardController extends AbstractController {

    @Autowired
    private BankCardService bankCardService;

    @Autowired
    SysUserService userService;


    /**
     * 查询银行卡
     *
     * @param params
     * @return
     */
    @RequestMapping("/list")
    public Page<BankCardEntity> list(@RequestBody Map<String, Object> params) {
        SysUserEntity user = getUser();
        if(user.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            params.put("businessId",user.getUserId());
            params.put("orgId",user.getOrgId());
            return bankCardService.listEntity(params);
        }
        if(user.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())
                ||user.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())){
            params.put("orgId",user.getOrgId());
            return bankCardService.listEntity(params);
        }
        if(user.getRoleId().equals(SystemConstant.SUPER_ADMIN)) {
            return bankCardService.listEntity(params);
        }
        throw  new RRException("角色越权");
    }


    /**
     * 查询银行卡
     *
     * @param
     * @return
     */
    @RequestMapping("/listForSelect")
    public R listForSelect() {
        SysUserEntity user = getUser();
        Map<String, Object> params = Maps.newHashMap();
        params.put("pageNumber",1);
        params.put("pageSize",10000);
        Page<BankCardEntity> page = null;
        if(user.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            params.put("businessId",user.getUserId());
            params.put("orgId",user.getOrgId());
            page =  bankCardService.listEntity(params);
        }
        if(user.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())
                ||user.getRoleId().equals(SystemConstant.RoleEnum.BillOutMerchant.getCode())){
            params.put("orgId",user.getOrgId());
            page =  bankCardService.listEntity(params);
        }
        if(user.getRoleId().equals(SystemConstant.SUPER_ADMIN)) {
            page =  bankCardService.listEntity(params);
        }
        if(page != null){
            return R.ok().put("rows",page.getRows());
        }
        throw  new RRException("角色越权");
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
    public R enableCard(String cardNo) {
        SysUserEntity user = getUser();
        if(!user.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            return R.error("只有出款员可以启用银行卡");
        }
        return bankCardService.enableCardByUserIdAndCardNo(user.getUserId(), cardNo);
    }

    /**
     * 禁用银行卡
     *
     * @return
     */
    @RequestMapping("/disable")
    public R disableCard(Long userId, String cardNo) {
        SysUserEntity loginUser = getUser();
        if(loginUser.getRoleId().equals(SystemConstant.RoleEnum.CustomerService.getCode())){
            // 出款员只能禁用自己的卡
            return bankCardService.disableCardByUserIdAndCardNo(loginUser.getUserId(), cardNo);
        }
        if(loginUser.getRoleId().equals(SystemConstant.RoleEnum.Organization.getCode())){
            SysUserEntity userEntity = userService.getUserEntityById(userId);
            if(userEntity.getOrgId().equals(loginUser.getOrgId())){
                return bankCardService.disableCardByUserIdAndCardNo(userId, cardNo);
            }
        }
        return R.error("角色越权");
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
