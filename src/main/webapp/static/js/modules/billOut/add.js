/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billOut: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
            var billout = vm.billOut;
            billout.timeMsec= Date.parse(new Date());
		    $.SaveForm({
		    	url: '../../apiV1/billOut//push/order?_' + $.now(),
		    	param: billout,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}
	}
})
