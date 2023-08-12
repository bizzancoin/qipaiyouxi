/**
 * Created by nuintun on 2015/12/24.
 */

'use strict';

$(function (){
  var nav = '';
  var expando = Date.now();
  var bannerNav = $('#banner-nav');
  var bannerBox = $('#banner-box');
  var banner = bannerBox.children();

  banner.each(function (i){
    var id = 'banner_item_' + expando + '_' + i;

    this.id = id;
    nav += '<li' + (i === 0 ? ' class="ui-banner-active"' : '') + ' data-rel="' + id + '"></li>';

    if (i !== 0) {
      $(this).addClass('fn-hide');
    }
  });

  bannerNav.html(nav);

  nav = bannerNav.children();

  var panel = bannerBox.closest('.ui-banner');

  nav.powerSwitch({
    animation: 'translate',
    container: panel.find('.ui-banner-page'),
    classPrev: 'ui-banner-prev',
    classNext: 'ui-banner-next',
    onSwitch: function (){
      nav.removeClass('ui-banner-active');
      $(this).addClass('ui-banner-active');
    }
  });

  panel.on('mouseenter mouseleave', function (e){
    var isShow = e.type === 'mouseenter';

    panel.find('.ui-banner-prev, .ui-banner-next')[isShow ? 'show' : 'hide']();
  });
});
