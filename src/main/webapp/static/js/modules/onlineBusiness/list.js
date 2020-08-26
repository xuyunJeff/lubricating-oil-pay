/**
 * js
 */

$(function () {
	initialPage();
	getGrid();
});

function initialPage() {
	$(window).resize(function() {
		$('#dataGrid').bootstrapTable('resetView', {height: $(window).height()-56});
	});
}

function getGrid() {
	$('#dataGrid').bootstrapTableEx({
		url: '../../apiV1/onlineBusiness/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
			{checkbox: true},
            {title : "操作", width : "40px", formatter : function(value, row, index) {
                    var _html = '';
                    if (hasPermission('apiV1:onlineBusiness:enable')) {
                        _html += '<a href="javascript:;" onclick="vm.disable(\''+row.businessId+'\'\''+row.businessBankCardNo+'\')" title="禁用"><i class="fa fa-times"></i></a>';
                    }
                    return _html;
                }
            },
            {field : "agentId", title : "代理商id", width : "100px",visible : false},
            {field : "agentName", title : "代理商姓名", width : "100px",visible : false},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px",visible : false},
            {field : "payingBalance", title : "代付中余额", width : "100px"},
            {field : "balance", title : "余额", width : "100px"},
            {field : "bankCardNo", title : "付款卡号", width : "100px"},
            {field : "bankName", title : "付款银行", width : "100px"},
            {field : "bankAccountName", title : "付款卡姓名", width : "100px"},
            {field : "position", title : "位置", width : "100px"}
		]
	})
}

var vm = new Vue({
	el:'#dpLTE',
	data: {
		keyword: null
	},
	methods : {
		load: function() {
			$('#dataGrid').bootstrapTable('refresh');
		},
        disable: function(businessId,businessBankCardNo) {
            $.RemoveForm({
                url: '../../apiV1/onlineBusiness/offline?businessId='+businessId+'&businessBankCardNo='+businessBankCardNo+'&_' + $.now(),
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})