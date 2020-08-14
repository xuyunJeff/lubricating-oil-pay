/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		onlineBusiness: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../apiV1/onlineBusiness/save?_' + $.now(),
		    	param: vm.onlineBusiness,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
