/* 全局调试开关  0 关 1 开; */
var GLOBALS_DEBUG = 1;

//列表样式控制脚本
var body = (document.compatMode && document.compatMode.toLowerCase() == "css1compat") ? document.documentElement : document.body;
function ResizeTable(){
    if (document.getElementById('content') != null) {
        var tableDiv = document.getElementById('content');
        if (document.getElementById('OpList') == null)
            tableDiv.style.height = '' + Math.max((body.clientHeight - tableDiv.offsetTop - 31), 0) + "px";
        else
            tableDiv.style.height = '' + Math.max((body.clientHeight - tableDiv.offsetTop - 70), 0) + "px";
    }
}
window.onload = function (){
    ResizeTable();
    window.onresize = ResizeTable;
}

//批量控制操作
function deleteop(){
    var checkok = false;
    var e = GelTags("input", SW("list"));
    for (var i = 0; i < e.length; i++) {
        if (e[i].type == "checkbox") {
            if (e[i].checked == true) {
                checkok = true;
                break;
            }
        }
    }
    if (checkok)
        return confirm('确认要操作选中记录吗？');
    else {
        showError("请选择要操作的记录!");
        return false;
    }
}

function WindowDeleteOp(){
    var checkok = false;
    var e = GelTags("input", SW("list"));
    for (var i = 0; i < e.length; i++) {
        if (e[i].type == "checkbox") {
            if (e[i].checked == true) {
                checkok = true;
                break;
            }
        }
    }
    if (checkok)
        return confirm('确认要操作选中记录吗？');
    else {
        alert("请选择要操作的记录!");
        return false;
    }
}

var S = function (object){
    return document.getElementById(object);
};

/*
 Object.prototype._attachEvent = Object.prototype.attachEvent;
 Object.prototype.attachEvent = function(eventType, method, type) {
 if (document.all) {
 return this._attachEvent(eventType, method);
 }
 else {
 return this.addEventListener(eventType.replace(/\bon/ig, ""), method, type);
 }
 }
 */

function isblank(s){
    for (var i = 0; i < s.length; i++) {
        var c = s.charAt(i);
        if ((c != ' ') && (c != '\n') && (c != '\t')) return false;
    }
    return true;
}

