/****************************************************************/
/* <p>网站公用JavaScript Document</p>						    */
/* 数据持久的一些js方法,主要涉及浏览器,常规函数及字符串操作方面 */
/* @Author:Summer. Guo											*/
/* @Version: Debug												*/
/****************************************************************/

/***************************************************************/
/*				以下是浏览器相关函数区						   */
/***************************************************************/

document.ondragstart = function (){
    return false;
}

var fieldname;
var grandchilds;
var defaultValue;

//多浏览器对象方法
function getObjById(objectId){
    if (document.getElementById && document.getElementById(objectId)) {
        // W3C DOM
        return document.getElementById(objectId);
    } else if (document.all && document.all(objectId)) {
        // MSIE 4 DOM
        return document.all(objectId);
    } else if (document.layers && document.layers[objectId]) {
        // NN 4 DOM.. note: this won't find nested layers
        return document.layers[objectId];
    } else {
        return false;
    }
} // getObjById

/***************************************************************/
/*	以下是打开或新建浏览器窗口函数							   */
/***************************************************************/
function openWindowSelf(url){
    var openthiswin = window.open(url, "_self");
    if (openthiswin != null) openthiswin.focus();
}
function openWindow(url, width, height){
    var left = (window.screen.availWidth - width) / 2;
    var top = (window.screen.availHeight - height) / 2;

    var openthiswin = window.open(url, "welcomes", 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,left=' + left + ',top=' + top + ',width=' + width + ',height=' + height);
    if (openthiswin != null)openthiswin.focus();
}
function openWindowOwn(url, name, width, height){
    var left = (window.screen.availWidth - width) / 2;
    var top = (window.screen.availHeight - height) / 2;
    var openthiswin = window.open(url, name, 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,left=' + left + ',top=' + top + ',width=' + width + ',height=' + height);
    if (openthiswin != null) openthiswin.focus();
}
/** 显示信息提示网页对话框                                        */
function showDialog(url, width, height){
    var top = (window.screen.availHeight - height) / 2;
    var feature = "dialogHeight:" + height + "px;dialogWidth:" + width + "px;dialogTop:" + top + "px; center:yes;scroll:yes;status:no;resizable:no;edge:raised;help:no;unadorned:no";
    var returnValue = window.showModalDialog(url, "游戏家园提醒您", feature);
    if (returnValue == "Success") {
        window.location.href = window.location.href;
    }
}
/**弹出一个不可见窗体(注释语句用来调试用)*/
function openHideWin(sPath){
    window.open(sPath, 'welcome', 'width=10px,height=10px,top=2000px,left=2000px');
    //window.open(sPath,'welcome','width=300px,height=500px,top=20px,left=20px');
}
/**弹出一个窗口*/
function windowOpen(sPath, sWidth, sHeight){
    window.open(sPath, 'welcomes', 'width=' + sWidth + ',height=' + sHeight + ',center=yes');
}
/**弹出一个窗口*/
function newWindow(sPath, sWidth, sHeight){
    window.open(sPath, 'welcomes', 'width=' + sWidth + ',height=' + sHeight +
        ',center=yes,toolbar=yes,menubar=yes,scrollbars=yes, resizable=yes,location=yes,status=yes');
}
/**打开链接地址上的图片*/
function openPic(url){
    window.open(url);
}

function dateValidator(dateString){
    alert(dateString);
}

/***************************************************************/
/*	以上是打开或新建浏览器窗口函数完毕						   */
/***************************************************************/

function isIE(){  //ie?
    /*if (window.navigator.userAgent.indexOf("MSIE")>=1)
     return true;
     else
     return false;*/
    var agent = navigator.userAgent.toLowerCase();
    this.major = parseInt(navigator.appVersion);  //主版本号
    this.minor = parseFloat(navigator.appVersion);//全版本号
    if ((agent.indexOf("mozilla") != -1) || (agent.indexOf("msie") != -1) || (agent.indexOf("opera") != -1) || (agent.indexOf("win") != -1) || (agent.indexOf("mac") != -1)
        || (agent.indexOf("x11") != -1)) {
        return true;
    }
    else {
        return false;
    }
}

if (!isIE()) { //firefox  innerText define ,xurun
    HTMLElement.prototype.__defineGetter__
    (
        "innerText",
        function (){
            var anyString = "";

            var childS = this.childNodes;
            for (var i = 0; i < childS.length; i++) {
                if (childS[i].nodeType == 1)
                    anyString += childS[i].tagName == "BR" ? '\n' : childS[i].innerText;
                else if (childS[i].nodeType == 3)
                    anyString += childS[i].nodeValue;
            }
            return anyString;
        }
    );
}

/***************************************************************/
/* 错误或消息调用函数										   */
/***************************************************************/
function getLetterTipFrame(color, msg){
    var remsg = "";
    if (color == 'blue')
        remsg = "<font color='#00A8FF'>" + msg + "</font>";
    else if (color == 'red')
        remsg = "<font color='#FF6600'>" + msg + "</font>";
    else if (color == 'right')
        remsg = "<font color='#58CB64'>" + msg + "</font>";
    else
        remsg = msg;
    return remsg;
}

function getTipFrame(color, msg){
    var remsg = "";
    if (color == 'blue')
        remsg = "<table width=360 border=0 cellPadding=0  cellSpacing=2 bgcolor='#E2F5FF'  style='BORDER-RIGHT: #00A8FF 1px solid; BORDER-TOP: #00A8FF 1px solid; BORDER-LEFT: #00A8FF 1px solid; BORDER-BOTTOM: #00A8FF 1px solid'><TR><TD width='24' height='20' class=l20><div align='center'><img src='/images/01.gif' width='14' height='14'></div></TD> <TD width='332' class=l20>" + msg + "</TD> </TR> </TABLE>";
    else if (color == 'red')
        remsg = "<table width=360 border=0 cellPadding=0 cellSpacing=2 bgcolor='#FFF2E9' style='BORDER-RIGHT: #FF6600 1px solid; BORDER-TOP: #FF6600 1px solid; BORDER-LEFT: #FF6600 1px solid; BORDER-BOTTOM: #FF6600 1px solid'><TR><TD width='21' height='20' class=l20><div align='center'><img src='/images/02.gif' width='14' height='14'></div></TD><TD width='331' class=style4>" + msg + "</TD></TR> </TABLE></body>";
    else if (color == 'right')
        remsg = "<table width=177 border=0 cellPadding=0 cellSpacing=2 bgcolor='#ffffff' style='BORDER-RIGHT: #F3F3F3 1px solid; BORDER-TOP: #F3F3F3 1px solid; BORDER-LEFT: #F3F3F3 1px solid; BORDER-BOTTOM: #F3F3F3 1px solid'><TR><TD width='22' height='20' class=l20><div align='center'><img src='/images/03.gif' width='14' height='14'></div></TD><TD width='147' class=style5>" + msg + "</TD> </TR> </TABLE>";
    else
        remsg = "<span class='r1_2'>" + msg + "</span>";
    return remsg;
}

function getWidthTipFrame(color, msg, allwidth){
    var remsg = "";
    if (color == 'blue')
        remsg = "<table width=" + allwidth + " border=0 cellpadding=0  cellspacing=2 bgcolor='#e2f5ff'  style='border-right: #00a8ff 1px solid; border-top: #00a8ff 1px solid; border-left: #00a8ff 1px solid; border-bottom: #00a8ff 1px solid'><tr><td width='24' height='20' class=l20><div align='center'><img src='/images/01.gif' width='14' height='14'></div></td> <td  class=l20>" + msg + "</td> </tr> </table>";
    else if (color == 'red')
        remsg = "<table width=" + allwidth + " border=0 cellpadding=0 cellspacing=2 bgcolor='#fff2e9' style='border-right: #ff6600 1px solid; border-top: #ff6600 1px solid; border-left: #ff6600 1px solid; border-bottom: #ff6600 1px solid'><tr><td width='21' height='20' class=l20><div align='center'><img src='/images/02.gif' width='14' height='14'></div></td><td  class=style4>" + msg + "</td></tr> </table>";
    else if (color == 'right')
        remsg = "<table width=" + allwidth + " border=0 cellpadding=0 cellspacing=2 bgcolor='#ffffff' style='border-right: #f3f3f3 1px solid; border-top: #f3f3f3 1px solid; border-left: #f3f3f3 1px solid; border-bottom: #f3f3f3 1px solid'><tr><td width='22' height='20' class=l20><div align='center'><img src='/images/03.gif' width='14' height='14'></div></td><td  class=style5>" + msg + "</td> </tr> </table>";
    else if (color == 'green')
        remsg = "<table width=" + allwidth + " border=0 cellpadding=0 cellspacing=2 bgcolor='#ddf1d8' style='border-right: #58cb64 1px solid; border-top: #58cb64 1px solid; border-left: #58cb64 1px solid; border-bottom: #58cb64 1px solid'><tr><td width='22' height='20' class=l20><div align='center'><img src='/images/03.gif' width='14' height='14'></div></td><td  class=style5>" + msg + "</td> </tr> </table>";
    else if (color == 'loading')
        remsg = "<table width=" + allwidth + " border=0 cellpadding=0 cellspacing=2 bgcolor='#ddf1d8' style='border-right: #58cb64 1px solid; border-top: #58cb64 1px solid; border-left: #58cb64 1px solid; border-bottom: #58cb64 1px solid'><tr><td width='22' height='20' class=l20><div align='center'><img src='/images/loading.gif' width='16' height='16'></div></td><td  class=style5>" + msg + "</td> </tr> </table>";
    else
        remsg = "<span class='r1_2'>" + msg + "</span>";
    return remsg;
}
function focusdis(ti, msg){
    var ti = eval(ti);
    ti.innerHTML = getTipFrame("blue", msg);
}
function dis(ti, color, msg){
    var ti = eval(ti);
    if (ti.innerHTML == "")
        ti.innerHTML = getWidthTipFrame("blue", msg + "&nbsp;");
    else if (color.indexOf("blue") == 0)
        ti.innerHTML = getWidthTipFrame("blue", msg + "&nbsp;");
    else if (color.indexOf("red") == 0)
        ti.innerHTML = getWidthTipFrame("red", msg + "&nbsp;");
    else if (color.indexOf("right") == 0)
        ti.innerHTML = getWidthTipFrame("right", msg + "&nbsp;");
}
function wdis(ti, color, msg, allwidth){
    var ti = eval(ti);
    if (ti.innerHTML == "")
        ti.innerHTML = getWidthTipFrame("blue", msg, allwidth);
    else if (color.indexOf("blue") == 0)
        ti.innerHTML = getWidthTipFrame("blue", msg, allwidth);
    else if (color.indexOf("red") == 0)
        ti.innerHTML = getWidthTipFrame("red", msg, allwidth);
    else if (color.indexOf("right") == 0)
        ti.innerHTML = getWidthTipFrame("right", msg, allwidth);
}
/**********************************
 ** 只显示文字信息
 **
 ***********************************/
function letterdis(ti, color, msg){
    var ti = eval(ti);
    if (ti.innerHTML == "")
        ti.innerHTML = getLetterTipFrame("red", msg + "&nbsp;");
    else if (color.indexOf("blue") == 0)
        ti.innerHTML = getLetterTipFrame("blue", msg + "&nbsp;");
    else if (color.indexOf("red") == 0)
        ti.innerHTML = getLetterTipFrame("red", msg + "&nbsp;");
    else if (color.indexOf("right") == 0)
        ti.innerHTML = getLetterTipFrame("right", msg + "&nbsp;");
    else
        ti.innerHTML = getLetterTipFrame("", msg + "&nbsp;");
}

/***********************************
 ** 只显示图片信息的对与错标识。
 **
 ***********************************/
function getImgTipFrame(color){
    var remsg = "";
    if (color == 'blue')
        remsg = "<div align='left'><img src='/images/01.gif' width='14' height='14'></div>";
    else if (color == 'red')
        remsg = "<div align='left'><img src='/images/02.gif' width='14' height='14'></div></TD><TD  class=style4>";
    else if (color == 'right')
        remsg = "<div align='left'><img src='/images/03.gif' width='14' height='14'></div>";
    else if (color == 'loading')
        remsg = "<div align='left'><img src='/images/loading.gif' width='16' height='16'></div>";
    else
        remsg = "<span class='r1_2'></span>";
    return remsg;
}

function imgdis(ti, color){
    var ti = document.getElementById(ti);
    if (ti.innerHTML == "")
        ti.innerHTML = getImgTipFrame("blue");
    else if (color.indexOf("blue") == 0)
        ti.innerHTML = getImgTipFrame("blue");
    else if (color.indexOf("red") == 0)
        ti.innerHTML = getImgTipFrame("red");
    else if (color.indexOf("right") == 0)
        ti.innerHTML = getImgTipFrame("right");

}

/* ***************************
 ** Most of this code was kindly
 ** provided to me by
 ** Andrew Clover (and at doxdesk dot com)
 ** http://and.doxdesk.com/ ;
 ** in response to my plea in my blog at
 ** http://worldtimzone.com/blog/date/2002/09/24
 ** It was unclear whether he created it.
 */
function utf8(wide){
    var c, s;
    var enc = "";
    var i = 0;
    while (i < wide.length) {
        c = wide.charCodeAt(i++);
        // handle UTF-16 surrogates
        if (c >= 0xDC00 && c < 0xE000) continue;
        if (c >= 0xD800 && c < 0xDC00) {
            if (i >= wide.length) continue;
            s = wide.charCodeAt(i++);
            if (s < 0xDC00 || c >= 0xDE00) continue;
            c = ((c - 0xD800) << 10) + (s - 0xDC00) + 0x10000;
        }
        // output value
        if (c < 0x80) enc += String.fromCharCode(c);
        else if (c < 0x800) enc += String.fromCharCode(0xC0 + (c >> 6), 0x80 + (c & 0x3F));
        else if (c < 0x10000) enc += String.fromCharCode(0xE0 + (c >> 12), 0x80 + (c >> 6 & 0x3F), 0x80 + (c & 0x3F));
        else enc += String.fromCharCode(0xF0 + (c >> 18), 0x80 + (c >> 12 & 0x3F), 0x80 + (c >> 6 & 0x3F), 0x80 + (c & 0x3F));
    }
    return enc;
}

var hexchars = "0123456789ABCDEF";

function toHex(n){
    return hexchars.charAt(n >> 4) + hexchars.charAt(n & 0xF);
}

var okURIchars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";

function encodeURIComponentNew(s){
    var s = utf8(s);
    var c;
    var enc = "";
    for (var i = 0; i < s.length; i++) {
        if (okURIchars.indexOf(s.charAt(i)) == -1)
            enc += "%" + toHex(s.charCodeAt(i));
        else
            enc += s.charAt(i);
    }
    return enc;
}

//
// URL 编码
function URLEncode(fld){
    if (fld == "") return false;
    var encodedField = "";
    var s = fld;
    if (typeof encodeURIComponent == "function") {
        // Use javascript built-in function
        // IE 5.5+ and Netscape 6+ and Mozilla
        encodedField = encodeURIComponent(s);
    }
    else {
        // Need to mimic the javascript version
        // Netscape 4 and IE 4 and IE 5.0
        encodedField = encodeURIComponentNew(s);
    }
    return encodedField;
}

/***************************************************************/
/*				以下是常规函数区							   */
/***************************************************************/

/***************************************************************/
/* 设置页面标题												   */
/* @param title 页面标题									   */
/***************************************************************/
function setTitle(title){
    try {
        document.title = title;
    }
    catch (e) {}
}

/***************************************************************/
/* 将某一表单元素设定为得到焦点								   */
/* @param e 要设置的表单元素								   */
/***************************************************************/
function setFocus(e){
    e.focus();
}

/***************************************************************/
/* 将某一网址设定为首页										   */
/* @param url 要设置的网页地址								   */
/***************************************************************/
function setHomePage(url){
    var e = window.event.srcElement;
    e.style.behavior = 'url(#default#homepage)';
    e.setHomePage(url);
}

/***************************************************************/
/* 将某一网址以一定的标题收藏								   */
/* @param url 要设置的网页地址								   */
/* @param title 要设定的标题								   */
/***************************************************************/
function setCollect(url, title){
    window.external.AddFavorite(url, title);
}

/***************************************************************/
/* 重定向到传进来的 url										   */
/* @param url 需要重定向的链接地址							   */
/***************************************************************/
function goURL(url){
    document.location.href = url;
}

/***************************************************************/
/* 设置Cookie												   */
/* @param strName Cookie名称								   */
/* @param strValue Cookie的值								   */
/***************************************************************/
function setCookie(sName, sValue){
    //var expires = new Date();
    //expires.setTime(expires.getTime() + 16 * 60 * 1000);
    //document.cookie = sName + "=" + escape(sValue) + "; expires=" + expires.toGMTString() + "; path=/";
    document.cookie = sName + "=" + escape(sValue) + "; path=/";
}

/***************************************************************/
/* 取得Cookie												   */
/* @param strName Cookie名称								   */
/* @param 与strName对应的Cookie值							   */
/***************************************************************/
function getCookie(sName){
    var aCookie = document.cookie.split("; ");
    for (var i = 0; i < aCookie.length; i++) {
        var aCrumb = aCookie[i].split("=");
        if (sName == aCrumb[0])
            return unescape(aCrumb[1]);
    }
    return null;
}

/***************************************************************/
/* 删除Cookie												   */
/* @param sName 要删除的Cookie名称							   */
/***************************************************************/
function delCookie(sName){
    var expires = new Date();
    expires.setTime(expires.getTime() - 1);
    document.cookie = sName + "=" + null + ";expires=" + expires.toGMTString() + "; path=/";
}

/***************************************************************/
/* <p>根据指定值选定下拉列表</p>							   */
/* @param varObj 要处理的下拉列表							   */
/* @param varValue 要选中的值								   */
/***************************************************************/
function selOption(varObj, varValue){
    if (typeof(varObj) == "object") {
        for (var i = 0; i < varObj.length; i++) {
            if (varObj.options[i].value == varValue) {
                varObj.selectedIndex = i;
                break;
            }
        }
    }
}

/***************************************************************/
/* 选中一组radio按钮中的一项								   */
/***************************************************************/
function chkRadio(obj, val){
    var rLen = obj.length;
    for (var i = 0; i < rLen; i++) {
        if (val == obj[i].value) {
            obj[i].checked = true;
            break;
        }
    }
}

/***************************************************************/
/*		以下是处理日期相关的函数							   */
/***************************************************************/

/***************************************************************/
/* 生成数组对象												   */
/***************************************************************/
function initArray(){
    this.length = initArray.arguments.length
    for (var i = 0; i < this.length; i++)
        this[i + 1] = initArray.arguments[i]
}

/***************************************************************/
/* 在页面输出当前时间										   */
/***************************************************************/
function writeDate(){
    today = new Date();
    var d = new initArray
    (
        "星期日",
        "星期一",
        "星期二",
        "星期三",
        "星期四",
        "星期五",
        "星期六"
    );
    document.write
    (
        "<font color=##000000 style='font-size:9pt;font-family: 宋体'> ",
        today.getYear(), "年",
            today.getMonth() + 1, "月",
        today.getDate(), "日&nbsp;",
        d[today.getDay() + 1],
        "</font>"
    );
}

/***************************************************************/
/* 当前时间YYYY-MM-DD										   */
/***************************************************************/
function todayDate(){
    today = new Date();
    var vYear = today.getFullYear();
    var vMon = today.getMonth();
    if (vMon < 10)
        vMon = vMon + 1;
    var vDay = today.getDate();
    if (vDay < 10)
        vDay = vDay + 1;
    //return vYear+"-"+vMon+"-"+vDay;
    return vYear + "-" + vMon + "-" + vDay;
    //return today.getFullYear()+"-"  + (today.getMonth()+1) + "-"  + (today.getDay()+1);
}

/***************************************************************/
/* 当前时间MM-DD--YYYY										   */
/***************************************************************/
function todayDateMDY(){
    today = new Date();
    var vYear = today.getFullYear();
    var vMon = today.getMonth();
    if (vMon < 10)
        vMon = vMon + 1;
    var vDay = today.getDate();
    if (vDay < 10)
        vDay = vDay + 1;
    return vMon + "-" + vDay + "-" + vYear;

}

/***************************************************************/
/* 检测输入日期是否合法										   */
/***************************************************************/
function checkDate(inputyear, inputmonth, inputday){
    var nowdate = new Date();
    var result;
    var varleap_year;
    result = true;
    if ((inputyear < 1850) || (inputyear > 2500) || (isNaN(inputyear))) result = false;
    if ((inputmonth < 1) || (inputmonth > 12) || (isNaN(inputmonth))) result = false;
    if ((inputday < 1) || (inputmonth > 31) || (isNaN(inputmonth))) result = false;
    if ((((parseInt(inputyear) % 4) == 0) && ((parseInt(inputyear) % 100) != 0)) || ((parseInt(inputyear) % 400) == 0)) {
        if ((parseInt(inputmonth) == 2) && (parseInt(inputday) > 29)) result = false;
        switch (parseInt(inputmonth)) {
            case 4:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
            case 6:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
            case 9:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
            case 11:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
        }
    }
    else {
        switch (parseInt(inputmonth)) {
            case 2:
                if (parseInt(inputday) > 28) {
                    result = false;
                    break;
                }
            case 4:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
            case 6:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
            case 9:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
            case 11:
                if (parseInt(inputday) > 30) {
                    result = false;
                    break;
                }
        }
    }
    return result;
}

/****************************************************************/
/* 取任意一个日期的当月最大天数,如8月有31天						*/
/* @Param:合格的日期,如:new Date()								*/
/* @Return:当月最大天数											*/
/****************************************************************/
function getDays(dDate){
    var iYear = dDate.getFullYear();
    var iMonth = dDate.getMonth() - 1;
    var iDay = dDate.getDate();

    var dStart = new Date(iYear, iMonth, 1);
    var dEnd = dateAdd("m", 1, dStart);

    var iDays = dateDiff("d", dStart, dEnd);
    var iStartDay = (dStart.getDay() + 1);
    for (i = 1; i < 43; i++) {
        if ((i < iStartDay) || ((i - iStartDay + 1) > iDays)) null;
        else var dayScount = (i - iStartDay + 1);
    }
    return parseInt(dayScount);
}

/****************************************************************/
/* 返回已添加指定时间间隔的日期									*/
/* @Param:sInterval时间单位										*/
/* @Param:iNumber要添加间隔数									*/
/* @Param:dDate标准的日期格式									*/
/* @Return:标准的日期格式										*/
/****************************************************************/
function dateAdd(sInterval, iNumber, dDate){
    dTemp = new Date(dDate);
    if (dTemp == "NaN") dTemp = new Date();
    switch (sInterval) {
        case "s" : 	//秒
            return new Date(Date.parse(dTemp) + (1000 * iNumber));
        case "n" : 	//分
            return new Date(Date.parse(dTemp) + (60000 * iNumber));
        case "h" : 	//小时
            return new Date(Date.parse(dTemp) + (3600000 * iNumber));
        case "d" : 	//天
            return new Date(Date.parse(dTemp) + (86400000 * iNumber));
        case "w" : 	//星期
            return new Date(Date.parse(dTemp) + ((86400000 * 7) * iNumber));
        case "m" : 	//月
            return new Date(dTemp.getFullYear(), (dTemp.getMonth()) + iNumber, dTemp.getDate());
        case "y" : 	//年
            return new Date((dTemp.getFullYear() + iNumber), dTemp.getMonth(), dTemp.getDate());
    }
}

/****************************************************************/
/* 返回两个日期之间的时间间隔									*/
/* @Param:sInterval时间单位										*/
/* @Param:dStart开始时间										*/
/* @Param:dEnd结束时间											*/
/* @Return:间隔数												*/
/****************************************************************/
function dateDiff(sInterval, dStart, dEnd){
    dStart = new Date(dStart);
    if (dStart == "NaN") dStart = new Date();
    dEnd = new Date(dEnd);
    if (dEnd == "NaN") dEnd = new Date();
    switch (sInterval) {
        case "s" : 	//秒
            return parseInt((Date.parse(dEnd) - Date.parse(dStart)) / 1000);
        case "n" : 	//分
            return parseInt((Date.parse(dEnd) - Date.parse(dStart)) / 60000);
        case "h" : 	//小时
            return parseInt((Date.parse(dEnd) - Date.parse(dStart)) / 3600000);
        case "d" : 	//天
            iScrap = (Date.parse(dEnd) - Date.parse(dStart)) / 86400000
            iScrap = iScrap + .1
            return parseInt(iScrap);
        case "w" : 	//星期
            return parseInt((Date.parse(dEnd) - Date.parse(dStart)) / (86400000 * 7));
        case "m" : 	//月
            return (dEnd.getMonth() - dStart.getMonth());
        case "y" : 	//年
            return (dEnd.getFullYear() - dStart.getFullYear());
    }
}

/****************************************************************/
/* 返回JavaScript形式的日期										*/
/* @param strDate 形式为2005-4-28格式的字串						*/
/* @return JavaScript形式的日期									*/
/****************************************************************/
function setDate(strDate){
    var s = strDate.split("-");
    var theDate = new Date(parseInt(s[0]), parseInt(s[1]), parseInt(s[2]));
    return theDate;
}

/***************************************************************/
/*		以上是处理日期相关的函数完毕						   */
/***************************************************************/

/***************************************************************/
/* 检查两个下拉菜单数值是否合逻辑							   */
/* 比如:年龄范围等											   */
/***************************************************************/
function selectCheck(obj1, obj2){
    if (typeof(obj1.options[obj1.selectedIndex]) == "unknown" || typeof(obj2.options[obj2.selectedIndex]) == "unknown") {
        retrun;
    }
    var idx1 = obj1.selectedIndex;
    var idx2 = obj2.selectedIndex;
    if (parseInt(obj1.value) > parseInt(obj2.value)) {
        obj2.selectedIndex = idx1;
    }
}

/***************************************************************/
/* 返回多个地址												   */
/***************************************************************/
function writeLocalAddress(local1, local2, local3){
    var str = "";
    var area1 = "";
    if (local1 != 0) area1 = getAreaNm(local1);
    var area2 = "";
    if (local2 != 0) area2 = getAreaNm(local2);
    var area3 = "";
    if (local3 != 0) area3 = getAreaNm(local3);
    str = area1 + ";" + area2 + ";" + area3;
    str = str.replace(";;", ";");
    var iLen = str.lastIndexOf(";");
    if (iLen != -1 && iLen == str.length - 1)	//去末位";"号
        str = str.substring(0, iLen);
    if (str.indexOf(";") == 0)				//去首位";"号
        str = str.substring(1, str.length);
    return str;
}
/***************************************************************/
/* 处理查询关键字											   */
/***************************************************************/
function makeKeyword(str, keyword){
    if (s == "") return "";

    var rgExpHtml1 = new RegExp("<", "gi");
    var rgExpHtml2 = new RegExp(">", "gi");
    var rgExpKey = new RegExp(keyword, "gi");
    var replaceText = "<span style=\"color:#FF0000;\">" + keyword + "</span>";

    if (str.search(rgExpHtml1) == -1) {
        return str.replace(rgExpKey, replaceText);
    } else {
        var result = "";
        var begin = 0;
        var end = 0;
        var transact = false;
        var s;
        for (var i = 0; i < str.length; i++) {
            s = str.charAt(i);

            if (s == '<') {
                end = i;
                result += str.substring(begin, end).replace(rgExpKey, replaceText);
                begin = i;
                end = i;
            }

            if (s == '>') {
                result += str.substring(begin, i + 1);
                begin = i + 1;
                end = i + 1;
            }

        }
        result += str.substring(begin, i + 1).replace(rgExpKey, replaceText);

        return result;
    }
}

function disKeyWord(strx){
    var keyword = strx;
    keyword = keyword.trim();
    if (keyword.length == 0) return;
    var filter = "&nbsp;";

    var arrKeyword = keyword.split(",");

    for (var j = 0; j < arrKeyword.length; j++) {
        keyword = arrKeyword[j].trim();
        if (filter.indexOf(keyword) >= 0) break;
        if (typeof(resume) == "object") {
            if (resume.length > 0) {
                for (var i = 0; i < resume.length; i++) {
                    resume[i].innerHTML = makeKeyword(resume[i].innerHTML, keyword);
                }
            } else {
                resume.innerHTML = makeKeyword(resume.innerHTML, keyword);
            }
        }
    }
}

/***************************************************************/
/* 得到当前radio选中的值									   */
/***************************************************************/
function getRadioValue(objString){
    var rstring = "";
    var obj = eval(objString);
    if (obj.length != null) {
        var rLen = obj.length;
        for (var i = 0; i < rLen; i++) {
            if (obj[i].checked) {
                rstring = obj[i].value;
                break;
            }
        }
    } else {
        if (obj.checked) {
            rstring = obj.value;
        }
    }
    return rstring;
}

/***************************************************************/
/*	得到当前checkbox选中的值								   */
/***************************************************************/
function getCheckboxValue(objString){
    var rstring = "";
    var obj = eval(objString);
    if (obj.length != null) {
        var rLen = obj.length;
        for (var i = 0; i < rLen; i++) {
            if (obj[i].checked) {
                rstring += "," + obj[i].value;
            }
        }
    } else {
        if (obj.checked) {
            rstring = "," + obj.value;
        }
    }

    if (rstring != "") {
        return rstring.substring(1);
    } else {
        return rstring;
    }
}

/***************************************************************/
/* 得到当前多项值组合										   */
/***************************************************************/
function getHiddenTextValue(objString){
    var rstring = "";
    var obj = eval(objString);
    if (obj.length != null) {
        var rLen = obj.length;
        for (var i = 0; i < rLen; i++) {
            rstring += "," + obj[i].value;
        }
    } else {
        rstring = "," + obj.value;
    }

    if (rstring != "") {
        return rstring.substring(1);
    } else {
        return rstring;
    }
}

/***************************************************************/
/*	设置所有控件不为可读									   */
/***************************************************************/
function SetButtonDisabled(){
    for (var i = 0; i < document.forms[0].elements.length; i++) {
        document.forms[0].elements[i].readonly = true;
        document.forms[0].elements[i].disabled = true;
    }
}

/***************************************************************/
/*	设置所有控件为可读										   */
/***************************************************************/
function SetButtonAbled(){
    for (var i = 0; i < document.forms[0].elements.length; i++) {
        document.forms[0].elements[i].readonly = false;
        document.forms[0].elements[i].disabled = false;
    }
}

function hiddenOrDisplayModule(id){
    var obj = eval("sub" + id);
    var obj2 = eval("tip" + id);
    if (obj.style.display == "none") {
        obj.style.display = "";
        obj2.innerHTML = "<img  src=/images/open.gif>";
    }
    else {
        obj.style.display = "none";
        obj2.innerHTML = "<img  src=/images/close.gif>";
    }
}

/***************************************************************/
/*		以下是字符串相关处理								   */
/***************************************************************/

/***************************************************************/
/** 为字符串增加trim方法，以去除左右空格                       */
/***************************************************************/
String.prototype.trim = function (){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.LTrim = function (){return this.replace(/^\s+/g, "");}
String.prototype.RTrim = function (){return this.replace(/\s+$/g, "");}
String.prototype.LRTrim = function (){return this.replace(/^\s+|\s+$/g, "");}
String.prototype.getCharLength = function (){
    var pattern = /([a-z0-9]|!|,|\.)+/;
    var len = this.length;

    var arr = pattern.exec(this);
    if (arr != null) {
        len = len - parseInt(arr.length / 2);
    }

    return len;
}

/***************************************************************/
/** 截取字符串                                                   */
/***************************************************************/
String.prototype.cutChar = function (len){
    var clen = this.substr(0, len).getCharLength();

    if (len - clen > 1) {
        len = len + len - clen;
        clen = this.substr(0, len).getCharLength();
    }
    return this.substr(0, len);
}

/***************************************************************/
/* 将某一字符串去所有空格处理								   */
/* @param strs 要处理的字符串								   */
/***************************************************************/
function delnbsp(strs){
    var Finds = / /g;
    strs = strs + strs.replace(Finds, "");
    return strs;
}
/***************************************************************/
/** 取得字符的字节长度（汉字占2，字母占1）                       */
/***************************************************************/
function strLen(s){
    var len = 0;
    for (var i = 0; i < s.length; i++) {
        if (!ischinese(s.charAt(i))) {
            len += 1;
        } else {
            len += 2;
        }
    }
    return len;
}

/***************************************************************/
/* 判断是否中文函数											   */
/***************************************************************/
function ischinese(s){
    var ret = false;
    for (var i = 0; i < s.length; i++) {
        if (s.charCodeAt(i) >= 256) {
            ret = true;
            break;
        }
    }
    return ret;
}

/***************************************************************/
/*判断是否只有中文与字母（既没数字和其他@#￥%……—*字符）函数 */
/***************************************************************/
function isChar(s){
    var r;
    var re;
    var regu = "^[a-zA-Z]";
    re = new RegExp(regu);
    var ret = true;
    var len = s.length;
    for (var i = 0; i < len; i++) {
        var chart = s.charAt(i);
        var r = chart.search(re);
        if (r == -1) {
            ret = ret && ischinese(chart);
        }
    }
    return ret;
}

/***************************************************************/
/** 将某一字符串去左右空格处理                                   */
/* @param s 要处理的字符串									   */
/***************************************************************/
function trim(s){
    var count = s.length;
    var st = 0;       // start
    var end = count - 1; // end

    if (s == "") return s;
    while (st < count) {
        if (s.charAt(st) == " ")
            st++;
        else
            break;
    }
    while (end > st) {
        if (s.charAt(end) == " ")
            end--;
        else
            break;
    }
    return s.substring(st, end + 1);
}

/***************************************************************/
/** <p>测量有汉字时的字串实际长度，其中一个汉字占两个字符</p>  */
/***************************************************************/
function len(s){
    var length = 0;
    var tmpArr = s.split("");

    for (i = 0; i < tmpArr.length; i++) {
        if (tmpArr[i].charCodeAt(0) < 299)
            length++;
        else
            length += 2;
    }
    return length;
}
/***************************************************************/
/* <p>是否为合法字串，指只包括字母，数字和_的字串</p>		   */
/* @param s 要检查的字串									   */
/* @return true or false									   */
/***************************************************************/
function isStr(s){
    if (s.length == 0) return false;
    var regu = "^[0-9A-Za-z_-]*$";
    var re = new RegExp(regu);
    //alert("ssss---s.search(re):"+s.search(re));
    s = s.replace('@', '');
    s = s.replace('.', '');
    if (s.search(re) != -1)
        return true;
    else {
        if (ischinese(s)) { return true;}
        if (isEmail(s)) return true;
        else return false;
    }
}

function isValidAccountPass(s){
    if (s.length == 0) return false;
    var regu = "^[0-9A-Za-z_-]*$";
    var re = new RegExp(regu);
    // alert("ssss---s.search(re):"+s.search(re));
    if (s.search(re) != -1)
        return true;
    else {
        return false;
    }
}
/***************************************************************/
/* <p>是否为合法字串，指只包括字母，数字和_的字串</p>		   */
/* @param s 要检查的字串									   */
/* @return true or false									   */
/***************************************************************/
function isValidAccountMatch(s){
    if (s.length == 0) return false;
    var sReg = "^(([a-zA-Z0-9]{1,15})([a-z0-9A-Z.@_-])*)$";
    var sMatchReg = s.match(sReg);
    if (sMatchReg != null)
        return true;
    else
        return false;
}

/***************************************************************/
/* 汉字，字母,数字, 中横杠和下划线							   */
/***************************************************************/
function isValidAccountCombination(s){
    var reg = "([\u4E00-\u9FA5]{1,15}([a-z0-9A-Z@_-])*)";
    var matchReg = s.match(reg);

    if (s.indexOf(" ") > -1 || s.indexOf("　") > -1) {
        return 1;	// 含有空格
    }

    if (matchReg != null) { // 汉字
        if (len(s) < 3 || len(s) > 30) {
            return 2;	     // 汉字位数不足
        } else {
            return 3;		// 汉字组合正确
        }
    }
    else {
        if (isValidAccountMatch(s)) {
            if (len(s) < 3 || len(s) > 15) {
                return 4;	     // 位数不足
            }
            else {
                return 3;		// 字母组合正确
            }
        }
    }
    return 7;	// 未输出状态
}

function isEmail(s){
    if (s.length > 100 || s.length == 0)    return false;
    if (s.indexOf("'") != -1 || s.indexOf("/") != -1 || s.indexOf("\\") != -1 || s.indexOf("<") != -1 || s.indexOf(">") != -1)
        return false;
    if (s.indexOf(" ") > -1 || s.indexOf("　") > -1) {
        alert("邮件列表有空格,请修改!");
        return false;
    }
    //var regu = "^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[_.0-9a-zA-Z]+))@([a-zA-Z0-9-]+[.])+(.+)$";
    var regu = "^(([0-9a-zA-Z]+)|([0-9a-zA-Z]+[_.0-9a-zA-Z-]*[_.0-9a-zA-Z]+))@{1}(([a-zA-Z0-9-]+[.]{1})([a-zA-Z0-9-]+))+$";
    var re = new RegExp(regu);
    s = s.replace("；", ";");
    s = s.replace("<", "");
    s = s.replace(">", "");
    s = s.replace('(', '');
    s = s.replace(')', '');
    s = s.replace('（', '');
    s = s.replace('）', '');
    var mail_array = s.split(";");
    var part_num = 0;
    var isemail = true;
    while (part_num < mail_array.length) {
        if (mail_array[part_num].search(re) == -1) { isemail = false;}
        part_num += 1;
    }
    return isemail;
}

/***************************************************************/
/** 计算输入字符串的字节长度                                   */
/***************************************************************/
function getByteLen(str){
    var len = 0;
    for (var i = 0; i < str.length; i++)
        len += isDoubleByte(str.charAt(i)) ? 2 : 1;
    return len;
}

/***************************************************************/
/* 过滤HTML代码												   */
/***************************************************************/
function checkdata_htm(checkStr){
    var checkOK = "<>'%?/\+|";
    var returnstr = "";
    if (checkStr.length > 0) {
        for (i = 0; i < checkStr.length; i++) {
            ch = checkStr.charAt(i);
            for (j = 0; j < checkOK.length; j++) {
                if (ch == checkOK.charAt(j)) {
                    returnstr = "true";
                    break;
                }
            }
        }
    }
    if (returnstr == "true") {
        return true;
    }
    else {
        return false;
    }
}
/***************************************************************/
/** 检查电话号码输入是否合法                                   */
/***************************************************************/
function isPhone(s){
    var regu = "^(([(0-9)]+)|([0-9-]+))(([0-9-]+)|([0-9]+))([0-9])$";
    var re = new RegExp(regu);
    if (s.search(re) != -1)
        return true;
    else
        return false;
}
function getCheckErrInfo(idx){
    var info = '';
    switch (idx) {
        case 1:
            info = '不是有效电话号码,请修改!(如010-3366291-129)请注意:全角字符不能通过校验!';
            break;
        case 2:
            info = '不是有效手机号码,请修改!([0]13xxxxxxxxx)请注意:全角字符不能通过校验!';
            break;
        case 3:
            info = '不是有效呼机号码,请修改!(如[010-]90951-95005)请注意:全角字符不能通过校验!';
            break;
        default:
            info = '不是有效电话号码,请修改!(如010-3366291-129)请注意:全角字符不能通过校验!';
    }
    alert(info);
    //return info;
}

/***************************************************************/
/** 只允许输入数字                                               */
/** 浏览器兼容性问题 2007-05-08                                   */
/***************************************************************/
function IsDigit(){
    // 浏览器事件兼容性问题
    //evt = (evt) ? evt : ((window.event) ? window.event : "")     
    //var keyCode = evt.keyCode ? evt.keyCode : (evt.which ? evt.which :evt.charCode);
    return ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode == 13));
}

/***************************************************************/
/** 构造 StringBuilder 对象 begin                               */
/***************************************************************/
function StringBuilder(){
    this._strings_ = new Array();
}
StringBuilder.prototype.append = function (str){
    this._strings_.push(str);
}
StringBuilder.prototype.toString = function (){
    return this._strings_.join("");
}
/** 构造 StringBuilder 对象 end                                 **/

/*************************************************
 函数功能：表单必输项的检测
 参    数：   类型         含义
 objName      对象         对象名称
 返 回 值：0:非空，1:空
 ************************************************/
function IsNull(objName){
    var i = 0;
    var objLen = 0;
    var strTemp = objName.value;
    if (strTemp.length == 0) {return true;}
    else {
        for (i = 0; i < strTemp.length; i++) {
            if (strTemp.charAt(i) != " ")    objLen++;
        }
        if (objLen == 0) {
            return true;
        }
        else
            return false;
    }
}
/***************************************************************/

/*************************************************
 函数功能：表单必输项的检测
 参    数：   类型         含义
 objName      对象         对象名称
 返 回 值：0:非空，1:空
 ************************************************/
function IsEmpty(strObjName){
    var i = 0;
    var objLen = 0;
    var objName = document.all(strObjName);
    var strTemp = objName.value;
    if (strTemp.length == 0) {return true;}
    else {
        for (i = 0; i < strTemp.length; i++) {
            if (strTemp.charAt(i) != " ") objLen++;
        }
        if (objLen == 0) {
            return true;
        }
        else
            return false;
    }
}
/***************************************************************/

/***************************************************************/
/*		以上是字符串相关处理								   */
/***************************************************************/


/***************************************************************/
/* 随机数 begin												   */
/***************************************************************/
rnd.today = new Date();
rnd.seed = rnd.today.getTime();

function rnd(){
    rnd.seed = (rnd.seed * 9301 + 49297) % 233280;
    return rnd.seed / (233280.0);
}

function rand(number){
    return Math.ceil(rnd() * number);
}

/***************************************************************/
/* 随机数 end													*/
/***************************************************************/

/***************************************************************/
/* 回车转tab begin											   */
/***************************************************************/
function enterToTab(){
    // 浏览器事件兼容性问题
    //var evt = (evt) ? evt : ((window.event) ? window.event : "");     
    //var keyCode = evt.keyCode ? evt.keyCode : (evt.which ? evt.which :evt.charCode);
    //if (keyCode==13) evt.keyCode ? evt.keyCode=9 : (evt.which ? evt.which=9 :evt.charCode);
    var keyCode = (window.event) ? event.keyCode : event.which;
    if (keyCode == 13) (window.event) ? event.keyCode = 9 : event.which = 9;
}
/* 回车转tab end */

/***************************************************************/
/* 交换图片按钮												   */
/***************************************************************/
function MM_swapImgRestore(){ //v3.0
    var i, x, a = document.MM_sr;
    for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
}
function MM_preloadImages(){ //v3.0
    var d = document;
    if (d.images) {
        if (!d.MM_p) d.MM_p = new Array();
        var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
        for (i = 0; i < a.length; i++)
            if (a[i].indexOf("#") != 0) {
                d.MM_p[j] = new Image;
                d.MM_p[j++].src = a[i];
            }
    }
}
function MM_findObj(n, d){ //v4.01
    var p, i, x;
    if (!d) d = document;
    if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
        d = parent.frames[n.substring(p + 1)].document;
        n = n.substring(0, p);
    }
    if (!(x = d[n]) && d.all) x = d.all[n];
    for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
    for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
    if (!x && d.getElementById) x = d.getElementById(n);
    return x;
}
function MM_swapImage(){ //v3.0
    var i, j = 0, x, a = MM_swapImage.arguments;
    document.MM_sr = new Array;
    for (i = 0; i < (a.length - 2); i += 3)
        if ((x = MM_findObj(a[i])) != null) {
            document.MM_sr[j++] = x;
            if (!x.oSrc) x.oSrc = x.src;
            x.src = a[i + 2];
        }
}

