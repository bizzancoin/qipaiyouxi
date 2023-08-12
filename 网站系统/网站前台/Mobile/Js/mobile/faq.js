'use strict';

$(function (){
  var orderList = $('#order-list');
  var page = 0;
  var pages = 1;
  var size = 1;
  var iscroll = refresher.init({
    id: 'wrapper',
    content: '.ui-list',
    pullDownAction: function (){
      load();
    },
    pullUpAction: function (){
      load(true);
    }
  });

  var load = function (next){
    $.ajax({
      url: orderList.attr('data-url'),
      data: {
        page: next ? (page < pages ? ++page : page) : (page > 1 ? --page : page),
        pageSize: size
      },
      success: function (result){
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

          orderList.html(result.data.html);
        } else {
          alert(result.msg);
        }
      },
      complete: function (){
        iscroll.refresh();
      }
    });
  };

  load(true);
});