/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		bank: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../sys/bank/save?_' + $.now(),
		    	param: vm.bank,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
