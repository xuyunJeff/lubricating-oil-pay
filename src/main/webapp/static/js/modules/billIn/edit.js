/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billIn: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../merchant/charge/info?_' + $.now(),
		    	param: vm.billIn.id,
		    	success: function(data) {
		    		vm.billIn = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../merchant/charge/update?_' + $.now(),
		    	param: vm.billIn,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})