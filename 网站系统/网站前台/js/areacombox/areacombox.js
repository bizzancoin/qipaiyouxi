/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 13-6-4
 * Time: 下午4:47
 * To change this template use File | Settings | File Templates.
 */
(function ($){
  var defaults = {
      province: '#province',
      city: '#city',
      area: '#area',
      initAttr: 'data-selected',
      unselected: '请选择'
    },
    AreaCombox = function (options){
      if (!(this instanceof AreaCombox)) return new AreaCombox(options);
      options = $.extend({}, defaults, options);
      this.province = $(options.province);
      this.city = $(options.city);
      this.area = $(options.area);
      this.initAttr = options.initAttr;
      this.unselected = options.unselected;
      this.initialize();
    };

  AreaCombox.prototype = {
    initialize: function (){
      this.initProvince(this.getProvince());
      this.initCity(this.getCity());
      this.initArea(this.getArea());
    },
    getProvince: function (){
      return AREADATA['0'];
    },
    getCity: function (){
      return AREADATA['0-' + this.province.val()];
    },
    getArea: function (){
      return AREADATA['0-' + this.province.val() + '-' + this.city.val()];
    },
    initProvince: function (data){
      var that = this;
      this.update(this.province, data, +this.province.attr(this.initAttr));
      this.province.on('change', function (){
        that.update(that.city, that.getCity());
      });
    },
    initCity: function (data){
      var that = this;
      this.update(this.city, data, +this.city.attr(this.initAttr));
      this.city.on('change', function (){
        that.update(that.area, that.getArea());
      });
    },
    initArea: function (data){
      this.update(this.area, data, +this.area.attr(this.initAttr));
    },
    update: function (select, data, selected){
      selected = parseInt(selected, 10);
      selected = selected || selected === 0 ? selected : -1;
      select.html(createOptions(data, selected, this.unselected));
      select.change();
    },
    getAreas: function (province, city, area){
      var areas = [];
      areas.push(AREADATA[0][province] || '');
      areas.push(areas[0] ? AREADATA[0 + '-' + province][city] : '');
      areas.push(areas[1] ? AREADATA[0 + '-' + province + '-' + city][area] : '');
      return areas;
    }
  };

  /**
   * 创建options
   * @param data
   * @param selected
   * @param unselect
   * @returns {string}
   */
  function createOptions(data, selected, unselect){
    var options = '<option title="' + unselect + '" value="-1"' +
      (selected === -1 ? ' selected' : '') + '>' + unselect + '</option>';
    if (Array.isArray(data)) {
      data.forEach(function (item, i){
        options += '<option title="' + item + '" value="' + i + '"' +
          (i === selected ? ' selected' : '') + '>' + item + '</option>'
      });
    }
    return options;
  }

  window.AreaCombox = AreaCombox;
})(jQuery);