/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		frozenDetail: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../merchant/frozen/save?_' + $.now(),
		    	param: vm.frozenDetail,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
