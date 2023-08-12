/**
 * Created by Administrator on 2014/7/3.
 */
$(function (){
    var oCounts = $('#quantity'),
        oTotal = $('#total-price'),
        price = oTotal.attr('data-price');

    AreaCombox();

    $('#minus').click(function (){

        if (oCounts.val().trim() == '1') return;
        oCounts.val(oCounts.val() - 1);
        oTotal.text(oCounts.val() * price);
    });

    $('#plus').click(function (){
        if (oCounts.val().trim() == '999') return;
        oCounts.val(parseInt(oCounts.val()) + 1);
        oTotal.text(oCounts.val() * price);
    });

    oCounts.keyup(function (){
        var val = $.trim(this.value);
        if (isNaN(val) || val === '0') {
            this.value = '1';
        }
        oTotal.text(this.value * price);
    });

    $.formValidator.initConfig({
        theme: 'default',
        formID: 'form',
        ajaxForm: {
            success: function (result){
                try {
                    result = $.parseJSON(result);
                } catch (e) {
                    alert('服务器错误，请刷新重试');
                    return false;
                }

                if (result.code === 0 && result.data.valid) {
                    window.location.href = result.data.uri;
                } else {
                    alert(result.msg);
                }
            }
        }
    });

    $('#consignee').formValidator({
        required: true,
        onEmpty: '收货人姓名不能为空',
        onFocus: '请输入收货人姓名'
    });

    $('#mobile').formValidator({
        required: true,
        onEmpty: '手机号不能为空',
        onFocus: '请输入手机号码'
    }).regexValidator({
        regExp: 'mobile',
        dataType: 'enum',
        onError: '手机号格式不正确'
    });

    $('#qq').formValidator({
        required: true,
        onEmpty: 'QQ/微信不能为空',
        onFocus: '请输入QQ/微信号码'
    });

    $('#address').formValidator({
        required: true,
        onEmpty: '详细地址不能为空',
        onFocus: '请输入详细地址'
    });
});