/***************************************************************/
/* 刷新验证码												  */
/***************************************************************/
function refreshCode(){
    var randomNum = Math.random();
    var getAuthcode = document.getElementById("cAuthcodePic");
    getAuthcode.src = "/Service/AntiGameWebImageGen.aspx?" + randomNum;
}

/***************************************************************/
/* 刷新验证码, 登陆|注册									   */
/***************************************************************/
function refreshSiteCode(){
    var randomNum = Math.random();
    var getAuthcode = $("authcodePic");

    if (getAuthcode != null || getAuthcode != undefined) {
        getAuthcode.src = "/tools/AntiGameWebImageGen.aspx?" + randomNum;
    }
}

/********************************************************************/
/*  隐藏 Div 的显示                                                 */
/********************************************************************/
function HiddenDiv(div_h){
    div_h.style.display = 'none';
}

// 层的显示与隐藏
function expandoptions(id){
    var a = $(id);
    if (a.style.display == '') {
        a.style.display = 'none';
    }
    else {
        a.style.display = '';
    }
}

/********************************************************************/
/*  Ajax 对象的创建                                                 */
/********************************************************************/

var zXml = {
    useActiveX: (typeof ActiveXObject != "undefined"),
    useDom: document.implementation && document.implementation.createDocument,
    useXmlHttp: (typeof XMLHttpRequest != "undefined")
};

