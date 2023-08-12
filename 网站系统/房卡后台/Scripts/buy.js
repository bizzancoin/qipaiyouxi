$(function () {
    var id,card;
    $('#list').on('click', 'a', function () {
        id = $(this).attr('data-id');
        card = $(this).attr('data-card');
        layer.open({
            content: '您选择购买 ' + card + '张房卡，请选择下面适合您的购买方式'
              , btn: ['游戏豆购买', '人民币充值']
              , yes: function (index) {
                  layer.close(index);
                  location.href = '/Menu/BuyInfo.aspx?id=' + id;
              }, no: function (index) {
                  layer.close(index);
                  location.href = '/Pay/Index.aspx?id=' + id;
              }
        });

    });
})