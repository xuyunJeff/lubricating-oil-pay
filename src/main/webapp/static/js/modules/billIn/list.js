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
		url: '../../merchant/charge/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
            params.merchantName = $('#merchantName').val()
            params.businessName = $('#businessName').val()
            params.billId = $('#billId').val()
            params.createTime = $('#createTime').val()
			return removeEmptyField(params);
		},
		columns: [
            {title : "操作", formatter : function(value, row, index) {
                    var _html = '';
                    if(row.billStatus==1){
                        _html += '<a href="javascript:;" onclick="vm.success(\''+row.billId+'\')" title="充值成功"><i class="fa fa fa-check"></i></a>';
                        _html += '<a href="javascript:;" onclick="vm.fail(\''+row.billId+'\')" title="充值失败"><i class="fa fa-times"></i></a>';
                    }
                    return _html;
                }
            },
            {field : "createTime", title : "创建时间", width : "180px"},
//            {field : "lastUpdate", title : "", width : "100px"},
            {field : "merchantName", title : "商户名", width : "100px"},
            {field : "merchantId", title : "商户ID", width : "100px"},
            {field : "billId", title : "订单号", width : "100px"},
            {field : "thirdBillId", title : "第三方订单号", width : "100px"},
            {field : "ip", title : "第三方订单派发服务器ip", width : "100px"},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px"},
            {field : "billStatus", title : "订单状态", width : "60px",formatter:function(value){
                if(value==1){
                    return '<div style=\'color: #FFA500\'>未支付</div>';
                }
                if(value ==2){
                    return '<div style=\'color: green\'>成功</div>';
                }
                if(value ==3){
                    return '<div style=\'color: blue\'>失败</div>';
                }
            }},
            {field : "price", title : "账单金额", width : "100px"},
            {field : "bankCardNo", title : "付款会员的卡号", width : "100px"},
            {field : "bankName", title : "银行名称", width : "100px"},
            {field : "bankAccountName", title : "付款用户名", width : "100px"},
            {field : "orgId", title : "代理商id", width : "100px"},
            {field : "orgName", title : "代理商姓名", width : "100px"},
            {field : "comment", title : "注解", width : "100px"}
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
				url: 'modules/billIn/add.html?_' + $.now(),
				width: '420px',
				height: '550px',
				yes : function(iframeId) {
					top.frames[iframeId].vm.acceptClick();
				},
			});
		},
		edit: function(id) {
            dialogOpen({
                title: '编辑',
                url: 'modules/billIn/edit.html?_' + $.now(),
                width: '420px',
                height: '520px',
                success: function(iframeId){
                    top.frames[iframeId].vm.billIn.id = id;
                    top.frames[iframeId].vm.setForm();
                },
                yes: function(iframeId){
                    top.frames[iframeId].vm.acceptClick();
                }
            });
        },
        success: function(billId){
            $.ConfirmAjax({
                msg : "确定订单充值成功？",
                url: '../../merchant/charge/success?billId='+billId+'&_' + $.now(),
                success: function(data) {
                    vm.load();
                }
            });
        },
        fail: function(billId) {
            $.ConfirmAjax({
                msg : "确定订单充值失败？",
                url: '../../merchant/charge/fail?billId='+billId+'&_' + $.now(),
                success: function(data) {
                    vm.load();
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
                url: '../../merchant/charge/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})