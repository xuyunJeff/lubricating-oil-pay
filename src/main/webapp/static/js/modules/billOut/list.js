/**
 * js
 */

$(function () {
    initialPage();
    getGrid();
});

function initialPage() {
    $(window).resize(function () {
        $('#dataGrid').bootstrapTable('resetView', {height: $(window).height() - 56});
    });
}

function getGrid() {
    $('#dataGrid').bootstrapTableEx({
        url: '../../apiV1/billOut/list?_' + $.now(),
        height: $(window).height() - 56,
        rowStyle: vm.rowStyle, //通过自定义函数设置行样式
        queryParams: function (params) {
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
                    if (hasPermission('apiV1:billOut:goBack')) {
                        _html += '<a href="javascript:;" onclick="vm.billGoBackOrg(\'' + row.billId + '\')" title="回退"><i class="fa fa-reply"></i></a></br>  ';
                    }
                    if (hasPermission('apiV1:billOut:appoint:people')) {
                        _html += '<a href="javascript:;" onclick="vm.appointHuman(\'' + row.billId + '\')" title="指定"><i class="fa fa-hand-pointer-o"></i></a></br>';
                    }
                    if (hasPermission('apiV1:billOut:notice')) {
                        _html += '<a href="javascript:;" onclick="vm.notice(\'' + row.billId + '\')" title="通知"><i class="fa fa-bullhorn" aria-hidden="true"></i></a></br>';
                    }
                    return _html;
                }
            },
            {field: "id", title: "序号", width: "30px"},
            {field: "merchantName", title: "商户名", width: "100px"},
            {field: "createTime", title: "时间", width: "180px"},
            {field: "businessId", title: "付款专员ID", width: "100px", visible: false},
            //：  1未支付 2 成功 3 失败
            {
                field: "billStatus", title: "订单状态", width: "60px", formatter: function (index, row) {
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
                }
            },
            //：1未通知 2 已通知 3 失败
            {
                field: "notice", title: "通知", width: "100px", formatter: function (index, row) {
                    var noticeMsg = "";
                    if (hasPermission('apiV1:billOut:failed')) {
                        noticeMsg += '</br><a href="javascript:;" onclick="vm.billFailed(\'' + row.billId + '\')" title="作废"><i class="fa fa-times"></i></a>  ';
                    }
                    if (row.noticeMsg && row.noticeMsg != null) {
                        if (row.noticeMsg == "成功,已作废订单" || row.noticeMsg == "成功,已确认出款") {
                            noticeMsg = ": " + row.noticeMsg
                        } else {
                            noticeMsg = ": <span style='color: blue'>" + row.noticeMsg + "</span>"
                        }
                    }
                    if (row.notice == 1) {
                        return  "<div style='color: #ff383f'>未通知"+ noticeMsg +"</div>"
                    }
                    if (row.notice == 2) {
                        return "<div style='color: green'>已通知" + noticeMsg + "</div>"
                    }
                    if (row.notice == 3) {
                        return "<div style='color: #ff1a8f'>通知失败" + noticeMsg + "</div>"
                    }
                }
            },
            {
                field: "price", cellStyle: vm.border, title: "账单金额", width: "82px", formatter: function (index, row) {
                    return row.price + '<a href="javascript:;" onclick="vm.copyValue(\'' + row.price + '\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }
            },
            {
                field: "bankAccountName",
                cellStyle: vm.border,
                title: "会员名",
                width: "85px",
                formatter: function (index, row) {
                    return row.bankAccountName + '<a href="javascript:;" onclick="vm.copyValue(\'' + row.bankAccountName + '\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }
            },
            {
                field: "bankCardNo",
                cellStyle: vm.border,
                title: "会员银行卡号",
                width: "200px",
                formatter: function (index, row) {
                    return row.bankCardNo + '<a href="javascript:;" onclick="vm.copyValue(\'' + row.bankCardNo + '\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }
            },
            {
                field: "bankName",
                cellStyle: vm.border,
                title: "银行名称",
                width: "120px",
                formatter: function (index, row) {
                    return row.bankName + '<a href="javascript:;" onclick="vm.copyValue(\'' + row.bankName + '\')" title="复制"><i class="fa fa-files-o"></i></a>'
                }
            },
            //1 手动 2 自动 3 大额 4 订单退回机构
            {
                field: "billType", title: "派单", width: "60px", formatter: function (index, row) {
                    if (row.billType == 1) {
                        return "<div style='color: #FFA500'>手动</div>"
                    }
                    if (row.billType == 2) {
                        return "<div style='color: black'>自动</div>"
                    }
                    if (row.billType == 3) {
                        return "<div style='color: red'>大额</div>"
                    }
                    if (row.billType == 4) {
                        return "<div style='color: #FFA500'>订单退回机构</div>"
                    }
                }
            },
            {
                field: "businessName", title: "付款专员姓名", width: "100px", formatter: function (index, row) {
                    if (row.businessName == row.orgName) {
                        return "<div style='color: #FFA500'>" + row.businessName + "-机构</div>"
                    } else {
                        return row.businessName
                    }

                }
            },
            {field: "agentId", title: "代理商id", width: "100px", visible: false},
            {field: "agentName", title: "代理商姓名", width: "100px", visible: false},
            {field: "position", title: "订单位置", width: "100px", visible: false},
            {field: "businessBankCardNo", title: "付款卡号", width: "160px", visible: false},
            {field: "businessBankName", title: "付款银行", width: "100px", visible: false},
            {field: "businessBankAccountName", title: "付款卡姓名", width: "100px", visible: false},
            {
                field: "businessBank", title: "付款银行卡", width: "160px", formatter: function (index, row) {
                    if (row.businessName == row.orgName) {
                        return ""
                    } else {
                        return row.businessBankAccountName + "</br>" + row.businessBankCardNo + "</br>" + row.businessBankName
                    }
                }
            },
            {field: "noticeMsg", title: "回调返回结果", width: "100px", visible: false},
            {field: "thirdBillId", title: "第三方订单号", width: "100px"},
            {field: "billId", title: "订单号", width: "100px"},
            {field: "merchantId", title: "商户ID", width: "100px", visible: false},
            {field: "ip", title: "派单ip", width: "50px"}

        ]
    })
}

var vm = new Vue({
    el: '#dpLTE',
    data: {
        keyword: null,
        lastOrderId : 0
    },
    methods: {
        load: function () {
            $('#dataGrid').bootstrapTable('refresh');

        },
        save: function () {
            dialogOpen({
                title: '新增订单',
                url: 'modules/billOut/add.html?_' + $.now(),
                width: '800px',
                height: '650px',
                yes: function (iframeId) {
                    top.frames[iframeId].vm.acceptClick();
                    vm.load();
                }
            });
        },
        excel: function () {
            var params ={};
            params.merchantName = $('#merchantName').val();
            params.businessName = $('#businessName').val();
            params.bankAccountName = $('#bankAccountName').val();
            params.thirdBillId = $('#thirdBillId').val();
            params.billId = $('#billId').val();
            params.billStatus = $('#billStatus').val();
            params.notice = $('#notice').val();
            params.billType = $('#billType').val();
            params.createTime = $('#createTime').val();
            params.pageNumber = 1;
            params.sortOrder = "asc";

            var form=$("<form>");
            form.attr("style","display:none");
            form.attr("enctype","application/json");
            form.attr("method","get");
            form.attr("action",'../../apiV1/billOut/csv?_' + $.now());
            form.append($("<input name='merchantName' value='"+params.merchantName+"'/>"));
            form.append($("<input name='businessName' value='"+params.businessName+"'/>"));
            form.append($("<input name='bankAccountName' value='"+params.bankAccountName+"'/>"));
            form.append($("<input name='thirdBillId' value='"+params.thirdBillId+"'/>"));
            form.append($("<input name='billId' value='"+params.billId+"'/>"));
            form.append($("<input name='billStatus' value='"+params.billStatus+"'/>"));
            form.append($("<input name='notice' value='"+params.notice+"'/>"));
            form.append($("<input name='billType' value='"+params.billType+"'/>"));
            form.append($("<input name='createTime' value='"+params.createTime+"'/>"));
            form.append($("<input name='pageNumber' value='"+params.pageNumber+"'/>"));
            form.append($("<input name='sortOrder' value='"+params.sortOrder+"'/>"));
            $("body").append(form);
            form.submit();
        },
        billSuccess: function (billId, index) {
            //"确定已经出款？</br>会员名："+bill.bankAccountName+" 金额:"+bill.price,
            $.ConfirmAjax({
                msg: "确定已经出款？",
                url: '../../apiV1/billOut/bill/success?billId=' + billId + '&_' + $.now(),
                success: function (data) {
                    $('#dataGrid').bootstrapTable('updateRow', {index: index, row: data.bill});
                }
            });
        },
        billFailed: function (billId) {
            $.ConfirmAjax({
                msg: "确定作废订单？",
                url: '../../apiV1/billOut/bill/failed?billId=' + billId + '&_' + $.now(),
                success: function (data) {
                    vm.load();
                }
            });
        },
        billGoBackOrg: function (billId) {
            $.ConfirmAjax({
                msg: "回退订单到机构？",
                url: '../../apiV1/billOut/bill/goBackOrg?billId=' + billId + '&_' + $.now(),
                success: function (data) {
                    vm.load();
                }
            });
        },
        appointHuman: function (billId) {
            dialogOpen({
                title: '指定出款员',
                url: 'modules/billOut/appointHuman.html?_' + $.now(),
                width: '800px',
                height: '420px',
                yes: function (iframeId) {
                    top.frames[iframeId].vm.save(billId);
                }
            });
        },
        copyValue: function (val) {
            var oInput = document.createElement('input');
            oInput.value = val;
            document.body.appendChild(oInput);
            oInput.select(); // 选择对象;
            console.log(oInput.value);
            document.execCommand("Copy", false);
            oInput.remove()
        },
        notice: function (billId) {
            $.ConfirmAjax({
                msg: "再次通知？",
                url: '../../apiV1/billOut/bill/notice?billId=' + billId + '&_' + $.now(),
                success: function (data) {
                    vm.load();
                }
            });
        },
        billLock: function (billId,index) {
            $.ConfirmAjax({
                msg: "锁定订单？",
                url: '../../apiV1/billOut/bill/lock?billId=' + billId + '&_' + $.now(),
                success: function (data) {
                    $('#dataGrid').bootstrapTable('updateRow', {index: index, row: data.bill});
                }
            });
        },
        border: function () {
            return {css: {"border-color": "red red red red"}}
        },
        rowStyle:function (row, index) {
            if (row.billStatus == 1) {
                if(row.isLock == 1) {
                    return  {css:{'background-color':'yellow'}};
                }
                return  {css:{'background-color':'white'}};
            }
            if (row.billStatus == 2) {
                return {css:{'background-color':'#e1c4ee'}};
            }
            if (row.billStatus == 3) {
                return {css:{'background-color':'#00C5CD'}};
            }
        }
    },
    lastOrder:function () {
        alert("lastOrder")
    },
    mounted: function () {
        if (localStorage.getItem("userRoleName").indexOf("机构管理员") > -1) {
            $('#dataGrid').css("background-color", "#FAEBD7")
        }
        setInterval( function ()  {
            $.ajax({
                type : "GET",
                url : '../../apiV1/billOut/lastNewOrder?id=' + vm.lastOrderId + '&_' + $.now(),
                success : function(result) {
                    if (result.code == 0) {
                        if (vm.lastOrderId < result.lastId) {
                            document.getElementById("reminder").play();
                            vm.lastOrderId = result.lastId
                        }
                    } else {
                        dialogAlert(result.msg, 'error');
                    }
                }
            });
        }, 2000);
    }
});