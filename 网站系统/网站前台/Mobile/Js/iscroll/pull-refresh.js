/*!
 * pull to refresh v2.0
 *author:wallace
 *2015-7-22
 */
var refresher = {
  info: {
    'pullDownLable': '下拉翻页...',
    'pullingDownLable': '松开加载上一页...',
    'pullUpLable': '上拉翻页...',
    'pullingUpLable': '松开加载下一页...',
    'loadingLable': '加载中...'
  },
  init: function (parameter){
    var wrapper = document.getElementById(parameter.id);
    var div = document.createElement('div');

    div.className = 'scroller';

    wrapper.appendChild(div);

    var scroller = wrapper.querySelector('.scroller');
    var list = wrapper.querySelector('#' + parameter.id + ' ' + parameter.content);

    scroller.insertBefore(list, scroller.childNodes[0]);

    var pullDown = document.createElement('div');

    pullDown.className = 'pullDown';

    var loader = document.createElement('div');

    loader.className = 'loader';

    for (var i = 0; i < 4; i++) {
      var span = document.createElement('span');

      loader.appendChild(span);
    }

    pullDown.appendChild(loader);

    var pullDownLabel = document.createElement('div');

    pullDownLabel.className = 'pullDownLabel';
    pullDown.appendChild(pullDownLabel);
    scroller.insertBefore(pullDown, scroller.childNodes[0]);

    var pullUp = document.createElement('div');

    pullUp.className = 'pullUp';
    loader = document.createElement('div');
    loader.className = 'loader';

    for (i = 0; i < 4; i++) {
      span = document.createElement('span');

      loader.appendChild(span);
    }

    pullUp.appendChild(loader);

    var pullUpLabel = document.createElement('div');

    pullUpLabel.className = 'pullUpLabel';

    var content = document.createTextNode(refresher.info.pullUpLable);

    pullUpLabel.appendChild(content);
    pullUp.appendChild(pullUpLabel);
    scroller.appendChild(pullUp);

    var pullDownEl = wrapper.querySelector('.pullDown');
    var pullDownOffset = pullDownEl.offsetHeight;
    var pullUpEl = wrapper.querySelector('.pullUp');
    var pullUpOffset = pullUpEl.offsetHeight;

    return this.scrollIt(parameter, pullDownEl, pullDownOffset, pullUpEl, pullUpOffset);
  },
  scrollIt: function (parameter, pullDownEl, pullDownOffset, pullUpEl, pullUpOffset){
    var iscroll = new iScroll(document.getElementById(parameter.id), {
      useTransition: true,
      vScrollbar: false,
      probeType: 1,
      onRefresh: function (){
        refresher.onRelease(this, pullDownEl, pullUpEl);
      },
      onScrollMove: function (){
        refresher.onScrolling(this, pullDownEl, pullUpEl, pullUpOffset);
      },
      onScrollEnd: function (){
        refresher.onPulling(this, pullDownEl, parameter.pullDownAction, pullUpEl, parameter.pullUpAction);
      }
    });

    pullDownEl.querySelector('.pullDownLabel').innerHTML = refresher.info.pullDownLable;

    document.addEventListener('touchmove', function (e){
      e.preventDefault();
    }, false);

    return iscroll;
  },
  onScrolling: function (e, pullDownEl, pullUpEl, pullUpOffset){
    if (e.y > 0) {
      if (e.y >= pullUpOffset) {
        pullDownEl.querySelector('.pullDownLabel').innerHTML = refresher.info.pullingDownLable;
        pullDownEl.classList.add('flip');
        e.minScrollY = pullUpOffset;
        e.maxScrollY = pullUpOffset;
      }
    } else if (e.y < 0) {
      if (e.y <= -pullUpOffset) {
        pullUpEl.querySelector('.pullUpLabel').innerHTML = refresher.info.pullingUpLable;
        pullUpEl.classList.add('flip');
        e.minScrollY = -pullUpOffset;
        e.maxScrollY = -pullUpOffset;
      }
    }
  },
  onRelease: function (e, pullDownEl, pullUpEl){
    e.minScrollY = 0;
    e.maxScrollY = 0;

    if (pullDownEl.className.match('loading')) {
      pullDownEl.classList.toggle('loading');
      pullDownEl.querySelector('.pullDownLabel').innerHTML = refresher.info.pullDownLable;
      pullDownEl.querySelector('.loader').style.display = 'none';
      pullDownEl.style.lineHeight = pullDownEl.offsetHeight + 'px';
    }

    if (pullUpEl.className.match('loading')) {
      pullUpEl.classList.toggle('loading');
      pullUpEl.querySelector('.pullUpLabel').innerHTML = refresher.info.pullUpLable;
      pullUpEl.querySelector('.loader').style.display = 'none';
      pullUpEl.style.lineHeight = pullUpEl.offsetHeight + 'px';
    }
  },
  onPulling: function (e, pullDownEl, pullDownAction, pullUpEl, pullUpAction){
    if (pullDownEl.className.match('flip')) {
      pullDownEl.classList.add('loading');
      pullDownEl.classList.remove('flip');
      pullDownEl.querySelector('.pullDownLabel').innerHTML = refresher.info.loadingLable;
      pullDownEl.querySelector('.loader').style.display = 'block';
      pullDownEl.style.lineHeight = '20px';

      if (pullDownAction) pullDownAction();
    }

    if (pullUpEl.className.match('flip')) {
      pullUpEl.classList.add('loading');
      pullUpEl.classList.remove('flip');
      pullUpEl.querySelector('.pullUpLabel').innerHTML = refresher.info.loadingLable;
      pullUpEl.querySelector('.loader').style.display = 'block';
      pullUpEl.style.lineHeight = '20px';

      if (pullUpAction) pullUpAction();
    }
  }
};
