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
		url: '../../apiV1/billOut/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
			{checkbox: true},
            {field : "id", title : "", width : "100px"},
            {field : "createTime", title : "时间", width : "100px"},
            // {field : "lastUpdate", title : "", width : "100px"},
            {field : "merchantName", title : "商户名", width : "100px"},
            {field : "merchantId", title : "商户ID", width : "100px"},
            {field : "billId", title : "订单号：商户id+时间戳 + 4位自增", width : "100px"},
            {field : "thirdBillId", title : "第三方订单号", width : "100px"},
            {field : "ip", title : "第三方订单派发服务器ip", width : "100px"},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px",visible:false},
            //：  1未支付 2 成功 3 失败
            {field : "billStatus", title : "订单状态", width : "100px",formatter:function (index,row) {
                     if(row.billStatus == 1) {return  "未支付"}
                     if(row.billStatus ==2) {return "成功"}
                     if(row.billStatus ==3) {return "失败"}
                }},
            //：1未通知 2 已通知 3 失败
            {field : "notice", title : "通知", width : "100px"},
            {field : "price", title : "账单金额", width : "100px"},
            {field : "bankCardNo", title : "付款会员的卡号", width : "100px"},
            {field : "bankName", title : "银行名称", width : "100px"},
            {field : "bankAccountName", title : "付款用户名", width : "100px"},
            //1 手动 2 自动 3 大额 4 订单退回机构
            {field : "billType", title : "操作", width : "100px"},
            {field : "agentId", title : "代理商id", width : "100px"},
            {field : "agentName", title : "代理商姓名", width : "100px"},
            {title : "操作", formatter : function(value, row, index) {
                    var _html = '';
                    if (hasPermission('apiV1:billOut:edit')) {
                        _html += '<a href="javascript:;" onclick="vm.edit(\''+row.id+'\')" title="编辑"><i class="fa fa-pencil"></i></a>';
                    }
                    if (hasPermission('apiV1:billOut:remove')) {
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
				url: 'modules/billOut/add.html?_' + $.now(),
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
                url: 'modules/billOut/edit.html?_' + $.now(),
                width: '420px',
                height: '350px',
                success: function(iframeId){
                    top.frames[iframeId].vm.billOut.id = id;
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
                url: '../../apiV1/billOut/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})