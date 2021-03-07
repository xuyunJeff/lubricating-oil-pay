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
		url: '../../apiV1/reportMerchant/list?_' + $.now(),
		height: $(window).height()-56,
		queryParams: function(params){
            params.merchantName = $('#merchantName').val();
            params.resultDate = $('#resultDate').val();
            return removeEmptyField(params);
		},
		columns: [
            {field : "createTime", title : "", width : "100px",visible : false},
            {field : "lastUpdate", title : "", width : "100px",visible : false},
            {field : "orgId", title : "机构ID", width : "100px",visible : false},
            {field : "merchantName", title : "商户名", width : "100px"},
            {field : "orgName", title : "所属机构", width : "100px"},
            {field : "resultDate", title : "报表时间", width : "100px"},
            {field : "totalPayCount", title : "出款总笔数", width : "100px"},
            {field : "totalPaySum", title : "出款总计", width : "100px"},
            {field : "merchantId", title : "商户ID", width : "100px",visible : false}
            // {field : "totalTopupSum", title : "商户总充值", width : "100px"}
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
				url: 'modules/reportMerchant/add.html?_' + $.now(),
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
                url: 'modules/reportMerchant/edit.html?_' + $.now(),
                width: '420px',
                height: '350px',
                success: function(iframeId){
                    top.frames[iframeId].vm.reportMerchant.id = id;
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
                url: '../../apiV1/reportMerchant/remove?_' + $.now(),
                param: ids,
                success: function(data) {
                    vm.load();
                }
            });
        }
	}
});