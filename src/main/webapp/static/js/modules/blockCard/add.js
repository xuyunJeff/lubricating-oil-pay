/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		blockBankCard: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../bankCard/block/save?_' + $.now(),
		    	param: vm.blockBankCard,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
