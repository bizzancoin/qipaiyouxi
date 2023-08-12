
/* 全局调试开关 0 关 1 开  */
var GLOBALS_DEBUG=1;

var $regexs = {
	
		require : /.+/,
		email : /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/,
		phone : /^((\(\d{2,3}\))|(\d{3}\-))?(\(0\d{2,3}\)|0\d{2,3}-)?[1-9]\d{6,7}(\-\d{1,4})?$/,
		mobile : /^((\(\d{2,3}\))|(\d{3}\-))?((13\d{9})|(15[389]\d{8}))$/,
		url : /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"])*$/,
		ip : /^(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5]).(0|[1-9]\d?|[0-1]\d{2}|2[0-4]\d|25[0-5])$/,
		currency : /^\d+(\.\d+)?$/,
		number : /^\d+$/,
		zip : /^[1-9]\d{5}$/,
		qq : /^[1-9]\d{4,8}$/,
		english : /^[A-Za-z]+$/,
		chinese :  /^[\u0391-\uFFE5]+$/,
		username : /^[a-z]\w{2,32}$/i,
		integer : /^[-\+]?\d+$/,
		'double' : /^[-\+]?\d+(\.\d+)?$/		
	};
	
function showLayer(layerID) {
    $(layerID).setStyle("display","block");
};

function hideLayer(layerID) {
    $(layerID).setStyle("display","none");
};

function showInfoInLayer(layerObj,content) {
    $(layerObj).set("html",content);
    if(content!="") {
        showLayer(layerObj);
        $(layerObj).addClass("errorMessage");
    }
    else {
        hideLayer(layerObj);
        $(layerObj).removeClass("errorMessage");
    }
};

function showLayerObj(layer){
	$("#"+layer+"").show();
};

function hideLayerObj(layer){
	$("#"+layer+"").hide();
};


///*
// * 提示状态
// */
//var Tips = { error: "error", tip: "tip", right: "right", ajax: "ajax" };
//var TipsStyle=new Array("tips_normal","rightTips","wrongTips","tips_notes","tips_loading");

///*
// * 全局提示信息
// */
//function hintMessage(hintObj,error,message){
//    var cssClass="tips_notes";
//	switch(error) {
//	case Tips.right:
//	    cssClass="rightTips";
//		break;
//	
//	case Tips.tip:
//		cssClass="tips_notes";
//		break;
//		
//	case Tips.ajax:
//		cssClass="tips_loading";
//		break;
//		
//	case Tips.error:		
//	default: 
//		cssClass="wrongTips";
//	}
//	
//	//删除样式
//	$("#"+hintObj+"").removeClass("tips_notes");
//	$("#"+hintObj+"").removeClass("rightTips");
//	$("#"+hintObj+"").removeClass("wrongTips");
//	$("#"+hintObj+"").removeClass("tips_loading");
//	$("#"+hintObj+"").removeClass("tips_normal");
//	
//	$("#"+hintObj+"").html(message);
//	$("#"+hintObj+"").addClass(cssClass);
//	showLayerObj(hintObj);
//}


/*
 * 清理样式类
 */
function cleanTipsStyle(tipLayout){
	for (var i = TipsStyle.length - 1; i >= 0; i--){
		tipLayout.removeClass(TipsStyle[i]);		
	}
	tipLayout.addClass(TipsStyle[0]);
}

/* 调试日志 */
var G_Log_Content="";
function log(a) {
    if(GLOBALS_DEBUG==0)
        return true;
    if(navigator.userAgent.indexOf("Firefox")>-1) {
        console.log(a);
    }
    else {
        if(G_Log_Content=="") {
            document.ondblclick=function(){ if(!confirm(G_Log_Content + "---\nkeep it?")) G_Log_Content="\n"; };
        }
    }
    if(a=="-")
        G_Log_Content="\n";
    else
        G_Log_Content+=a+"\n";
};

/*
 * 构造 StringBuilder 对象 begin
 */
var stringBuilder = function(str) { this.arr = new Array(); if (str) this.arr.push(str); if (!stringBuilder.created) { stringBuilder.prototype.append = function(str) { this.arr.push(str); }; stringBuilder.prototype.clear = function() { this.arr.splice(0, this.arr.length); }; stringBuilder.prototype.toString = function() { return this.arr.join(''); }; stringBuilder.created = true; } }

/*
 * 构造 StringBuilder 对象 end
 */


function goURL(url) {
    document.location.href = url;
}

/*
 * 粘贴事件
 */
function escPasteEvent(textbox) {
	textbox.onpaste=function(e){return false;};
}

/*
 * 焦点事件
 */
function escFocusEvent(textbox){
	textbox.onfocus=function(e){this.select();}
}

/*
 * 禁止粘贴和焦点选中
 */
function escPasteFocusSelect(textbox){
	escPasteEvent(textbox);
	escFocusEvent(textbox);
}

/*
 * 光标离开绑定
 * @fnname 函数地址
 */
function bindBlurEvent(textbox,fnname) {
	textbox.onblur=function(e){fnname};
}

/*
 * 提交暂停点击
 */
function disable(obj) {
    setTimeout(function() { obj.disabled = true; }, 30);	
}
function enable(obj) {
	obj.disabled=false;
}

//格式化数字
function formatnumber(fnumber, fdivide, fpoint, fround) {
    var fnum = fnumber + '';
    var revalue = "";

    if (fnum == null) {
        for (var i = 0; i < fpoint; i++) revalue += "0";
        return "0." + revalue;
    }
    fnum = fnum.replace(/^\s*|\s*$/g, '');
    if (fnum == "") {
        for (var i = 0; i < fpoint; i++) revalue += "0";
        return "0." + revalue;
    }

    fnum = fnum.replace(/,/g, "");

    if (fround) {
        var temp = "0.";
        for (var i = 0; i < fpoint; i++) temp += "0";
        temp += "5";

        fnum = Number(fnum) + Number(temp);
        fnum += '';
    }

    var arrayf = fnum.split(".");

    if (fdivide) {
        if (arrayf[0].length > 3) {
            while (arrayf[0].length > 3) {
                revalue = "," + arrayf[0].substring(arrayf[0].length - 3, arrayf[0].length) + revalue;
                arrayf[0] = arrayf[0].substring(0, arrayf[0].length - 3);
            }
        }
    }
    revalue = arrayf[0] + revalue;

    if (arrayf.length == 2 && fpoint != 0) {
        arrayf[1] = arrayf[1].substring(0, (arrayf[1].length <= fpoint) ? arrayf[1].length : fpoint);

        if (arrayf[1].length < fpoint)
            for (var i = 0; i < fpoint - arrayf[1].length; i++) arrayf[1] += "0";
        revalue += "." + arrayf[1];
    } else if (arrayf.length == 1 && fpoint != 0) {
        revalue += ".";
        for (var i = 0; i < fpoint; i++) revalue += "0";
    }

    return revalue;
}

