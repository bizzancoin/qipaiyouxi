/**
 * Created by Newton on 2014/6/17.
 */
$(function (){
    $.formValidator.initConfig({
        theme: 'default',
        formID: 'form',
        ajaxForm: {
            beforeSend: function(){
                $('#result-info').html('');
            },
            success: function (result){
                try {
                    result = $.parseJSON(result);
                } catch (e) {
                    alert('服务器错误，请刷新重试');
                    return false;
                }

                if (result.code === 0 && result.data.valid) {
                    var html = '<td>' + result.data.acount + '</td>'
                        + '<td>' + result.data.reportNo + '</td>'
                        + '<td>' + result.data.state + '</td>';

                    $('#result-info').html(html);
                } else {
                    alert(result.msg);
                }
            }
        }
    });

    $('#txtUser').formValidator({
        required: true,
        onFocus: "请输入申诉帐号"
    });

    $('#reportNo').formValidator({
        required: true,
        onFocus: "请输入申诉号"
    });

    $('#captcha').formValidator({
        tipCss: { left: 205 },
        required: true,
        onFocus: "请输入验证码"
    });
});