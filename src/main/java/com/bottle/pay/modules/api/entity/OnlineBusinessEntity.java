package com.bottle.pay.modules.api.entity;

import com.bottle.pay.common.entity.BottleBaseEntity;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import javax.persistence.Table;

import lombok.ToString;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@Table(name = "online_business")
@ToString
@NoArgsConstructor
public class OnlineBusinessEntity extends BottleBaseEntity {

    /**
     * 付款专员姓名
     */
    private String businessName;

    /**
     * 付款专员ID
     */
    private Long businessId;

    /**
     *
     */
    private Integer position;


}
