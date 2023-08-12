/*
图片创建预览 2013-10-16
*/

var ImagePreview = function(file, img, options) {
	
	this.file = $$(file);//文件对象
	this.img = $$(img);//预览图片对象
	this._preload = null;//预载图片对象
	this._data = "";//图像数据
	this._upload = null;//remote模式使用的上传文件对象
	
	var opt = this._setOptions(options);
	
	this.action = opt.action;
	this.timeout = opt.timeout;
	this.ratio = opt.ratio;
	this.maxWidth = opt.maxWidth;
	this.maxHeight = opt.maxHeight;
	
	this.onCheck = opt.onCheck;
	this.onShow = opt.onShow;
	this.onErr = opt.onErr;
	
	//设置数据获取程序
	this._getData = this._getDataFun(opt.mode);
	//设置预览显示程序
	this._show = opt.mode !== "filter" ? this._simpleShow : this._filterShow;
};
//根据浏览器获取模式
ImagePreview.MODE = $$B.ie7 || $$B.ie8 ? "filter" : $$B.firefox ? "domfile" : $$B.opera || $$B.chrome || $$B.safari ? "remote" : "simple";

//透明图片
ImagePreview.TRANSPARENT = "transparent.jpg";

ImagePreview.prototype = {
    //设置默认属性
    _setOptions: function (options) {
        this.options = {//默认值
            mode: ImagePreview.MODE, //预览模式
            ratio: 0, //自定义比例
            maxWidth: 0, //缩略图宽度
            maxHeight: 0, //缩略图高度
            onCheck: function () { }, //预览检测时执行
            onShow: function () { }, //预览图片时执行
            onErr: function () { }, //预览错误时执行
            //以下在remote模式时有效
            action: undefined, //设置action
            timeout: 0//设置超时(0为不设置)
        };
        return $$.extend(this.options, options || {});
    },
    //开始预览
    preview: function () {
        if (this.file && false !== this.onCheck()) {
            this._preview(this._getData());
        }
    },

    //根据mode返回数据获取程序
    _getDataFun: function (mode) {
        switch (mode) {
            case "filter":
                return this._filterData;
            case "domfile":
                return this._domfileData;
            case "remote":
                return this._remoteData;
            case "simple":
            default:
                return this._simpleData;
        }
    },
    //滤镜数据获取程序
    _filterData: function () {
        this.file.select();
        try {
            return document.selection.createRange().text;
        } finally { document.selection.empty(); }
    },
    //domfile数据获取程序
    _domfileData: function () {
        //return this.file.files[0].getAsDataURL();
        return window.URL.createObjectURL(this.file.files[0]);
    },
    //远程数据获取程序
    _remoteData: function () {
        this._setUpload();
        console.log(this.action);
        console.log(this._upload);
        console.log()
        this._upload && this._upload.upload();
    },
    //一般数据获取程序
    _simpleData: function () {
        return this.file.value;
    },

    //设置remote模式的上传文件对象
    _setUpload: function () {
        if (this.action !== undefined) {
            var oThis = this;
            this._upload = new QuickUpload(this.file, {
                onReady: function () {
                    this.action = oThis.action; this.timeout = oThis.timeout;
                    var parameter = this.parameter;
                    parameter.ratio = oThis.ratio;
                    parameter.width = oThis.maxWidth;
                    parameter.height = oThis.maxHeight;
                },
                onFinish: function (iframe) {
                    try {
                        oThis._preview(iframe.contentWindow.document.body.innerHTML);
                    } catch (e) { oThis._error("remote error"); }
                },
                onTimeout: function () { oThis._error("timeout error"); }
            });
        }
    },

    //预览程序
    _preview: function (data) {
        //空值或相同的值不执行显示
        if (!!data && data !== this._data) {
            this._data = data; this._show();
        }
    },

    //设置一般预载图片对象
    _simplePreload: function () {
        if (!this._preload) {
            var preload = this._preload = new Image(), oThis = this,
			onload = function () { oThis._imgShow(oThis._data, this.width, this.height); };
            this._onload = function () { this.onload = null; onload.call(this); }
            preload.onload = $$B.ie ? this._onload : onload;
            preload.onerror = function () { oThis._error(); };
        } else if ($$B.ie) {
            this._preload.onload = this._onload;
        }
    },
    //一般显示
    _simpleShow: function () {
        this._simplePreload();
        this._preload.src = this._data;
    },

    //设置滤镜预载图片对象
    _filterPreload: function () {
        if (!this._preload) {
            var preload = this._preload = document.createElement("div");
            //隐藏并设置滤镜
            $$D.setStyle(preload, {
                width: "1px", height: "1px",
                visibility: "hidden", position: "absolute", left: "-9999px", top: "-9999px",
                filter: "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='image')"
            });
            //插入body
            var body = document.body; body.insertBefore(preload, body.childNodes[0]);
        }
    },
    //滤镜显示
    _filterShow: function () {
        this._filterPreload();
        var preload = this._preload,
		data = this._data.replace(/[)'"%]/g, function (s) { return escape(escape(s)); });
        try {
            preload.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = data;
        } catch (e) { this._error("filter error"); return; }
        //设置滤镜并显示
        this.img.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src=\"" + data + "\")";
        //this._imgShow( ImagePreview.TRANSPARENT, preload.offsetWidth, preload.offsetHeight );
        if ($$B.ie) {
            if ($$B.ie8) {
                this._imgShow(ImagePreview.TRANSPARENT, preload.offsetWidth, preload.offsetHeight);
            } else {
                this._imgShow(data, preload.offsetWidth, preload.offsetHeight);
            }
        } else {
            this._imgShow(ImagePreview.TRANSPARENT, preload.offsetWidth, preload.offsetHeight);
        }

    },

    //显示预览
    _imgShow: function (src, width, height) {
        var img = this.img, style = img.style,
		ratio = Math.max(0, this.ratio) || Math.min(1,
				Math.max(0, this.maxWidth) / width || 1,
				Math.max(0, this.maxHeight) / height || 1
			);
        //设置预览尺寸
        style.width = Math.round(width * ratio) + "px";
        style.height = Math.round(height * ratio) + "px";
        //设置src
        img.src = src;
        this.onShow();
    },

    //销毁程序
    dispose: function () {
        //销毁上传文件对象
        if (this._upload) {
            this._upload.dispose(); this._upload = null;
        }
        //销毁预载图片对象
        if (this._preload) {
            var preload = this._preload, parent = preload.parentNode;
            this._preload = preload.onload = preload.onerror = null;
            parent && parent.removeChild(preload);
        }
        //销毁相关对象
        this.file = this.img = null;
    },
    //出错
    _error: function (err) {
        this.onErr(err);
    }
}