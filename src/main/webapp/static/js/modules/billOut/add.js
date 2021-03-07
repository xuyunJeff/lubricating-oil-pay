/**
 * 新增-js
 */
var vm = new Vue({
    el: '#dpLTE',
    data: {
        billOut: {
            googleCode: "",
            billOutViewPersonList: [{
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }, {
                orderNo: ""
            }]
        }
    },
    methods: {
        acceptClick: function () {
            if (!$('#form').Validform()) {
                return false;
            }
            var billOutBatchVo = {
                googleCode: vm.billOut.googleCode,
                billOutViewPersonList: []
            };

            for (i = 0; i < vm.billOut.billOutViewPersonList.length; i++) {
                if (vm.billOut.billOutViewPersonList[i]) {
                    if (!vm.billOut.billOutViewPersonList[i].price || vm.billOut.billOutViewPersonList[i].price.length == 0) continue;
                    if (!vm.billOut.billOutViewPersonList[i].bankCardNo || vm.billOut.billOutViewPersonList[i].bankCardNo.length == 0) continue;
                    if (!vm.billOut.billOutViewPersonList[i].bankName || vm.billOut.billOutViewPersonList[i].bankName.length == 0) continue;
                    if (!vm.billOut.billOutViewPersonList[i].bankAccountName || vm.billOut.billOutViewPersonList[i].bankAccountName.length == 0) continue;
                    if (typeof Number(vm.billOut.billOutViewPersonList[i].price) === "number"
                        && typeof Number(vm.billOut.billOutViewPersonList[i].bankCardNo) === "number"
                        && typeof vm.billOut.billOutViewPersonList[i].bankName === "string"
                        && typeof vm.billOut.billOutViewPersonList[i].bankAccountName === "string") {

                        billOutBatchVo.billOutViewPersonList.push(vm.billOut.billOutViewPersonList[i])
                    }

                }
            }
            if (billOutBatchVo.googleCode.length != 6) {
                dialogAlert("谷歌验证码是6位数", 'error');
                return
            }
            if (billOutBatchVo.billOutViewPersonList.length == 0) {
                dialogAlert("订单不正确或未填数据", 'error');
                return
            }

            $.SaveForm({
                url: '../../apiV1/billOut//push/order/batch?_' + $.now(),
                param: billOutBatchVo,
                success: function (data) {
                    $.currentIframe().vm.load();
                }
            });
        }
    }
});
