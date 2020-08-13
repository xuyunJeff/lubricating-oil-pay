/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		ipLimit: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../merchant/ip/save?_' + $.now(),
		    	param: vm.ipLimit,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
