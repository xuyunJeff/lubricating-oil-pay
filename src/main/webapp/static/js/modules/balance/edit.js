/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		balance: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../apiV1/balance/info?_' + $.now(),
		    	param: vm.balance.id,
		    	success: function(data) {
		    		vm.balance = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../apiV1/balance/update?_' + $.now(),
		    	param: vm.balance,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})