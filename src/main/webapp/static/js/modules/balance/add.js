/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		balance: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../apiV1/balance/save?_' + $.now(),
		    	param: vm.balance,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