zXml.ARR_XMLHTTP_VERS = ["MSXML2.XmlHttp.5.0",
    "MSXML2.XmlHttp.4.0",
    "MSXML2.XmlHttp.3.0",
    "MSXML2.XmlHttp",
    "Microsoft.XmlHttp"];
zXml.ARR_DOM_VERS = ["MSXML2.DOMDocument.5.0",
    "MSXML2.DOMDocument.4.0",
    "MSXML2.DOMDocument.3.0",
    "MSXML2.DOMDocument",
    "Microsoft.XmlDom"];
;

function zXmlHttp(){}

zXmlHttp.createRequest = function (){
    if (zXml.useXmlHttp) {
        return new XMLHttpRequest();
    }
    else if (zXml.useActiveX) {
        if (!zXml.XMLHTTP_VER) {
            for (var i = 0; i < zXml.ARR_XMLHTTP_VERS.length; i++) {
                try {
                    new ActiveXObject(zXml.ARR_XMLHTTP_VERS[i]);
                    zXml.XMLHTTP_VER = zXml.ARR_XMLHTTP_VERS[i];
                    break;
                }
                catch (oError) {;}
            }
        }
        if (zXml.XMLHTTP_VER) {
            return new ActiveXObject(zXml.XMLHTTP_VER);
        }
        else {
            throw new Error("Could not create XML HTTP Request.");
        }
    } else {
        throw new Error("Your browser doesn't support an XML HTTP Request.");
    }
};

