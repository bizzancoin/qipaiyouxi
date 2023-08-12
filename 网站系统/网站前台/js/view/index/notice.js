/**
 * Created by nuintun on 2015/12/24.
 */

'use strict';

(function (){
  var vendors = ['webkit', 'moz'];

  for (var i = 0; i < vendors.length && !window.requestAnimationFrame; ++i) {
    var vp = vendors[i];

    window.requestAnimationFrame = window[vp + 'RequestAnimationFrame'];
    window.cancelAnimationFrame = (window[vp + 'CancelAnimationFrame']
    || window[vp + 'CancelRequestAnimationFrame']);
  }

  if (/iP(ad|hone|od).*OS 6/.test(window.navigator.userAgent) // iOS6 is buggy
    || !window.requestAnimationFrame || !window.cancelAnimationFrame) {
    var lastTime = 0;

    window.requestAnimationFrame = function (callback){
      var now = Date.now();
      var nextTime = Math.max(lastTime + 16, now);

      return setTimeout(function (){ callback(lastTime = nextTime); }, nextTime - now);
    };

    window.cancelAnimationFrame = clearTimeout;
  }
}());

$(function (){
  var marquee = $('#marquee');
  var view = marquee.parent();
  var clone = marquee.clone();
  var height = view.height();

  clone.removeAttr('id');
  clone.find('thead').remove();
  view.append(clone);

  function infiniteMarquee(){
    var marginTop = parseInt(marquee.css('margin-top'));

    if (Math.abs(marginTop) >= height) {
      marginTop = 0;
      marquee.css('margin-top', marginTop);
    } else {
      marquee.css('margin-top', marginTop - 1);
    }

    requestAnimationFrame(infiniteMarquee);
  }

  infiniteMarquee();
});
