var orderList = $('#order-list');
var loadMore = $('#load-more');
var page = 1;
var size = 10;

$(function (){
  var load = function (){
    $.ajax({
      url: orderList.attr('data-url'),
      data: {
        page: page,
        pageSize: size
      }
    }).done(function (result){
      if (result.data.valid) {
        var pages = Math.max(Math.ceil(result.data.total / size), 1);

        if (page < pages) {
          page++;
          loadMore.parent().show();
        } else {
          loadMore.parent().hide();
        }
        orderList.append(result.data.html + result.data.html);
      } else {
        //Toast(result.msg, { theme: 'error' });
      }
    })
  };

  load();

  loadMore.on('click', load);
});