package com.bottle.pay.common.constant;

import lombok.AllArgsConstructor;

/**
 * 系统级静态变量
 * @author zcl<yczclcn@163.com>
 */
public class SystemConstant {
	
	/**
	 * 超级管理员ID
	 */
	public static final long SUPER_ADMIN = 1;

	public static final String USER_LOGIN_REDI_KEY ="login";

	public static String getUserLoginRedisKey(String username){
		return USER_LOGIN_REDI_KEY+":"+username;
	}

	@AllArgsConstructor
	public enum  RoleEnum {
		CustomerService(2L,"出款员"), BillOutMerchant(3L,"代付商户"), Organization(4L,"机构管理员"),BillInMerchant(5L,"代收商户");

		private final Long code;
		private final String msg;

		public Long getCode() {
			return code;
		}

		public String getMsg() {
			return msg;
		}

	}

	/**
	 * 数据标识
	 */
	public static final String DATA_ROWS = "rows";
	
	/**
	 * 菜单类型
	 *
	 * @author ZhouChenglin
	 * @email: yczclcn@163.com
	 * @url: www.chenlintech.com
	 * @date 2017年8月8日 下午1:36:27
	 */
    public enum MenuType {
        /**
         * 目录
         */
    	CATALOG(0),
        /**
         * 菜单
         */
        MENU(1),
        /**
         * 按钮
         */
        BUTTON(2);

        private int value;

        private MenuType(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }
    
    /**
     * 定时任务状态
     *
     * @author ZhouChenglin
     * @email: yczclcn@163.com
     * @url: www.chenlintech.com
     * @date 2017年8月8日 下午1:36:17
     */
    public enum ScheduleStatus {
        /**
         * 正常
         */
    	NORMAL(1),
        /**
         * 暂停
         */
    	PAUSE(0);

        private int value;

        ScheduleStatus(int value) {
            this.value = value;
        }
        
        public int getValue() {
            return value;
        }
    }
    
    /**
     * 通用字典
     *
     * @author ZhouChenglin
     * @email yczclcn@163.com
     * @url www.chenlintech.com
     * @date 2017年8月15日 下午7:29:02
     */
    public enum MacroType {
    	
    	/**
    	 * 类型
    	 */
    	TYPE(0),
    	
    	/**
    	 * 参数
    	 */
    	PARAM(1);
    	
    	private int value;
    	
    	MacroType(int value) {
            this.value = value;
        }
        
        public int getValue() {
            return value;
        }
    	
    }
    
    /**
     * 通用变量，表示可用、禁用、显示、隐藏
     *
     * @author ZhouChenglin
     * @email yczclcn@163.com
     * @url www.chenlintech.com
     * @date 2017年8月15日 下午7:31:49
     */
    public enum StatusType {
    	
    	/**
    	 * 禁用，隐藏
    	 */
    	DISABLE(0),
    	
    	/**
    	 * 可用，显示
    	 */
    	ENABLE(1),
    	
    	/**
    	 * 显示
    	 */
    	SHOW(1),
    	
    	/**
    	 * 隐藏
    	 */
    	HIDDEN(0);
    	
    	private int value;
    	
    	StatusType(int value) {
            this.value = value;
        }
        
        public int getValue() {
            return value;
        }
    	
    }

}