zXmlHttp.isSupported = function (){
    return zXml.useXmlHttp || zXml.useActiveX;
};

/********************************************************************/
/*  Ajax读取对象的                                                 */
/********************************************************************/
function ajaxRead(file, fun){
    var xmlObj = zXmlHttp.createRequest();
    xmlObj.onreadystatechange = function (){
        if (xmlObj.readyState == 4) {
            if (xmlObj.status == 200) {
                obj = xmlObj.responseXML;
                eval(fun);
            }
            else {
                alert("读取文件出错,错误号为 [" + xmlObj.status + "]");
            }
        }
    }
    xmlObj.open('GET', file, true);
    xmlObj.send(null);

}

//序列化tr内所有input元素
function serializeInput(obj){
    var returnValue = "";
    $(obj).closest("tr").find("input").each(function (){
        returnValue += $(this).attr("name") + "=" + $(this).val() + "&";
    })
    returnValue = returnValue.substring(0, returnValue.length - 1);
    return returnValue;
}

/************* HTML 编码 BEGIN ****************************************/
function htmlEncode(source, display, tabs){
    function special(source){
        var result = '';
        for (var i = 0; i < source.length; i++) {
            var c = source.charAt(i);
            if (c < ' ' || c > '~') {
                c = '&#' + c.charCodeAt() + ';';
            }
            result += c;
        }
        return result;
    }

    function format(source){
        // Use only integer part of tabs, and default to 4
        tabs = (tabs >= 0) ? Math.floor(tabs) : 4;

        // split along line breaks
        var lines = source.split(/\r\n|\r|\n/);

        // expand tabs
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i];
            var newLine = '';
            for (var p = 0; p < line.length; p++) {
                var c = line.charAt(p);
                if (c === '\t') {
                    var spaces = tabs - (newLine.length % tabs);
                    for (var s = 0; s < spaces; s++) {
                        newLine += ' ';
                    }
                }
                else {
                    newLine += c;
                }
            }
            // If a line starts or ends with a space, it evaporates in html
            // unless it's an nbsp.
            newLine = newLine.replace(/(^ )|( $)/g, '&nbsp;');
            lines[i] = newLine;
        }

        // re-join lines
        var result = lines.join('<br />');

        // break up contiguous blocks of spaces with non-breaking spaces
        result = result.replace(/  /g, ' &nbsp;');

        // tada!
        return result;
    }

    var result = source;

    // ampersands (&)
    result = result.replace(/\&/g, '&amp;');

    // less-thans (<)
    result = result.replace(/\</g, '&lt;');

    // greater-thans (>)
    result = result.replace(/\>/g, '&gt;');

    if (display) {
        // format for display
        result = format(result);
    }
    else {
        // Replace quotes if it isn't for display,
        // since it's probably going in an html attribute.
        result = result.replace(new RegExp('"', 'g'), '&quot;');
    }

    // special characters
    result = special(result);

    // tada!
    return result;
}

/************* HTML 编码 OVER ****************************************/





/************************* END **************************************/
