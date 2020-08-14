/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		onlineBusiness: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../apiV1/onlineBusiness/info?_' + $.now(),
		    	param: vm.onlineBusiness.id,
		    	success: function(data) {
		    		vm.onlineBusiness = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../apiV1/onlineBusiness/update?_' + $.now(),
		    	param: vm.onlineBusiness,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})