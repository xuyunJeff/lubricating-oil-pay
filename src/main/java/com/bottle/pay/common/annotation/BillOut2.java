package com.bottle.pay.common.annotation;

import java.lang.annotation.*;

@Target({ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface BillOut2 {

    String value() default "billOut2";
}
