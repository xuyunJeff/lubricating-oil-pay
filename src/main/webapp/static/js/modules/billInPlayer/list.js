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
		url: '../../billInPlayer/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
            params.merchantName = $('#merchantName').val();
            params.businessName = $('#businessName').val();
            params.bankAccountName = $('#bankAccountName').val();
            params.thirdBillId = $('#thirdBillId').val();
            params.billId = $('#billId').val();
            params.billStatus = $('#billStatus').val();
            params.notice = $('#notice').val();
            params.billType = $('#billType').val();
            params.createTime = $('#createTime').val();
            return removeEmptyField(params);
		},
		columns: [
            {
                title: "操作",height : "40px" ,width: "40px", formatter: function (value, row, index) {
                    var _html = '';
                    if (hasPermission('apiV1:billOut:lock')) {
                        _html += '<a href="javascript:;" onclick="vm.billLock(\'' + row.billId + '\',\'' + index + '\')" title="锁定"> <i class="fa fa-key" aria-hidden="true"></i></a> </br> ';
                    }
                    if (hasPermission('apiV1:billOut:success')) {
                        _html += '<a href="javascript:;" onclick="vm.billSuccess(\'' + row.billId + '\',\'' + index + '\')" title="确认"><i class="fa fa-check"></i></a> </br> ';
                    }
                    if (hasPermission('apiV1:billOut:notice')) {
                        _html += '<a href="javascript:;" onclick="vm.notice(\'' + row.billId + '\')" title="通知"><i class="fa fa-bullhorn" aria-hidden="true"></i></a></br>';
                    }
                    return _html;
                }
            },
            {field: "id", title: "序号", width: "30px"},
            {field : "createTime", title : "时间", width : "180px"},
            {field : "lastUpdate", title : "更新时间", width : "180px"},
            {field : "merchantName", title : "商户名", width : "100px"},
            {field : "businessName", title : "收款专员姓名", width : "100px"},
            {field : "businessId", title : "收款专员ID", width : "100px", visible: false},
            {field : "businessBankCardNo", title : "收款的卡号(或二维码地址)", width : "100px"},
            {field : "businessBankName", title : "银行名称", width : "100px"},
            {field : "billStatus", title : "订单状态", width : "60px", formatter: function (index, row) {
                    if (row.billStatus == 1) {
                        var msg ="未支付";
                        if(row.isLock == 1) {
                            msg += "</br>已锁"
                        }
                        if(row.isLock == 0) {
                            msg += "</br>未锁"
                        }
                        return msg
                    }
                    if (row.billStatus == 2) {

                        return "成功"
                    }
                    if (row.billStatus == 3) {
                        return "失败"
                    }
                }},
            {field : "price", title : "账单金额", width : "100px"},
            {field : "playerAccountName", title : "玩家名", width : "100px"},
            {field : "orgId", title : "代理商id", width : "100px" , visible: false},
            {field : "orgName", title : "代理商姓名", width : "100px"},
            // {field : "comment", title : "", width : "100px"},
            {field : "billInPlayerType", title : "支付方式", width : "100px"},
            {field : "thirdBillId", title : "第三方订单号", width : "100px"},
            {field : "billId", title : "订单号", width : "100px"},
            {field : "merchantId", title : "商户ID", width : "100px", visible: false},
            {field: "ip", title: "支付ip", width: "100px"}
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
				url: 'modules/billInPlayer/add.html?_' + $.now(),
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
                url: 'modules/billInPlayer/edit.html?_' + $.now(),
                width: '420px',
                height: '350px',
                success: function(iframeId){
                    top.frames[iframeId].vm.billInPlayer.id = id;
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
                url: '../../billInPlayer/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})