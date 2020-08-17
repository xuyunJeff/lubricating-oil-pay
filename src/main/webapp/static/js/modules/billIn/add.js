/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billIn: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../merchant/charge/save?_' + $.now(),
		    	param: vm.billIn,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
