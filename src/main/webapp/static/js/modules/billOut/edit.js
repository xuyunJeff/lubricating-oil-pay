/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billOut: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../apiV1/billOut/info?_' + $.now(),
		    	param: vm.billOut.id,
		    	success: function(data) {
		    		vm.billOut = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../apiV1/billOut/update?_' + $.now(),
		    	param: vm.billOut,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})