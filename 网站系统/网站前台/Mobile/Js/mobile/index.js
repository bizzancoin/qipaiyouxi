/**
 * Created by Newton on 13-11-23.
 */
$(function (){
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