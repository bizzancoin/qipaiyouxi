/*!
 * pull to refresh v2.0
 *author:wallace
 *2015-7-22
 */
var refresher = {
  info: {
    'pullUpLable': '上拉翻页...',
    'pullingUpLable': '松开加载下一页...',
    'loadingLable': '加载中...'
  },
  init: function (parameter){
    var wrapper = document.getElementById(parameter.id);
    var div = document.createElement('div');
    div.id = 'scroller';

    wrapper.appendChild(div);

    var scroller = wrapper.querySelector('#scroller');
    var list = wrapper.querySelector('#' + parameter.id + ' ' + parameter.content);

    scroller.insertBefore(list, scroller.childNodes[0]);
    var pullUp = document.createElement('div');
    pullUp.className = 'pullUp';
    var pullUpLabel = document.createElement('span');
    pullUpLabel.className = 'pullUpLabel';
    pullUp.appendChild(pullUpLabel);

    var loader = document.createElement('div');
    loader.className = 'loader';

    for (var i = 0; i < 4; i++) {
      var span = document.createElement('span');

      loader.appendChild(span);
    }

    pullUp.appendChild(loader);

    scroller.appendChild(pullUp);

    document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

    return this.iScroll(parameter);
  },

  iScroll: function (parameter){
    var myScroll = new IScroll(document.getElementById(parameter.id), {
      mouseWheel: false,
      useTransition: true,
      scrollbars: false
    });

    return myScroll;

  },

  load_end: function (){
    var pullUp = document.querySelector('.pullUp');
    if (pullUp) {
      if(pullUp.className.match('loading')) {
        pullUp.classList.toggle('loading');
        pullUp.querySelector('.pullUpLabel').innerHTML = '';
        pullUp.querySelector('.loader').style.display = 'none';
        pullUp.style.lineHeight = 0 + 'px';
        pullUp.style.fontSize = 0;
      }
    }
  }
};
