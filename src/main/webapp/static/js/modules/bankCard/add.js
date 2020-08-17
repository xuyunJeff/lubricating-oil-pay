/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		bankCard: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../bankCard/save?_' + $.now(),
		    	param: vm.bankCard,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
