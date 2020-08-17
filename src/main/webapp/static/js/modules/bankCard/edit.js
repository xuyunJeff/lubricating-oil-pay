/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		bankCard: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../bankCard/info?_' + $.now(),
		    	param: vm.bankCard.id,
		    	success: function(data) {
		    		vm.bankCard = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../bankCard/update?_' + $.now(),
		    	param: vm.bankCard,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})