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
            {title : "操作", width : "90px", formatter : function(value, row, index) {
                    var _html = '';
                    if (hasPermission('apiV1:billOut:success')) {
                        _html += '<a href="javascript:;" onclick="vm.edit(\''+row.id+'\')" title="确认"><i class="fa fa fa-check"></i></a>';
                    }
                    if (hasPermission('apiV1:billOut:failed')) {
                        _html += '<a href="javascript:;" onclick="vm.edit(\''+row.id+'\')" title="作废"><i class="fa fa-times"></i></a>';
                    }
                    if (hasPermission('apiV1:billOut:goBack')) {
                        _html += '<a href="javascript:;" onclick="vm.remove(false,\''+row.id+'\')" title="回退"><i class="fa fa-reply"></i></a>';
                    }
                    if (hasPermission('apiV1:billOut:appoint:people')) {
                        _html += '<a href="javascript:;" onclick="vm.remove(false,\''+row.id+'\')" title="指定"><i class="fa fa-hand-pointer-o"></i></a>';
                    }
                    return _html;
                }
            },
            {field : "id", title : "序号", width : "30px"},
            {field : "createTime", title : "时间", width : "180px"},
            // {field : "lastUpdate", title : "", width : "100px"},
            {field : "merchantName", title : "商户名", width : "100px"},
            {field : "merchantId", title : "商户ID", width : "100px",visible:false},
            {field : "billId", title : "订单号", width : "100px"},
            {field : "thirdBillId", title : "第三方订单号", width : "100px"},
            {field : "ip", title : "ip", width : "100px"},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px",visible:false},
            //：  1未支付 2 成功 3 失败
            {field : "billStatus", title : "订单状态", width : "60px",formatter:function (index,row) {
                     if(row.billStatus == 1) {return  "未支付"}
                     if(row.billStatus ==2) {return "成功"}
                     if(row.billStatus ==3) {return "失败"}
                }},
            //：1未通知 2 已通知 3 失败
            {field : "notice", title : "通知", width : "60px",formatter:function (index,row) {
                    if(row.notice == 1) {return  "未通知"}
                    if(row.notice ==2) {return "已通知"}
                    if(row.notice ==3) {return "<div style='color: red'>通知失败</div>"}
                }},
            {field : "price", title : "账单金额", width : "100px"},
            {field : "bankCardNo", title : "付款会员的卡号", width : "180px",formatter:function (index,row) {
                    return row.bankCardNo + '<a href="javascript:;" onclick="vm.copyValue(\''+row.bankCardNo+'\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }},
            {field : "bankName", title : "银行名称", width : "100px",formatter:function (index,row) {
                return row.bankName +  '<a href="javascript:;" onclick="vm.copyValue(\''+row.bankName+'\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }},
            {field : "bankAccountName", title : "付款用户名", width : "100px",formatter:function (index,row) {
                    return row.bankAccountName +  '<a href="javascript:;" onclick="vm.copyValue(\''+row.bankAccountName+'\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }},
            //1 手动 2 自动 3 大额 4 订单退回机构
            {field : "billType", title : "派单", width : "100px",formatter:function (index,row) {
                    if(row.billType == 1) {return  "手动"}
                    if(row.billType ==2) {return "自动"}
                    if(row.billType ==3) {return "<div style='color: red'>大额</div>"}
                    if(row.billType ==4) {return "<div style='color: red'>订单退回机构</div>"}
            }
            },
            {field : "agentId", title : "代理商id", width : "100px",visible:false},
            {field : "agentName", title : "代理商姓名", width : "100px",visible:false},
            {field : "position", title : "订单位置", width : "100px",visible:false},
            {field : "businessBankCardNo", title : "付款卡号", width : "100px",visible:false},
            {field : "businessBankName", title : "付款银行", width : "100px",visible:false},
            {field : "businessBankAccountName", title : "付款卡姓名", width : "100px",visible:false}
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
        },
        copyValue:function (val) {
            var oInput = document.createElement('input');
            oInput.value = val;
            document.body.appendChild(oInput);
            oInput.select(); // 选择对象;
            console.log(oInput.value)
            document.execCommand("Copy",false);
            oInput.remove()
        }
	}
})