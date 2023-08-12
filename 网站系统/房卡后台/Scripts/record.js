$(function () {
    var orderList = $('#list');
    var page = 0;
    var pages = 1;
    var size = 4;
    var iscroll = refresher.init({
        id: 'wrapper',
        content: 'table',
        pullDownAction: function () {
            load();
        },
        pullUpAction: function () {
            load(true);
        }
    });

    var load = function (next) {
        $.ajax({
            url: orderList.attr('data-url'),
            data: {
                page: next ? (page < pages ? ++page : page) : (page > 1 ? --page : page),
                pageSize: size
            },
            success: function (result) {
                if (result.data.valid) {
                    var _pages = pages;

                    pages = Math.max(Math.ceil(result.data.total / size), 1);

                    if (pages !== _pages) {
                        if (next) {
                            if (page >= _pages && pages > _pages) {
                                page++;
                            }
                        }
                    }

                    orderList.append(result.data.html);
                } else {
                    alert(result.msg);
                }
            },
            complete: function () {
                iscroll.refresh();
            }
        });
    };

    load(true);
});