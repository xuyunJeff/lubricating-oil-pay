/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		billIn: {
			id: 0
		},
		bankCards:[]
	},

	mounted: function () {
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
            $.AjaxFormNoMsg({
                url: '../../apiV1/bankCard/listForSelect?_' + $.now(),
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
		    	url: '../../merchant/charge/save?_' + $.now(),
		    	param: vm.billIn,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		},
        bankCard:function () {
           var bankCard = $('#bankCardNo')
           var outBusiness =$('#businessId').val()
           bankCard.empty()
           for (var i = 0; i < bankCards.length; i++) {
              if(bankCards[i].businessId == outBusiness){
                   bankCard.append('<option value="'+bankCards[i].bankCardNo+'"> '+bankCards[i].bankAccountName+'-'+bankCards[i].bankCardNo+'-'+bankCards[i].bankName+'</option>')
              }
           }
        }
	}
})
