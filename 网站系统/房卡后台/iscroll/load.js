/**
 * Created by Administrator on 2016/12/27.
 */
'use strict';

$(function (){
  var orderList = $('#list');
  var page = 0;
  var pages = 1;
  var size = 10;
  var parameter = {
    id: 'wrapper',
    content: 'table',
    pullUpAction: function (){
      load();
    }
  };
  var iscroll = refresher.init(parameter);
  iscroll.on('scrollStart', function () {
    var that = this;
    var pullUp = that.scroller.querySelector('.pullUp');

    var nowPos = iscroll.y;
    var clientH = that.wrapper.clientHeight;
    var scrollH = that.scroller.offsetHeight;

    if (clientH - nowPos >= scrollH) {
      if (this.distY < 0) {
        pullUp.style.display = 'block';
        pullUp.style.fontSize = '12px';
        pullUp.style.lineHeight = '20px';
        pullUp.querySelector('.pullUpLabel').innerText = refresher.info.pullingUpLable;
        pullUp.classList.add('flip');
      }
    }
  });
  iscroll.on('scrollEnd', function (){
    var that = this;
    var pullUp = that.scroller.querySelector('.pullUp');

    var nowPos = iscroll.y;
    var pullOffset = pullUp.offsetHeight;
    var clientH = that.wrapper.clientHeight;
    var scrollH = that.scroller.offsetHeight;
    if (clientH - nowPos >= scrollH || clientH - nowPos >= scrollH - pullOffset) {

      if (pullUp.className.match('flip')) {
        pullUp.classList.add('loading');
        pullUp.classList.remove('flip');
        pullUp.querySelector('.pullUpLabel').innerHTML = refresher.info.loadingLable;
        pullUp.querySelector('.loader').style.display = 'block';
        pullUp.style.lineHeight = '20px';
        pullUp.style.display = 'none';

        if (parameter.pullUpAction) parameter.pullUpAction();

      }
    }
  });


  var load = function () {

    $.ajax({
      url: orderList.attr('data-url'),
      data: {
        page: page <= pages ? ++page : page,

        pageSize: size
      },
      success: function (result) {

        if (result.data.valid) {
          var _pages = pages;

          pages = Math.max(Math.ceil(result.data.total / size), 1);

          if (pages !== _pages) {
            if (page >= _pages && pages > _pages) {
              orderList.append(result.data.html);
            }
          } else {
            if (page <= pages) {
              orderList.append(result.data.html);
            }
          }
          refresher.load_end();
        } else {
          alert(result.msg);
        }
      },
      complete: function (){
        iscroll.refresh();
      }
    });
  };

  load();

});
