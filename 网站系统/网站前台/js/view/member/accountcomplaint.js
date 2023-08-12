/**
 * Created by Newton on 2014/4/9.
 */
$(function (){
    $.formValidator.initConfig({
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

    $('#email').formValidator({
        required: true,
        onFocus: '请输入邮箱'
    }).regexValidator({
        regExp: 'email',
        dataType: 'enum',
        onError: '邮箱格式错误'
    });

    $('#txtUser').formValidator({
        required: true,
        onFocus: '请输入申诉帐号'
    }).inputValidator({
        min: 6,
        max: 32,
        onError: '帐号长度必须在6-32位之间'
    });

    $('#regDate').formValidator({
        required: true,
        onFocus: '请输入注册时间'
    }).functionValidator({
        fun: isDate,
        onError: '时间格式错误'
    });

    $('#realname').formValidator({
        required: true,
        onFocus: '请输入真实姓名'
    });

    $('#idcard').formValidator({
        required: true,
        onFocus: '请输入身份证信息'
    }).functionValidator({
        fun: isCardID,
        onError: '身份证格式错误'
    });

    $('#mobile').formValidator({
        required: true,
        onFocus: '请输入移动电话'
    }).regexValidator({
        regExp: 'mobile',
        dataType: 'enum',
        onError: '移动电话格式错误'
    });
});