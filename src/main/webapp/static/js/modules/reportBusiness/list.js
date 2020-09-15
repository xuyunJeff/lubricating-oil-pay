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
		url: '../../report/business/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
            {field : "createTime", title : "", width : "100px",visible : false},
            {field : "lastUpdate", title : "", width : "100px",visible : false},
            {field : "orgId", title : "代理商id", width : "100px",visible : false},
            {field : "resultDate", title : "报表时间", width : "100px"},
            {field : "orgName", title : "代理商姓名", width : "100px"},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px"},
            {field : "totalPayCount", title : "出款总笔数(成功)", width : "100px"},
            {field : "totalPaySum", title : "出款总计(成功)", width : "100px"},
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
})