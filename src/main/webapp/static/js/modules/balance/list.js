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
		url: '../../merchant/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
			params.name = vm.keyword;
			return params;
		},
		columns: [
            {field : "userId", title : "用户ID", width : "100px"},
            {field : "userName", title : "用户名", width : "100px"},
            {field : "balance", title : "可用余额", width : "100px"},
            {field : "balanceFrozen", title : "冻结余额", width : "100px"},
            {field : "balancePaying", title : "支付中余额", width : "100px"},
            {field : "createTime", title : "创建时间", width : "100px"},
            {field : "orgName", title : "代理商姓名", width : "100px"},
            {field : "status", title : "状态", width : "100px",formatter:function(value){
                if(value == 0){
                return '禁用';
                }
                if(value == 1){
                return '可用';
                }
            }},
            {field : "bizType", title : "商户类型", width : "100px",formatter:function(value){return '代付商户'}},
            {field : "billOutLimit", title : "自动出款额度", width : "100px"},
            {field : "mobile", title : "手机", width : "100px"},
            {field : "email", title : "邮箱", width : "100px"},
            {field : "ipList", title : "ip", width : "100px",formatter:function(value){
                var _html_1 = '商户对应服务器:';
                var _html_2 = '商户登录后台:';
                for(var ip in value){
                    if(ip.type == 1){
                        _html_1 += ip.ipList;
                    }else if(ip.type == 2){
                        _html_2 += ip.ipList;
                    }
                }
                return _html_1 + '</br>' + _html_2;
            }}/*,
            {title : "操作", formatter : function(value, row, index) {
                    var _html = '';
//                    if (hasPermission('apiV1:balance:edit')) {
                        _html += '<a href="javascript:;" onclick="vm.edit(\''+row.ipList+'\')" title="修改IP"><i class="fa fa-pencil">修改IP</i></a>';
//                    }
//                    if (hasPermission('apiV1:balance:remove')) {
//                        _html += '<a href="javascript:;" onclick="vm.remove(false,\''+row.id+'\')" title="修改IP"><i class="fa fa-trash-o">IP修改</i></a>';
//                    }

                    return _html;
                }
            }*/
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
				url: 'modules/balance/add.html?_' + $.now(),
				width: '420px',
				height: '500px',
				yes : function(iframeId) {
					top.frames[iframeId].vm.acceptClick();
				},
			});
		},
		edit: function(ipList) {
            dialogOpen({
                title: '编辑',
                url: 'modules/iplimit/edit.html?_' + $.now(),
                width: '420px',
                height: '350px',
                success: function(iframeId){
                    top.frames[iframeId].vm.ipList = ipList;
//                    top.frames[iframeId].vm.setForm();
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
                url: '../../apiV1/balance/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
});