/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		frozenDetail: {
			id: 0
		},
		bankCards:[]
	},
	mounted: function () {
	    //商户选择下拉框
        $.AjaxFormNoMsg({
            url: '../../sys/user/listMerchant?_' + $.now(),
            success: function(data) {
                var list = data.rows
                $('#merchantId').empty().append('<option value="-1"> 请选择</option>');
                for (var i = 0; i < list.length; i++) {
                    $('#merchantId').append('<option value="'+list[i].userId+'"> '+list[i].username+'</option>')
                }
            }
        })
        //专员选择下拉框
        $.AjaxFormNoMsg({
            url: '../../sys/user/listBusiness?_' + $.now(),
            success: function(data) {
                var list = data.rows
                $('#businessId').empty().append('<option value="-1"> 请选择</option>');
                $("#bankCardNo").empty().append('<option value="-1"> 请选择</option>');
                for (var i = 0; i < list.length; i++) {
                    $('#businessId').append('<option value="'+list[i].userId+'"> '+list[i].username+'</option>')
                }
            }
        })
        //专员银行卡选择下拉框
        $.AjaxFormNoMsg({
            url: '../../bankCard/listForSelect?_' + $.now(),
            success: function(data) {
                bankCards = data.rows
            }
        })
    },
	methods : {
		acceptClick: function() {
			if (!$('#form').Validform()) {
		        return false;
		    }
		    $.SaveForm({
		    	url: '../../merchant/frozen/add?_' + $.now(),
		    	param: vm.frozenDetail,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		},
        bankCard:function () {
           var bankCard = $('#bankCardNo');
           var outBusiness =$('#businessId').val();
           bankCard.empty().append('<option value="-1"> 请选择</option>');
           for (var i = 0; i < bankCards.length; i++) {
              if(bankCards[i].businessId == outBusiness){
                   bankCard.append('<option value="'+bankCards[i].bankCardNo+'"> '+bankCards[i].bankAccountName+'-'+bankCards[i].bankCardNo+'-'+bankCards[i].bankName+'</option>');
              }
           }
           console.log(bankCard)
        }
	}
})
