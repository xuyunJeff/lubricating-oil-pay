/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billOut: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../apiV1/billOut/save?_' + $.now(),
		    	param: vm.billOut,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
