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
        url: '../../apiV1/onlineBusiness/list?_' + $.now(),
        height: $(window).height()-56,
        singleSelect : true,
        queryParams: function(params){
            params.businessName = $('#businessName').val()
            return removeEmptyField(params);
        },
        columns: [
            {checkbox: true},
            {field : "businessName", title : "付款专员姓名", width : "100px"},
            {field : "businessId", title : "付款专员ID", width : "100px",visible:false}
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
        save: function(billId) {
           var row = $('#dataGrid').bootstrapTable('getSelections');
                        if (row.length > 0) {
                                var businessId = row[0].businessId;
                                var businessName = row[0].businessName;
                            $.ConfirmAjax({
                                msg : "指定订单给"+businessName+"？",
                                url: '../../apiV1/billOut/appoint/human?billId='+billId+'&businessId='+businessId+'&_' + $.now(),
                                success: function(data) {
                                    vm.load();
                                }
                            });
                            }

        },
        auto: function () {
            // TODO 自动派单开关 @rmi
        }
    }
})