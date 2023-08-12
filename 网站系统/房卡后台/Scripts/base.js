$(function () {
    var menu = $('#menu');

    $('#clickmenu').click(function (e) {
        e.stopPropagation();

        if (menu.hasClass('fn-hide')) {
            menu.removeClass('fn-hide');
        } else {
            menu.addClass('fn-hide');
        }
    });

    $(document).on('click', function (e) {
        var menuElem = menu[0];
        var target = e.target;

        if (target !== menuElem && !menuElem.contains(target)) {
            menu.addClass('fn-hide');
        }
    });
    $(function (){
      var active = $(".nav .active");
      var list = Array.prototype.slice.call($(".nav").children());
      var index = list.indexOf(active[0]);
      var target = $(".nav .active a span img");
      target.attr('src',"/image/nav_ico/"+(index+1)+"_active.png");
    });
});