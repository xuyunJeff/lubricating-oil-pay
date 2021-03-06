package com.bottle.pay.common.support.config;

import com.bottle.pay.common.support.interceptor.AuthorizationInterceptor;
import com.google.code.kaptcha.impl.DefaultKaptcha;
import com.google.code.kaptcha.util.Config;
import com.bottle.pay.common.support.interceptor.RestApiInterceptor;
import com.bottle.pay.common.support.properties.GlobalProperties;
import com.bottle.pay.common.xss.XssFilter;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.server.ErrorPage;
import org.springframework.boot.web.server.ErrorPageRegistrar;
import org.springframework.boot.web.server.ErrorPageRegistry;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.DependsOn;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.filter.DelegatingFilterProxy;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.*;

import java.io.File;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.List;
import java.util.Properties;

/**
 * web配置
 *
 * @author zcl<yczclcn@163.com>
 */
@DependsOn("springContextUtils")
@Configuration
public class WebConfig implements WebMvcConfigurer, ErrorPageRegistrar {

    @Autowired
    GlobalProperties globalProperties;

//    @Autowired
//    private AuthorizationInterceptor authorizationInterceptor;

    @Autowired
    private BillOutMethodArgumentResolver billOutMethodArgumentResolver;

    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        converters.add(responseBodyConverter());
    }

    public HttpMessageConverter responseBodyConverter() {
        StringHttpMessageConverter converter = new StringHttpMessageConverter(Charset.forName("UTF-8"));
        return converter;
    }


    /**
     * 文件上传路径虚拟映射
     *
     * @param registry
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        /*if (StringUtils.isBlank(globalProperties.getUploadLocation())) {
            throw new RuntimeException("文件上传路径为空，请先在application.yml中配置{global.upload-location}路径！");
        }
        if (!globalProperties.getUploadLocation().endsWith("/")) {
            throw new RuntimeException("文件上传路径必须以 / 结束！");
        }
        File uploadDest = new File(globalProperties.getUploadLocation());
        if (!uploadDest.exists()) {
            throw new RuntimeException("配置的文件上传路径不存在，请配置已存在的路径！");
        }*/
        registry.addResourceHandler(globalProperties.getRegisterUploadMapping())
                .addResourceLocations(globalProperties.getRegisterUploadLocation());
        registry.addResourceHandler("swagger-ui.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(billOutMethodArgumentResolver);

    }


    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 注册rest拦截器
        registry.addInterceptor(new RestApiInterceptor()).addPathPatterns("/rest/**").excludePathPatterns("/apiV1/billOut/push/order/server")
                .excludePathPatterns("/apiV1/billOut/get/order").excludePathPatterns("/apiV1/billOut/push2/order/server");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**").allowedOrigins("http://localhost:8080","http://45.63.124.216:8080","http://127.0.0.1:8080").allowCredentials(true).allowedMethods("*").maxAge(3600);
    }

    /**
     * shiroFilter注册
     *
     * @return
     */
    @Bean
    public FilterRegistrationBean shiroFilterRegistration() {
        FilterRegistrationBean registration = new FilterRegistrationBean();
        registration.setFilter(new DelegatingFilterProxy("shiroFilter"));
        //该值缺省为false，表示生命周期由SpringApplicationContext管理，设置为true则表示由ServletContainer管理
        registration.addInitParameter("targetFilterLifecycle", "true");
        registration.setOrder(Integer.MAX_VALUE - 1);
        registration.addUrlPatterns("/*");
        return registration;
    }

    /**
     * xssFilter注册
     *
     * @return
     */
    @Bean
    public FilterRegistrationBean xssFilterRegistration() {
        XssFilter xssFilter = new XssFilter();
//        xssFilter.setUrlExclusion(Arrays.asList("/rest/testAnon"));
        FilterRegistrationBean registration = new FilterRegistrationBean(xssFilter);
        registration.setOrder(Integer.MAX_VALUE);
        registration.addUrlPatterns("/*");
        return registration;
    }

    /**
     * 错误页面
     *
     * @param registry
     */
    @Override
    public void registerErrorPages(ErrorPageRegistry registry) {
        ErrorPage notFound = new ErrorPage(HttpStatus.NOT_FOUND, "/error/404");
        ErrorPage sysError = new ErrorPage(HttpStatus.INTERNAL_SERVER_ERROR, "/error/500");
        registry.addErrorPages(notFound, sysError);
    }

    /**
     * 验证码生成相关
     */
    @Bean
    public DefaultKaptcha kaptcha() {
        Properties properties = new Properties();
        properties.put("kaptcha.border", "no");
        properties.put("kaptcha.textproducer.font.color", "black");
        properties.put("kaptcha.image.width", "136");
        properties.put("kaptcha.image.height", "50");
        properties.put("kaptcha.textproducer.char.space", "3");
        properties.put("kaptcha.textproducer.font.names", "宋体,楷体,微软雅黑");
        Config config = new Config(properties);
        DefaultKaptcha defaultKaptcha = new DefaultKaptcha();
        defaultKaptcha.setConfig(config);
        return defaultKaptcha;
    }

}
