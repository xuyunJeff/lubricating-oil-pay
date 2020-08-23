/**
 * 新增-js
 */
var vm = new Vue({
	el:'#dpLTE',
	data: {
		balanceProcurement: {
			id: 0
		},
		bankCards:[]
	},
    mounted: function () {
        $.AjaxFormNoMsg({
            url: '../../sys/user/listBusiness?_' + $.now(),
            success: function(data) {
                var list = data.rows
                $('#outBusiness').empty().append('<option value="-1"> 请选择</option>');
                $("#inBusiness").empty().append('<option value="-1"> 请选择</option>');
                for (var i = 0; i < list.length; i++) {
                    $('#outBusiness').append('<option value="'+list[i].userId+'"> '+list[i].username+'</option>')
                    $('#inBusiness').append('<option value="'+list[i].userId+'"> '+list[i].username+'</option>')
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
		    vm.outBusinessId = vm.
		    $.SaveForm({
		    	url: '../../balance/procurement/save?_' + $.now(),
		    	param: vm.balanceProcurement,
		    	success: function(data) {
		    		$.currentIframe().vm.load();
		    	}
		    });
		},
        outBankCard:function () {
            var outBankCard = $('#outBankCard')
			var outBusiness =$('#outBusiness').val()
            outBankCard.empty()
            for (var i = 0; i < bankCards.length; i++) {
				if(bankCards[i].businessId == outBusiness){
                    outBankCard.append('<option value="'+bankCards[i].bankCardNo+'"> '+bankCards[i].bankAccountName+'-'+bankCards[i].bankCardNo+'-'+bankCards[i].bankName+'</option>')
				}
            }
        },
        inBankCard:function () {
            var inBankCard = $('#inBankCard')
            var inBusiness =$('#inBusiness').val()
            inBankCard.empty()
            for (var i = 0; i < bankCards.length; i++) {
                if(bankCards[i].businessId == inBusiness){
                    inBankCard.append('<option value="'+bankCards[i].bankCardNo+'"> '+bankCards[i].bankAccountName+'-'+bankCards[i].bankCardNo+'-'+bankCards[i].bankName+'</option>')
                }
            }
        }
	}
})
