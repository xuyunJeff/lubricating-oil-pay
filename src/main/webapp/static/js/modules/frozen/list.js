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
		url: '../../merchant/frozen/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
			{checkbox: true},
            {field : "merchantName", title : "商户名", width : "100px"},
            {field : "merchantId", title : "商户ID", width : "100px"},
            {field : "balanceFrozen", title : "冻结余额", width : "100px"},
            {field : "balanceUnfrozen", title : "解冻余额", width : "100px"},
            {field : "bankCardNo", title : "付款会员的卡号", width : "100px"},
            {field : "bankName", title : "银行名称", width : "100px"},
            {field : "bankAccountName", title : "付款用户名", width : "100px"},
            {field : "createTime", title : "", width : "100px"},
            {field : "lastUpdate", title : "", width : "100px"},
            {field : "orgId", title : "代理商id", width : "100px"},
            {field : "orgName", title : "代理商姓名", width : "100px"},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px"},
            {title : "操作", formatter : function(value, row, index) {
                    var _html = '';
                    if (hasPermission('merchant:frozen:edit')) {
                        _html += '<a href="javascript:;" onclick="vm.edit(\''+row.id+'\')" title="编辑"><i class="fa fa-pencil"></i></a>';
                    }
                    if (hasPermission('merchant:frozen:remove')) {
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
				url: 'modules/frozen/add.html?_' + $.now(),
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
                url: 'modules/frozen/edit.html?_' + $.now(),
                width: '420px',
                height: '350px',
                success: function(iframeId){
                    top.frames[iframeId].vm.frozenDetail.id = id;
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
                url: '../../merchant/frozen/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})