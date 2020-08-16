/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		balanceProcurement: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../..//balance/procurement/info?_' + $.now(),
		    	param: vm.balanceProcurement.id,
		    	success: function(data) {
		    		vm.balanceProcurement = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../..//balance/procurement/update?_' + $.now(),
		    	param: vm.balanceProcurement,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})