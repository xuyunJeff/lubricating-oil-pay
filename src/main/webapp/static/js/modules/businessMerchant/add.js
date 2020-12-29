/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		businessMerchant: {
			id: 0
		}
	},
    mounted: function () {
        //商户选择下拉框
        $.AjaxFormNoMsg({
            url: '../../sys/user/listMerchant?_' + $.now(),
            success: function(data) {
                var list = data.rows;
                $('#merchantId').empty().append('<option value="-1"> 请选择</option>');
                for (var i = 0; i < list.length; i++) {
                    $('#merchantId').append('<option value="'+list[i].userId+'"> '+list[i].username+'</option>')
                }
            }
        });
        //专员选择下拉框
        $.AjaxFormNoMsg({
            url: '../../sys/user/listBusiness?_' + $.now(),
            success: function(data) {
                var list = data.rows;
                $('#businessId').empty().append('<option value="-1"> 请选择</option>');
                for (var i = 0; i < list.length; i++) {
                    $('#businessId').append('<option value="'+list[i].userId+'"> '+list[i].username+'</option>')
                }
            }
        })
    },
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../apiV1/businessMerchant/save?_' + $.now(),
		    	param: vm.businessMerchant,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		}


	}
});
