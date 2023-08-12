$(function () {
    var reg = /^\d+$/;
    var account = $('#account');
    var num;

    $('#MainContent_txtGameID').on('change', function () {
        num = $(this).val();

        if (reg.test(num)) {
            $.ajax({
                url: '/Handler.ashx?action=getnicknamebygameid',
                type:'POST',
                data: { gameid: $(this).val() },
                success: function (data) {
                    if (data.data.account == '') {
                        account.html("输入的赠送对象不存在");
                    } else {
                        account.html(data.data.account);
                    }
                }
            });
        } else {
            $(this).focus();
            $(this).val('');
        }
    });
})