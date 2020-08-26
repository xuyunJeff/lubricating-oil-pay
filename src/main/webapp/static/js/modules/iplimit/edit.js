/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		ipLimit: {
			id: 0
		}
	},
//    data: {
//		balance: {
//			id: 0
//		}
//	},
	methods : {
		setForm: function() {
//			$.SetForm({
//				url: '../../merchant/ip/info?_' + $.now(),
//		    	param: vm.ipLimit.id,
//		    	success: function(data) {
//		    		ipLimit = data
//		    	}

//			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../merchant/ip/update?_' + $.now(),
		    	param: vm.ipLimit,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})