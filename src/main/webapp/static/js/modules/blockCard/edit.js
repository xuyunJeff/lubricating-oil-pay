/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		blockBankCard: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../bankCard/block/info?_' + $.now(),
		    	param: vm.blockBankCard.id,
		    	success: function(data) {
		    		vm.blockBankCard = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../bankCard/block/update?_' + $.now(),
		    	param: vm.blockBankCard,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})