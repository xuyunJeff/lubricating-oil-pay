package com.bottle.pay.common.support.config;

import org.apache.http.HeaderElement;
import org.apache.http.HeaderElementIterator;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.ConnectionKeepAliveStrategy;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicHeaderElementIterator;
import org.apache.http.protocol.HTTP;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;


/**
 * @ClassName: RestTemplateConfig
 * @Author: R.M.I
 * @CreateTime: 2019年02月23日 11:16:00
 * @Description: TODO
 * @Version 1.0.0
 */
@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate(ClientHttpRequestFactory clientHttpRequestFactory) {
        //此处可设置特定的http状态返回值验证
        return new RestTemplate(clientHttpRequestFactory);
    }

    @Bean
    public ClientHttpRequestFactory httpRequestFactory(HttpClient httpClient) {
        return new HttpComponentsClientHttpRequestFactory(httpClient);
    }


    @Bean
    public CloseableHttpClient httpClient() {
        Registry registry = RegistryBuilder.create().register("https", SSLConnectionSocketFactory.getSocketFactory())
                .register("http", new PlainConnectionSocketFactory()).build();
        PoolingHttpClientConnectionManager clientConnectionManager = new PoolingHttpClientConnectionManager(registry);
        clientConnectionManager.setMaxTotal(800);
        clientConnectionManager.setDefaultMaxPerRoute(800);
        clientConnectionManager.setValidateAfterInactivity(600000);
        RequestConfig requestConfig = RequestConfig.custom().
                //服务器返回数据(response)的时间，超过该时间抛出read timeout
                        setSocketTimeout(30000)
                // 连接超时
                .setConnectTimeout(30000)
                //连接不够用的等待时间，不宜过长，必须设置，比如连接不够用时，时间过长将是灾难性的
                .setConnectionRequestTimeout(1000)
                .build();

        ConnectionKeepAliveStrategy keepAliveStrategy = (response, context) -> {
            HeaderElementIterator it = new BasicHeaderElementIterator(response.headerIterator(HTTP.CONN_KEEP_ALIVE));
            while (it.hasNext()) {
                HeaderElement he = it.nextElement();
                String param = he.getName();
                String value = he.getValue();
                if (value != null && param.equalsIgnoreCase("timeout")) {
                    try {
                        return Long.parseLong(value) * 1000;
                    } catch (NumberFormatException ignore) {

                    }
                }
            }
            //  HttpHost target = (HttpHost) context.getAttribute(HttpClientContext.HTTP_TARGET_HOST);
            return 60 * 1000;
        };
        return HttpClients.custom()
                .setConnectionManager(clientConnectionManager)
                .setConnectionManagerShared(true)
                .setDefaultRequestConfig(requestConfig)
                .setKeepAliveStrategy(keepAliveStrategy)
                .build();
    }

}
