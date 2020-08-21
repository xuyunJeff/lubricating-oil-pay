/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		balanceProcurement: {
			id: 0
		}
	},
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../balance/procurement/save?_' + $.now(),
		    	param: vm.balanceProcurement,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		},
        outBusiness:function () {
			alert("outBusiness")
        },
        outBankCard:function () {
            alert("outBankCard")
        },
        inBusiness:function () {
            alert("inBusiness")
        },
        inBankCard:function () {
            alert("inBankCard")
        }
	}
})
