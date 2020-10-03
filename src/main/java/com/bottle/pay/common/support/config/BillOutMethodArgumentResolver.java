package com.bottle.pay.common.support.config;

import com.bottle.pay.common.annotation.BillOut;
import com.bottle.pay.common.exception.RRException;
import com.bottle.pay.common.utils.AESUtil;
import com.bottle.pay.common.utils.GsonUtil;
import com.bottle.pay.modules.api.entity.BillOutView;
import com.bottle.pay.modules.api.service.MerchantServerService;
import com.bottle.pay.modules.sys.entity.SysUserEntity;
import com.bottle.pay.modules.sys.service.SysUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
@Slf4j
public class BillOutMethodArgumentResolver implements HandlerMethodArgumentResolver {

    @Autowired
    SysUserService userService;

    @Autowired
    MerchantServerService merchantServerService;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        if (parameter.getParameterType().isAssignableFrom(BillOutView.class) && parameter.hasParameterAnnotation(BillOut.class)) {
            return true;
        }
        return false;
    }

    // 初始密文 时间去解 domian:port/xxx/xxx?parm=B96390CDE4496DF913118AF5A5E4BD328DB33185CF7A6F7237FF2A865A57A03B1521785338526

    // { key: 'B96390CDE4496DF913118AF5A5E4BD328DB33185CF7A6F7237FF2A865A57A03B',value:'username'}
    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer modelAndViewContainer, NativeWebRequest webRequest, WebDataBinderFactory webDataBinderFactory) throws Exception {
        String param = webRequest.getParameter("param").trim();
        log.info("派单解密前:"+param);
        String decryptStep1 =  AESUtil.decrypt2(param);
        String[] valueMap = decryptStep1.split("&");
        SysUserEntity user  =userService.getByUserName(valueMap[1]);
        String value = AESUtil.decrypt1(valueMap[0],user.getPassword());
        BillOutView billOutView= GsonUtil.GsonToBean(value,BillOutView.class);
        Boolean accordance=merchantServerService.billMerchangtAccordanceMerchant(billOutView.getMerchantId(),billOutView.getMerchantName(),user.getUserId());
        if (accordance){
            return billOutView;
        }


        throw new RRException("订单商户号和服务器不一致");
    }
}
