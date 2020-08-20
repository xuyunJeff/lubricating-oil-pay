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
		url: '../../apiV1/bankCard/list?_' + $.now(),
		height: $(window).height()-56,
        singleSelect:true,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
			{checkbox: true},
            {title : "操作", width : "55px", formatter : function(value, row, index) {
                    var _html = '';
                    if (hasPermission('bankCard:enable')) {
                        _html += '<a href="javascript:;" onclick="vm.enable(\''+row.bankCardNo+'\',true,null)" title="启用"><i class="fa fa-pencil"></i></a>';
                    }
                    if (hasPermission('bankCard:disable')) {
                        _html += '<a href="javascript:;" onclick="vm.enable(\''+row.bankCardNo+'\',false,\''+row.businessId+'\')" title="禁用"><i class="fa fa-trash-o"></i></a>';
                    }
                    return _html;
                }
            },
            {field : "createTime", title : "时间", width : "100px"},
            {field : "lastUpdate", title : "", width : "100px",visible:false},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px",visible:false},
            {field : "bankCardNo", title : "付款会员的卡号", width : "100px"},
            {field : "bankName", title : "银行名称", width : "100px"},
            {field : "bankAccountName", title : "付款用户名", width : "100px"},
            {field : "orgId", title : "代理商id", width : "100px",visible:false},
            {field : "orgName", title : "代理商姓名", width : "100px"},
            {field : "balance", title : "可用余额", width : "100px"},
            {field : "cardStatus", title : "1 可用 2 冻结 ", width : "100px"},
            {field : "enable", title : "0 禁用 1 启用", width : "100px"},
            {field : "balanceDailyLimit", title : "每日出款限额", width : "100px"}
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
				title: '新增银行卡',
				url: 'modules/bankCard/add.html?_' + $.now(),
				width: '420px',
				height: '350px',
				yes : function(iframeId) {
					top.frames[iframeId].vm.acceptClick();
				},
			});
		},
		enable: function(cardNo,enable,userId) {
		    if(enable){
                $.ConfirmAjax({
                    msg : "启用银行卡，会导致其他银行卡禁用",
                    url: '../../apiV1/bankCard/enable?cardNo='+cardNo+'&_' + $.now(),
                    success: function(data) {
                        vm.load();
                    }
                });
            }else {
                $.ConfirmAjax({
                    msg : "禁用银行卡，如果全部银行卡禁用会自动下线",
                    url: '../../apiV1/bankCard/disable?cardNo='+cardNo+'&userId='+userId+'&_' + $.now(),
                    success: function(data) {
                        vm.load();
                    }
                });
            }

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
                url: '../../bankCard/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
})