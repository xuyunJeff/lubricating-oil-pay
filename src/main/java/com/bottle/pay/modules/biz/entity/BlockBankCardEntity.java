package com.bottle.pay.modules.biz.entity;

import lombok.Data;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;

/**
 * Created by zhy on 2020/8/13.
 */

@Data
@Table(name = "block_bank_card")
public class BlockBankCardEntity implements Serializable {

    private static final long serialVersionUID = 1L;

    // @Id表示该字段对应数据库表的主键id
    // @GeneratedValue中strategy表示使用数据库自带的主键生成策略.
    // @GeneratedValue中generator配置为"JDBC",在数据插入完毕之后,会自动将主键id填充到实体类中.类似普通mapper.xml中配置的selectKey标签
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY,generator = "JDBC")
    private Long id;

    /**
     *
     */
    private Date createTime;

    /**
     * 付款会员的卡号
     */
    private String bankCardNo;

    /**
     * 银行名称
     */
    private String bankName;

    /**
     * 付款用户名
     */
    private String bankAccountName;

    /**
     * 代理商id
     */
    private Integer agentId;

    /**
     * 代理商姓名
     */
    private String agentName;

}
