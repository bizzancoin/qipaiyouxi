$(function () {
    $('#look-total').on('click', function () {
        $.ajax({
            url: '/Handler.ashx?action=gettotalroomcardrebate',
            type: 'POST',
            data: { userid: $(this).attr('data-id') },
            success: function (data) {
                layer.open({
                    content: '您的总返利统计：' + data.data.rebate + "游戏币",
                    btn: '我知道了'
                });
            }
        });
    });

    $('#look-today').on('click', function () {
        $.ajax({
            url: '/Handler.ashx?action=gettodayroomcardrebate',
            type: 'POST',
            data: { userid: $(this).attr('data-id') },
            success: function (data) {
                layer.open({
                    content: '您的今日返利统计：' + data.data.rebate + "游戏币",
                    btn: '我知道了'
                });
            }
        });
    });
})