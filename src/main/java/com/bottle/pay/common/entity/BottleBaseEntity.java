package com.bottle.pay.common.entity;

import lombok.Data;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.io.Serializable;
import java.util.Date;


@Data
public abstract class BottleBaseEntity implements Serializable {

//    protected BottleBaseEntity() {
//        // TODO 对公共组件查询时有问题，我先注释了。我们还是在set时new Date() 吧 @mighty
////        this.lastUpdate = new Date();
//    }

    protected static final long serialVersionUID = 1L;


    // @Id表示该字段对应数据库表的主键id
    // @GeneratedValue中strategy表示使用数据库自带的主键生成策略.
    // @GeneratedValue中generator配置为"JDBC",在数据插入完毕之后,会自动将主键id填充到实体类中.类似普通mapper.xml中配置的selectKey标签
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY, generator = "JDBC")
    public Long id;

    /**
     *
     */
    public Date createTime;

    /**
     *
     */
    public Date lastUpdate;

    /**
     * 代理商id
     */
    public Long orgId;

    /**
     * 代理商姓名
     */
    public String orgName;

    /**
     * 查询开始时间
     */
    public Date startTime;

    /**
     * 查询结束时间
     */
    public Date endTime;
}
