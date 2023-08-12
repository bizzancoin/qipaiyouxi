/**
 * Created by Newton on 13-11-27.
 */
$(function (){
  var nav = '';
  var screenshot = $('#screenshot');
  var swipe = new Swipe(screenshot[0], {
    startSlide: 0,
    speed: 400,
    auto: 3000,
    continuous: true,
    disableScroll: false,
    stopPropagation: false,
    callback: function (index){
      screenshot.find('.ui-screenshot-nav li')
        .removeClass('active')
        .eq(index)
        .addClass('active');
    }
  });

  screenshot.find('.ui-screenshot-wrap').children().each(function (i){
    nav += '<li' + (swipe.getPos() === i ? ' class="active"' : '') + '></li>';
  });

  screenshot.find('.ui-screenshot-nav').html(nav);

  var ua = navigator.userAgent.toLowerCase();
  var isWeixin = /MicroMessenger/i.test(ua);

  if (isWeixin) {
    var weixinPopup = $('#weixin-tip');

    // 关闭弹出
    weixinPopup.on('click', '.close', function (e){
      e.preventDefault();

      weixinPopup.addClass('fn-hide');
    });

    weixinPopup.removeClass('fn-hide');
  }
});