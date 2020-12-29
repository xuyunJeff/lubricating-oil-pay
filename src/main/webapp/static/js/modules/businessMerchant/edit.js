/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		businessMerchant: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../apiV1/businessMerchant/info?_' + $.now(),
		    	param: vm.businessMerchant.id,
		    	success: function(data) {
		    		vm.businessMerchant = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../apiV1/businessMerchant/update?_' + $.now(),
		    	param: vm.businessMerchant,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
});