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
		url: '../../apiV1/balanceChangeLog/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
            {field : "userName", title : "用户名", width : "100px"},
            {field : "roleName", title : "角色名称", width : "100px"},
            {field : "balanceAfter", title : "账变前余额", width : "100px"},
            {field : "balance", title : "账变金额", width : "100px"},
            {field : "balanceBefore", title : "账变后余额", width : "100px"},
            {field : "billId", title : "关联订单号", width : "250px"},
            {field : "message", title : "信息备注", width : "100px"}
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
		}
	}
});