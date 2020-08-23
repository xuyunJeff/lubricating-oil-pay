/**
 * 编辑-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		frozenDetail: {
			id: 0
		}
	},
	methods : {
		setForm: function() {
			$.SetForm({
				url: '../../merchant/frozen/info?_' + $.now(),
		    	param: vm.frozenDetail.id,
		    	success: function(data) {
		    		vm.frozenDetail = data;
		    	}
			});
		},
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.ConfirmForm({
		    	url: '../../merchant/unFrozen?id='+vm.frozenDetail.id+'&unFrozen='+ vm.frozenDetail.balanceUnfrozen +'&time_' + $.now(),
//		    	param: vm.frozenDetail,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})