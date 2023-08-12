/**
 * Created by nuintun on 2016/6/29.
 */

$(function (){
  var data, actived;
  var list = $('#list');
  var details = $('#details');
  var page = 0;
  var pages = 1;
  var size = 4;
  var iscroll = refresher.init({
    id: 'list',
    content: 'ul',
    pullDownAction: function (){
      load();
    },
    pullUpAction: function (){
      load(true);
    }
  });

  var load = function (next){
    $.ajax({
      url: list.attr('data-url'),
      data: {
        page: next ? (page < pages ? ++page : page) : (page > 1 ? --page : page),
        number: size
      },
      success: function (result){
        if (result.list) {
          data = result.list;

          var _pages = pages;

          pages = Math.max(Math.ceil(result.total / size), 1);

          if (pages !== _pages) {
            if (next) {
              if (page >= _pages && pages > _pages) {
                page++;
              }
            }
          }

          var html = '';

          for (var i in data) {
            if (data.hasOwnProperty(i)) {
              html += '<li><a href="javascript:;" data-refer="' + i
                + '"><img src="' + data[i].ImageUrl + '"></a></li>';
            }
          }

          list
            .find('ul')
            .html(html)
            .find('a')
            .first()
            .trigger('click');
        } else {
          alert('发生错误！');
        }
      },
      complete: function (){
        iscroll.refresh();
      }
    });
  };

  list.on('click', 'ul a', function (e){
    e.preventDefault();

    if (data) {
      var refer = $(this).attr('data-refer');
      var content = data[refer];

      if (content) {
        actived && actived.removeClass('active');

        actived = $(this.parentNode);

        actived.addClass('active');

        var html = '<h2>' + content.Subject + '<span>发布时间：'
          + content.IssueDate + '</span></h2>'
          + '<p>' + content.Body + '</p>'
          + '<div><a><img src="' + content.ImageUrl + '"></a></div>'

        details.html(html);
      }
    }
  });

  load(true);
});
