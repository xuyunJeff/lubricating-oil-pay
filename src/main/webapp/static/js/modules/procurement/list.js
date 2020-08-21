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
		url: '../../balance/procurement/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
			{checkbox: true},
            {field : "outBusinessId", title : "", width : "100px"},
            {field : "outBusinessName", title : "调出专员姓名", width : "100px"},
            {field : "inBusinessName", title : "调入专员姓名", width : "100px"},
            {field : "inBusinessId", title : "付款专员ID", width : "100px"},
            {field : "price", title : "调度金额", width : "100px"},
            {field : "createTime", title : "创建时间", width : "100px"},
            {field : "lastUpdate", title : "最后更新时间", width : "100px"},
            {field : "orgId", title : "代理商id", width : "100px"},
            {field : "inBankCardNo", title : "付款会员的卡号", width : "100px"},
            {field : "inBankName", title : "银行名称", width : "100px"},
            {field : "outBankCardNo", title : "付款会员的卡号", width : "100px"},
            {field : "outBankName", title : "银行名称", width : "100px"},
            {field : "inBeforeBalance", title : "转入前金额", width : "100px"},
            {field : "outBeforeBalance", title : "转出前金额", width : "100px"},
            {field : "inAfterBalance", title : "转入后金额", width : "100px"},
            {field : "outAfterBalance", title : "转出后金额", width : "100px"},
            {title : "操作", formatter : function(value, row, index) {
                    var _html = '';
                    if (hasPermission(':balance:procurement:edit')) {
                        _html += '<a href="javascript:;" onclick="vm.edit(\''+row.id+'\')" title="编辑"><i class="fa fa-pencil"></i></a>';
                    }
                    if (hasPermission(':balance:procurement:remove')) {
                        _html += '<a href="javascript:;" onclick="vm.remove(false,\''+row.id+'\')" title="删除"><i class="fa fa-trash-o"></i></a>';
                    }
                    return _html;
                }
            }
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
				width: '420px',
				height: '350px',
				yes : function(iframeId) {
					top.frames[iframeId].vm.acceptClick();
				},
			});
		},
		edit: function(id) {
            dialogOpen({
                title: '编辑',
                url: 'modules/procurement/edit.html?_' + $.now(),
                width: '420px',
                height: '350px',
                success: function(iframeId){
                    top.frames[iframeId].vm.balanceProcurement.id = id;
                    top.frames[iframeId].vm.setForm();
                },
                yes: function(iframeId){
                    top.frames[iframeId].vm.acceptClick();
                }
            });
        },
        remove: function(batch, id) {
            var ids = [];
            if (batch) {
                var ck = $('#dataGrid').bootstrapTable('getSelections');
                if (!checkedArray(ck)) {
                    return false;
                }
                $.each(ck, function(idx, item){
                    ids[idx] = item.id;
                });
            } else {
                ids.push(id);
            }
            $.RemoveForm({
                url: '../../balance/procurement/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})