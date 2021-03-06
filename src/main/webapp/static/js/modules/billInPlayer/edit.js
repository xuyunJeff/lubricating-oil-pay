/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billInPlayer: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../billInPlayer/info?_' + $.now(),
		    	param: vm.billInPlayer.id,
		    	success: function(data) {
		    		vm.billInPlayer = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../billInPlayer/update?_' + $.now(),
		    	param: vm.billInPlayer,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})