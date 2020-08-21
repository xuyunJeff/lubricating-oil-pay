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
		url: '../..//balance/procurement/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
            params.createTime = $('#createTime').val()
            params.inBusinessName = $('#inBusinessName').val()
            params.outBusinessName = $('#outBusinessName').val()
			return removeEmptyField(params);
		},
		columns: [
            {field : "outBusinessId", title : "", width : "100px",visible:false},
            {field : "inBusinessName", title : "转入专员", width : "70px"},
            {field : "outBusinessName", title : "转出专员", width : "70px"},
            {field : "inBusinessId", title : "付款专员ID", width : "100px",visible:false},
            {field : "price", title : "账单金额", width : "100px"},
            {field : "createTime", title : "时间", width : "180px"},
            {field : "lastUpdate", title : "", width : "100px",visible:false},
            {field : "orgId", title : "代理商id", width : "100px",visible:false},
            {field : "inBeforeBalance", title : "转入卡转入前余额", width : "70px"},
            {field : "inAfterBalance", title : "转入卡转入后余额", width : "70px"},
            {field : "inBankCardNo", title : "转入卡号", width : "180px"},
            {field : "inBankName", title : "转入银行名称", width : "70px"},
            {field : "outBeforeBalance", title : "转出卡转出前余额", width : "70px"},
            {field : "outAfterBalance", title : "转出卡转出后余额", width : "70px"},
            {field : "outBankCardNo", title : "转出卡号", width : "180px"},
            {field : "outBankName", title : "转出银行名称", width : "70px"}
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
		save: function() {
			dialogOpen({
				title: '新增',
				url: 'modules/procurement/add.html?_' + $.now(),
                width: '800px',
                height: '420px',
				yes : function(iframeId) {
					top.frames[iframeId].vm.acceptClick();
				}
			});
		}
	}
})