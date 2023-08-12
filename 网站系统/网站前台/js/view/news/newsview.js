/**
 * Created by nuintun on 2015/12/31.
 */

var switchFont = $('#switch-font');
var newsContent = $('#news-content');

switchFont.on('click', 'a', function (){
  var self = $(this);
  var size = self.attr('data-size');

  switchFont.find('a.ui-fontsize-active').removeClass('ui-fontsize-active');
  self.addClass('ui-fontsize-active');

  newsContent.css('font-size', +size);
});