function RegFilter(str){
    return str.replace(/([\^\.\[\$\(\)\|\*\+\?\{\\])/ig, "\\$1");
}

//global base function
var gd = document;
function Gel(id, ob){
    return (ob || gd).getElementById(id);
}

function GelTags(tag, ob){
    return (ob || gd).getElementsByTagName(tag);
}

function SW(i, win){
    try {
        return (win || window).document.getElementById(i);
    }
    catch (e) {
        return null;
    }
}

function F(sID, win){
    if (!sID)
        return null;
    var frame = SW(sID, win);
    if (!frame)
        return null;
    return frame.contentWindow || (win || window).frames[sID];
}

function SO(i, o){
    return Gel(i, o);
}
function SN(i, win){
    try {
        return (win || window).document.getElementsByName(i);
    }
    catch (e) {
        return null;
    }
}
function SNO(i, o){
    return (o ? o : gd).getElementsByName(i);
}
function SetClass(o, v){
    //if (o && o.className != v)
    o.className = v;
    alert(o);
    alert(o.className);
}

//
function IsShow(obj){
    obj = (typeof (obj) == "string" ? S(obj) : obj);
    if (!obj) return false;
    return obj.style.display != "none";
}
function Show(obj, bShow){
    obj = (typeof (obj) == "string" ? S(obj) : obj);
    if (obj) obj.style.display = (bShow ? "" : "none");
}
function ShowN(name, bShow){
    var o = SN(name);
    for (var i = o.length - 1; i >= 0; i--) {
        Show(o[i], bShow);
    }
}

function GetMainWin(){
    return F("frm_main_content", top) || top;
    ;
}

function Redirect(url){
    try {
        GetMainWin().location = url;
    }
    catch (e) {
        top.S("frm_main_content").src = url;
    }
}

//str api
function Trim(sStr){
    return sStr.replace(/(^\s*)|(\s*$)/ig, "");
}
function StrReplace(s, o, d, mode){
    return s.replace(new RegExp(RegFilter(o), mode), d);
}
function HighLight(filter, head, end){
    return function (str){
        return str.replace(new RegExp(["(", RegFilter(filter), ")"].join(""), "ig"), [head, "$1", end].join(""));
    };
}
function FormatDate(_aDate, _aPattern, _aSymbol){
    function _format(_aNum){
        return _aNum < 10 ? "0" + _aNum : _aNum;
    }

    var _date = _aDate || new Date();
    return T(_aPattern, _aSymbol).replace({
        YY: _format(_date.getYear()),
        MM: _format(_date.getMonth() + 1),
        DD: _format(_date.getDate()),
        hh: _format(_date.getHours()),
        mm: _format(_date.getMinutes()),
        ss: _format(_date.getSeconds())
    });
}
function GetAsiiStrLen(_aStr){
    return (_aStr || "").replace(/[^\x00-\xFF]/g, "aa").length;
}
function SubAsiiStr(_aStr, _aLen, _aPlus){
    _aStr = Trim(new String(_aStr || ""));
    _aPlus = _aPlus || "";

    var _cutLen = _aLen - _aPlus.length;
    _cutLen = _cutLen <= 0 ? 1 : _cutLen;

    for (var i = 0, _strLen = _aStr.length, _countLen = 0, _cutPos = -1; i < _strLen; i++) {
        var _charCode = _aStr.charCodeAt(i);
        //asii -> 1 ( # W -> 1.3 )
        //not asii -> 1.5
        _countLen += _charCode == 35 || _charCode == 87 ? 1.2 : (_charCode > 255 ? 1.5 : 1);
        if (_cutPos == -1 && _countLen > _cutLen)
            _cutPos = i;
        if (_countLen > _aLen)
            return _aStr.substr(0, _cutPos) + _aPlus;
    }

    return _aStr;
}

function CreateMessageBox(){
    var msgBox = S("msgBoxDIV", top);
    if (!msgBox) {
        InsertHTML(top.document.body, "afterBegin",
            ['<div id="msgBoxDIV" style="position:absolute;width:100%;padding-top:4px;height:24px;top:', top.bnewwin ? '24' : '43', 'px;text-align:center;"><span></span></div>'].join(""));
        msgBox = S("msgBoxDIV", top);
    }
    return msgBox;
}
//出错显示函数
//mbtype消息框类型,默认为提示提示框
//mbtype  success 成功
//moduel  弹出框
function fMessageBox(msg, mbtype, bHide, hidetime, dialogTitle, win){
    if (window != top)
        return top.fMessageBox(msg, mbtype, bHide, hidetime, dialogTitle, win);

    if (!msg) {
        var oMsgObj = S("msg_txt", win || window) || S("msg_txt", GetActionWin());
        if (oMsgObj && (oMsgObj.innerText || oMsgObj.textContent) && oMsgObj.getAttribute("ok") != "true") {
            msg = oMsgObj.innerHTML.replace(/<script .*>(.|\n)*<\/script>/ig, "");
            oMsgObj.setAttribute("ok", "true");
        }
    }

    if (!msg || !(msg = Trim(msg.replace(/[\r\n]/ig, ""))))
        return;

    HiddenMsg();

    if (mbtype == "dialog") {
        ModelDialog(1, dialogTitle ? dialogTitle : "确认", [
            "<div style='padding:10px 0 5px 10px;text-align:left;'>",
            "<img src='", GetPath("image", true), "ico_question.gif' align='absmiddle' style='float:left;margin:5px 0 0 10px;'>",
            "<div style='width:300px;height:80px;overflow:hidden;'><table width=300px height=80px><tr><td>", msg, "</td></tr></table></div>",
            "</div>",
            "<div style='text-align:right;padding:0 10px 10px 0;'>",
            "<input class='wd2 btn' type=button id=confirm value=确认>",
            "</div>"
        ].join(""), "confirm", ["confirm"], [function (){ HideModelDialog(); } ]);
    }
    else {
        var msgBox = CreateMessageBox().firstChild;
        top.document.getElementById("spnTopMsg").className = mbtype == "success" ? "msg" : "errmsg";
        top.document.getElementById("spnTopMsg").innerHTML = msg;
        ShowMsg();
        if (bHide)
            top.msgBoxTimer = top.setInterval(top.HiddenMsg, hidetime || 5000);
        top.msgDispTime = new Date();
    }
}
function showError(err, dtime){
    fMessageBox(err, "", true, dtime ? dtime : 5000);
}
function showInfo(info, dtime){
    fMessageBox(info, "success", true, dtime ? dtime : 5000);
}
function IsShowMsg(){
    return top.IsShow("msgBoxDIV");
}
function HiddenMsg(){
    if (top.msgBoxTimer) {
        top.clearInterval(top.msgBoxTimer);
        top.msgBoxTimer = null;
    }
    top.Show("msgBoxDIV", false);
    top.ShowProcess(0);
}
function ShowMsg(){
    top.Show("msgBoxDIV", true);
}

//
//flag: 0-hide 1-info 2-rate; bImg: is disp load img; parm: parameter
function ShowProcess(flag, isShowImg, parm, parm2, isHasCancel){
    var id = "load_process";
    var f = top;
    var bar = SW(id, f);
    if (flag == 0) {
        if (IsShow(bar))
            Show(bar, false);
        return
    }

    if (!IsShow(bar) && !(bar = CreateProcessUI(isHasCancel)))
        return;

    HiddenMsg();
    Show(bar, true);

    var info = SW(id + "_info", f);
    if (flag == 2) {
        if (parm2 != null)
            SW(id + "_plan_info", f).innerHTML = parm2;

        parm = parseInt(parm);
        parm = isNaN(parm) ? 0 : (parm < 0 ? 0 : (parm > 100 ? 100 : parm));
        SW(id + "_plan_rate", f).innerHTML = parm + "%";
        SW(id + "_plan_bar", f).style.width = parm + "%";

        Show(S(id + "_plan", f), true);
        Show(S(id + "_img", f), false);
        Show(info, false);
    }
    else {
        if (parm != null)
            info.innerHTML = parm;

        Show(SW(id + "_plan", f), false);
        Show(SW(id + "_img", f), isShowImg);
        Show(info, true);
    }
}
function CreateProcessUI(isHasCancel){
    var bar = SW("load_process", top);
    var cancel = SW("load_process_cancel", top);

    // must
    isHasCancel = true;

    if (bar) {
        if ((isHasCancel && bar) || (!isHasCancel && !bar))
            return bar;
        RemoveSelf(bar);
    }

    var val = [
        [240, -120, "padding:0 38px 0 28px;width:174px!important;width:240px;"],
        [214, -107, "padding:0 0 0 28px;width:170px!important;width:214px;"]
    ][isHasCancel ? 0 : 1];
    InsertHTML(top.document.body, "afterBegin", [
        '<div id="load_process" class="autosave autosave_txt" style="width:', val[0], 'px;height:19px;position:absolute;top:', top.bnewwin ? '24' : '46', 'px;left:50%;margin-left:', val[1], 'px;text-align:left;overflow:hidden;">',
        '<div id="load_process_plan" style="display:none;">',
        '<div style="font:1px;height:12px;border:1px solid white;width:104px;text-align:left;float:left;margin:4px 3px 0 0">',
        '<div id="load_process_plan_bar" style="background:#fff;height:8px;margin:1px 0 0 0;width:0%;"></div>',
        '</div>',
        '<div style="width:78px;line-height:18px;">',
        '<span id="load_process_plan_info">发信中</span>:<span id="load_process_plan_rate" style="width:35px;text-align:right;">0%</span>',
        '</div>',
        '</div>',
        '<div id="load_process_info" style="display:none;line-height:20px;text-align:center;', val[2], '"></div>',
        '<div id="load_process_img" style="display:none;position:absolute;margin:-18px 0 0 5px!important;margin:-18px 0 0 5px;">',
        '<img src="', GetPath("image", true), 'ico_loading.gif" style="width:16px;height:16px;">',
        '</div>',
        (isHasCancel ? '<div id="load_process_cancel" class="autosave" style="position:absolute;margin:-20px 0 0 200px!important;margin:-19px 0 0 195px;">[<a onclick="top.GetMainWin().CancelDoSend();" style="color:white;">取消</a>]</div>' : ''),
        '</div>'
    ].join(""));

    return S("load_process", top);
}
function GetProcessInfo(){
    var id = "load_process";
    var f = top;
    if (IsShow(SW(id, f))) {
        var info1 = SW(id + "_plan_rate", f);
        var info2 = SW(id + "_info", f);
        if (info2 && IsShow(info2))
            return info2.innerHTML;
        if (info1 && IsShow(SW(id + "_plan", f)))
            return parseInt(info1.innerHTML);
    }
    return "";
}

//地址转向
function goUrl(_aFrameObj, _aUrl, _aIsSetHistory){
    try {
        var _location = (_aFrameObj.contentWindow || _aFrameObj).location;
        if (_aIsSetHistory) {
            _location.href = _aUrl;
        }
        else {
            _location.replace(_aUrl);
        }
    }
    catch (e) {
        _aFrameObj.src = _aUrl;
    }
}

function GoUrlMainFrm(url, bNoHistroy){
    try {
        if (bNoHistroy) {
            GetMainWin().location.replace(url);
        }
        else {
            GetMainWin().location.href = url;
        }
    }
    catch (e) {
        top.S("frm_main_content").src = url;
    }
}

//checkbox
function SetListCheck(input, checked, mouseon){
    if (input.type != "checkbox")
        return;

    if (checked == null) {
        checked = input.checked;
    }
    else {
        input.checked = checked;
    }

    var obj = input.parentNode.parentNode;
    //for table
    if (obj.tagName == "TR")
        obj = obj.parentNode.parentNode;

    var tmpClassName = obj.className;
    if (tmpClassName == "B") {
        tmpClassName = checked ? "B" : "";
    }
    else {
        tmpClassName = StrReplace(tmpClassName, " B", "") + (checked ? " B" : "");
    }

    SetClass(obj, tmpClassName);

    if (checked)
        ListMouseOut.call(obj);
}
function DoCheck(e, t, isSelectMore){
    e = e ? e : event;
    var obj = t ? t : (e.srcElement || e.target);
    var w = GetMainWin();
    if (!obj || !w)
        return;

    if (obj.className == "one" || obj.className == "all")
        CA(obj);

    SetListCheck(obj, null, true);

    //shift键 多选
    if ((e && e.shiftKey || isSelectMore) && w.gCurSelObj && w.gCurSelObj != obj && obj.checked == w.gCurSelObj.checked) {
        var s = w.GelTags("input");
        var c = 0;
        var l = s.length;
        for (var i = 0; i < l; i++) {
            if (s[i].type != "checkbox")
                continue;

            if ((s[i] == w.gCurSelObj || s[i] == obj) && c++ == 1)
                break;

            if (c == 1)
                SetListCheck(s[i], obj.checked);
        }
    }
    w.gCurSelObj = obj;
}
function CheckAll(CBName){
    var cbs = GelTags("input");
    for (var i = cbs.length - 1; i >= 0; i--) {
        if (cbs[i].name == CBName)
            SetListCheck(cbs[i]);
    }
}

function SelectAll(flag){
    var m_list_table = SW('list');
    var m_list_checkbox = GelTags("input", m_list_table);
    for (var i = m_list_checkbox.length - 1; i >= 0; i--) {
        m_list_checkbox[i].checked = flag;
    }
}

function SH_SelectOne(){
    var obj = window.event.srcElement;
    if (obj.checked == false) {
        S('chkall').checked = obj.chcked;
    }
}

//列表鼠标事件
function ListMouseMove(){
    if (this.className.indexOf(" B") == -1 && this.style.backgroundColor != "#f3f3f3")
        this.style.backgroundColor = "#f3f3f3";
}
function ListMouseOut(){
    if (this.style.backgroundColor != "")
        this.style.backgroundColor = "";
}

//email
function isEmail(s){
    if (s.length > 100 || s.length == 0) return false;
    if (s.indexOf("'") != -1 || s.indexOf("/") != -1 || s.indexOf("\\") != -1 || s.indexOf("<") != -1 || s.indexOf(">") != -1)
        return false;
    if (s.indexOf(" ") > -1 || s.indexOf("　") > -1) {
        return false;
    }
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
        if (mail_array[part_num].search(re) == -1) { isemail = false; }
        part_num += 1;
    }
    return isemail;
}

//checkbox 是否选中
function checkboxIsChecked(){
    var checked = false;
    var elements = GelTags("input");

    for (var i = 0; i < elements.length; i++) {
        if (elements[i].type == "checkbox") {
            if (elements[i].checked == true) {
                checked = true;
                break;
            }
        }
    }

    return checked;
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

//FireBug 控制台记录日志代码
var G_Log_Content = "";
function log(a){
    if (GLOBALS_DEBUG == 0)
        return true;
    if (navigator.userAgent.indexOf("Firefox") > -1) {
        //Firefox 下面使用其控制台
        console.log(a);
    }
    else {
        //非 Firefox 浏览器使用 确认窗口 提示；
        if (G_Log_Content == "") {
            document.ondblclick = function (){ if (!confirm(G_Log_Content + "---\nkeep it?")) G_Log_Content = "\n"; };
        }
    }
    if (a == "-")
        G_Log_Content = "\n";
    else
        G_Log_Content += a + "\n";
};

// 根据标题排序
function OrderBy(filed){
    var url = location.href;
    var value = "orderfield=" + filed;
    url = SetUrlParam(url, value);
    var orderType = GetRequest("ordertype", "");
    if (orderType == "") {
        orderType = "0";
    }
    else {
        if (orderType == "0") {
            orderType = "1";
        }
        else {
            orderType = "0";
        }
    }
    value = "ordertype=" + orderType;
    url = SetUrlParam(url, value);
    location.href = url;
}

/********************************************************************/
//为url添加参数，自动判断是更新还是添加
//参数格式：如：page=1的形式，不能是“page=1&params=1”的形式，即一次只能添加一个参数
/********************************************************************/
function SetUrlParam(url, param){
    var interrogation = url.indexOf("?");

    if (interrogation == -1) {
        url += "?" + param;
    }
    else {
        //如果?后面有查询字符串,则检测有没有该字段，如果有，则重新付值
        var fp = param.split("=");
        var search = fp[0] + "=";
        var offset = url.indexOf(search);
        if (offset != -1) {
            offset += search.length;
            end = url.indexOf("&", offset);
            if (end == -1) {
                url = url.substring(0, offset) + fp[1];
            }
            else {
                url = url.substring(0, offset) + fp[1] + url.substring(end);
            }
        }
        else {
            url = url + "&" + param;
        }
    }
    return url;
}

/********************************************************************/
//获取url中一个指定的参数值
/********************************************************************/
function GetRequest(paramName, defaultValue){
    var search = paramName + "=";
    var FieldValue = "";
    var URL = location.href;
    var offset = URL.indexOf(search);
    if (offset != -1) {
        offset += search.length;
        var end = URL.indexOf("&", offset);
        if (end == -1) {
            FieldValue = URL.substring(offset);
        }
        else {
            FieldValue = URL.substring(offset, end);
        }
    }
    if (FieldValue == "") {
        FieldValue = defaultValue;
    }
    return FieldValue.toLowerCase();
}