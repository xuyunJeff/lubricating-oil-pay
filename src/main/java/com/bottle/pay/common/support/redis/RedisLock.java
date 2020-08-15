package com.bottle.pay.common.support.redis;

import org.apache.commons.lang.StringUtils;
import org.springframework.data.redis.core.StringRedisTemplate;

import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;

/**
 * Created by zhy on 2020/8/15.
 */
public class RedisLock {

    /**
     * redis 默认锁过期时间
     */
    public static final Long DEFAULT_EXPIRE_TIME = 5*1000L;

    public static final String LOCK_PRE_STR = "redis:lock:%s";

    private StringRedisTemplate stringRedisTemplate;
    private String value;
    private String lockKey;
    private int tryTimes;

    public RedisLock(StringRedisTemplate stringRedisTemplate ,String key){
        init(stringRedisTemplate, key,null);
    }

    private void init(StringRedisTemplate stringRedisTemplate, String key,Integer tryTimes) {
        this.tryTimes = Optional.ofNullable(tryTimes).orElse(3);
        this.tryTimes = this.tryTimes>10?3:this.tryTimes;
        this.stringRedisTemplate = stringRedisTemplate;
        this.lockKey = String.format(LOCK_PRE_STR,key);
        this.value = null;
    }

    public RedisLock(StringRedisTemplate stringRedisTemplate ,String key,Integer tryTimes){
        init(stringRedisTemplate, key,tryTimes);
    }

    public boolean lock(){
        if(this.tryTimes<0){
            return false;
        }
        this.tryTimes--;
        String value = String.valueOf(System.currentTimeMillis() + DEFAULT_EXPIRE_TIME);
        boolean result = stringRedisTemplate.opsForValue().setIfAbsent(lockKey,value,DEFAULT_EXPIRE_TIME, TimeUnit.MILLISECONDS);
        if(result){
            this.value = value;
            return true;
        }
        try {
            Thread.sleep(ThreadLocalRandom.current().nextLong(0L,50L));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        String oldValue = stringRedisTemplate.opsForValue().get(lockKey);
        if(StringUtils.isNotEmpty(oldValue) && Long.valueOf(oldValue) <= System.currentTimeMillis()){
            //过期了,重新设置
            value = String.valueOf(System.currentTimeMillis() + DEFAULT_EXPIRE_TIME);
            String currentVal = stringRedisTemplate.opsForValue().getAndSet(lockKey,value);
            if(oldValue.equals(currentVal)){
                this.value = value;
                stringRedisTemplate.expire(lockKey,DEFAULT_EXPIRE_TIME,TimeUnit.MILLISECONDS);
                return true;
            }
        }
        return lock();
    }

    public void unLock(){
        String val = stringRedisTemplate.opsForValue().get(lockKey);
        if(StringUtils.isNotEmpty(val) && val.equals(this.value) ){
            stringRedisTemplate.delete(lockKey);
        }
    }
}
