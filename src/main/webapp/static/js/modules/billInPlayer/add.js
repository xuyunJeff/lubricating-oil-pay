/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billInPlayer: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../billInPlayer/save?_' + $.now(),
		    	param: vm.billInPlayer,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
