package com.bottle.pay.modules.biz.view;

import com.bottle.pay.modules.biz.entity.IpLimitEntity;
import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
public class MerchantView {
    /**
     * 机构ID
     */
    private Long orgId;

    /**
     * 代理商姓名
     */
    public String orgName;
    /**
     * 商户ID
     */
    private Long userId;
    /**
     * 商户名称
     */
    private String userName;

    /**
     * 商户类型  代付
     */
    private String bizType;

    /**
     * 状态(0：禁用   1：正常)
     */
    private Integer status;
    /**
     * Ip白名单
     */
    private List<IpLimitEntity> ipList;
    /**
     * 手机
     */
    private String mobile;
    /**
     * 邮箱
     */
    private String email;

    /**
     * 自动出款上线额度，超出额度要手动派单
     */
    private BigDecimal billOutLimit;
    /**
     * 可用余额
     */
    private BigDecimal balance;

    /**
     * 冻结余额
     */
    private BigDecimal balanceFrozen;


    private Date createTime;

    public void setIpList(List<IpLimitEntity> list){
        if(list != null){
            list.stream().forEach(e->{
                e.setCreateTime(null);
                e.setLastUpdate(null);
                e.setOrgId(null);
                e.setOrgName(null);
            });
            this.ipList=list;
        }
    }



}
