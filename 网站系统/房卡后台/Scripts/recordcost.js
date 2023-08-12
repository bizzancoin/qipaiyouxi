function lookscore(roomid) {
    $.ajax({
        url: '/Handler.ashx?action=getroomcardbalance',
        type: 'POST',
        data: { roomid: roomid },
        success: function (data) {
            layer.open({
                content: data.data.html,
                btn: '我知道了',
                shadeClose: false
            });
        }
    });
}
