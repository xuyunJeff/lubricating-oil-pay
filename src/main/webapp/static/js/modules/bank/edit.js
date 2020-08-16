/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		bank: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../sys/bank/info?_' + $.now(),
		    	param: vm.bank.id,
		    	success: function(data) {
		    		vm.bank = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../sys/bank/update?_' + $.now(),
		    	param: vm.bank,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})