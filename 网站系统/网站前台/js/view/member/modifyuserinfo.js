/**
 * Created by Administrator on 2014/7/9.
 */
$(function (){
    $.formValidator.initConfig({
        formID: 'form1'
    });

    $('#txtQQ').formValidator({
        onFocus: "请输入QQ"
    }).regexValidator({
        regExp: 'qq',
        dataType: 'enum',
        onError: 'QQ格式错误'
    });

    $('#txtMobilePhone').formValidator({
        onFocus: "请输入移动电话"
    }).regexValidator({
        regExp: 'mobile',
        dataType: 'enum',
        onError: '移动电话格式错误'
    });

    $('#txtEmail').formValidator({
        onFocus: "请输入邮箱"
    }).regexValidator({
        regExp: 'email',
        dataType: 'enum',
        onError: '邮箱格式错误'
    });
});