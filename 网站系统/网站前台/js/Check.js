//短时间，形如 (13:04:06)
function isTime(str) 
{
    var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/);
    if (a == null) { return false }
    if (a[1] > 24 || a[3] > 60 || a[4] > 60) {
        return false;
    }
    return true;
}

//判断密码长度为6-16
function isPass(pass){
    if(pass.length<6||pass.length>16)
        return false;
    return true;
}

//短日期，形如 (2003-12-05)
function isDate(str) 
{
    var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
    if (r == null) return false;
    var d = new Date(r[1], r[3] - 1, r[4]);
    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4]);
}

//长时间，形如 (2003-12-05 13:04:06)
function isDateTime(str) 
{
    var reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
    var r = str.match(reg);
    if (r == null) return false;
    var d = new Date(r[1], r[3] - 1, r[4], r[5], r[6], r[7]);
    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4] && d.getHours() == r[5] && d.getMinutes() == r[6] && d.getSeconds() == r[7]);
}

//比较两个时间的大小
function compareDate(str1, str2) 
{
    var date1 = new Date(str1.replace(/\-/g, "\/"));
    var date2 = new Date(str2.replace(/\-/g, "\/"))
    if (date1 > date2) {
        return false;
    }
    else {
        return true;
    }
}

//判断给定的字符串是否是数值型
function IsNumeric(str) {
    var reg = /^[-]?[0-9]*[.]?[0-9]*$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    return true;
}

//判断给定的字符串是否是int类型
function IsPositiveInt(str) {
    var reg = /^\d+$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    else if (r > 2147483647) {
    return false;
    }    
    return true;
}

//判断给定的字符串是否是bigint类型
function IsPositiveInt64(str) {
    var reg = /^\d+$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    else if (r > 9223372036854775807) {
        return false;
    }
    return true;
}

//判断给定的字符串是否是汉字
function IsCnChar(str) {
    var reg = /^(?:[\u4e00-\u9fa5])+$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    return true;
}

//判断给定的字符串是否是email地址
function IsEmail(str) {
    var reg = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    return true;
}

//判断给定的字符串是否是电话号码
function IsPhoneCode(str) {
    var reg = /^(86)?(-)?(0\d{2,3})?(-)?(\d{7,8})(-)?(\d{3,5})?$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    return true;
}

//判断给定的字符串是否是手机号码
function IsMobileCode(str) {
    var reg = /^13|15\d{9}$/;
    var r = str.match(reg);
    if (r == null) {
        return false;
    }
    return true;
}