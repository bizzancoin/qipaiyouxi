var regexEnum = {
    intege: "^-?[1-9]\\d*$",  //整数
    intege1: "^[1-9]\\d*$",  //正整数
    intege2: "^-[1-9]\\d*$",  //负整数
    num: "^([+-]?)\\d*\\.?\\d+$",  //数字
    num1: "^[1-9]\\d*|0$",  //正数（正整数 + 0）
    num2: "^-[1-9]\\d*|0$",  //负数（负整数 + 0）
    decmal: "^([+-]?)\\d*\\.\\d+$",  //浮点数
    decmal1: "^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*$",  //正浮点数
    decmal2: "^-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*)$",  //负浮点数
    decmal3: "^-?([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0)$",  //浮点数
    decmal4: "^[1-9]\\d*.\\d*|0.\\d*[1-9]\\d*|0?.0+|0$",  //非负浮点数（正浮点数 + 0）
    decmal5: "^(-([1-9]\\d*.\\d*|0.\\d*[1-9]\\d*))|0?.0+|0$",  //非正浮点数（负浮点数 + 0）
    email: "^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$",  //邮件
    color: "^[a-fA-F0-9]{6}$",  //颜色
    url: "^http[s]?:\\/\\/([\\w-]+\\.)+[\\w-]+([\\w-./?%&=]*)?$",  //url
    chinese: "^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$",  //仅中文
    ascii: "^[\\x00-\\xFF]+$",  //仅ACSII字符
    zipcode: "^\\d{6}$",  //邮编
    mobile: "^13[0-9]{9}|15[012356789][0-9]{8}|18[01256789][0-9]{8}|147[0-9]{8}$",  //手机
    ip4: "^(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|[0-1]\\d{2}|[1-9]?\\d)$", //ip地址
    notempty: "^\\S+$",  //非空
    picture: "(.*)\\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$",  //图片
    rar: "(.*)\\.(rar|zip|7zip|tgz)$",  //压缩文件
    date: "^\\d{4}(\\-|\\/|\\.)\\d{1,2}\\1\\d{1,2}$",  //日期
    qq: "^[1-9]*[1-9][0-9]*$",  //QQ号码
    tel: "^(([0\\+]\\d{2,3}-)?(0\\d{2,3})-)?(\\d{7,8})(-(\\d{3,}))?$",  //电话号码的函数(包括验证国内区号,国际区号,分机号)
    username: "^\\w+$",  //用来用户注册。匹配由数字、26个英文字母或者下划线组成的字符串
    letter: "^[A-Za-z]+$",  //字母
    letter_u: "^[A-Z]+$",  //大写字母
    letter_l: "^[a-z]+$",  //小写字母
    idcard: "^[1-9]([0-9]{14}|[0-9]{17})$" //身份证
};

Array.prototype.indexOf || (Array.prototype.indexOf = function (value, from) {
    var len = this.length >>> 0;

    from = Number(from) || 0;
    from = Math[from < 0 ? 'ceil' : 'floor'](from);
    if (from < 0) {
        from = Math.max(from + len, 0);
    }

    for (; from < len; from++) {
        if (from in this && this[from] === value) {
            return from;
        }
    }

    return -1;
});

function isCardID(sid){
    var sbirthday,
        date,
        isum = 0,
        province = [
            11, 12, 13, 14, 15, 21, 22,
            23, 31, 32, 33, 34, 35, 36,
            37, 41, 42, 43, 44, 45, 46,
            50, 51, 52, 53, 54, 61, 62,
            63, 64, 65, 71, 81, 82, 91
        ];

    if (!/^\d{17}(\d|x)$/i.test(sid) && !/^\d{15}$/i.test(sid))
        return '你输入的身份证长度或格式错误';

    sid = sid.replace(/x$/i, 'a');

    if (province.indexOf(parseInt(sid.substr(0, 2))) === -1)
        return '你的身份证地区非法';

    switch (sid.length) {
        case 15:
            sbirthday = '19' + sid.substr(6, 2) + '-' + Number(sid.substr(8, 2)) + '-' + Number(sid.substr(10, 2));
            date = new Date(sbirthday.replace(/-/g, '/'));
            if (sbirthday !== (date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()))
                return '身份证上的出生日期非法';
            break;
        case 18:
            sbirthday = sid.substr(6, 4) + '-' + Number(sid.substr(10, 2)) + '-' + Number(sid.substr(12, 2));
            date = new Date(sbirthday.replace(/-/g, '/'));

            if (sbirthday !== (date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate()))
                return '身份证上的出生日期非法';

            for (var i = 17; i >= 0; i--)
                isum += (Math.pow(2, i) % 11) * parseInt(sid.charAt(17 - i), 11);

            if (isum % 11 != 1)
                return '你输入的身份证号非法';
            break;
    }

    return true;
}

//短时间，形如 (13:04:06)
function isTime(str){
    var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/);
    if (a == null) return false;
    return !(a[1] > 24 || a[3] > 60 || a[4] > 60);
}

//短日期，形如 (2003-12-05)
function isDate(str){
    var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
    if (r == null) return false;
    var d = new Date(r[1], r[3] - 1, r[4]);
    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4]);
}

//长时间，形如 (2003-12-05 13:04:06)
function isDateTime(str){
    var reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/;
    var r = str.match(reg);
    if (r == null) return false;
    var d = new Date(r[1], r[3] - 1, r[4], r[5], r[6], r[7]);
    return (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4] && d.getHours() == r[5] && d.getMinutes() == r[6] && d.getSeconds() == r[7]);
}