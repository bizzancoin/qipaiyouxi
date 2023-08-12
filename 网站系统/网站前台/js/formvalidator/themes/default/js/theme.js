var onShowHtml = '';
var onFocusHtml = '<div class="ui-fv-prompttip"><div class="ui-fv-arrow"></div><div class="ui-fv-message"><i class="icon"></i><span>$data$</span></div></div>';
var onErrorHtml = '<div class="ui-fv-errortip"><div class="ui-fv-errmsg"><i class="icon"></i><span>$data$</span></div></div>';
var onCorrectHtml = '<div class="ui-fv-successtip"><div class="ui-fv-okmsg"><i class="icon"></i><span>$data$</span></div></div>';
var onShowClass = "ui-fv-input";
var onFocusClass = "ui-fv-focus";
var onErrorClass = "ui-fv-error";
var onCorrectClass = "ui-fv-input";
var onMouseOutFixTextHtml = '';
var onMouseOnFixTextHtml = '';

//初始状态，加其它几种状态
var passwordStrengthStatusHtml = [
    '<div class="ui-fv-prompt"><div class="ui-fv-arrow"></div><div class="ui-fv-message"><p id="pass-strong" class="psw-state">强度：<em class="st1">弱</em><b class="progress-image prog0"></b><em class="st2">强</em></p>6~16个字符，包括字母、数字、特殊符号，区分大小写</div></div>',
    '<div class="ui-fv-prompt"><div class="ui-fv-arrow"></div><div class="ui-fv-message"><p id="pass-strong" class="psw-state">强度：<em class="st1">弱</em><b class="progress-image prog1"></b><em class="st2">强</em></p>6~16个字符，包括字母、数字、特殊符号，区分大小写</div></div>',
    '<div class="ui-fv-prompt"><div class="ui-fv-arrow"></div><div class="ui-fv-message"><p id="pass-strong" class="psw-state">强度：<em class="st1">弱</em><b class="progress-image prog2"></b><em class="st2">强</em></p>6~16个字符，包括字母、数字、特殊符号，区分大小写</div></div>',
    '<div class="ui-fv-prompt"><div class="ui-fv-arrow"></div><div class="ui-fv-message"><p id="pass-strong" class="psw-state">强度：<em class="st1">弱</em><b class="progress-image prog3"></b><em class="st2">强</em></p>6~16个字符，包括字母、数字、特殊符号，区分大小写</div></div>'
];

var passwordStrengthText = ['密码强度：弱', '密码强度：中', '密码强度：强'];
//密码强度校验规则(flag=1(数字)+2(小写)+4(大写)+8(特殊字符)的组合，value里的0表示跟密码一样长,1表示起码1个长度)
var passwordStrengthRule = [
    {
        level: 1,
        rule: [
            {flag: 1, value: [0]},  //数字
            {flag: 2, value: [0]},  //小写字符
            {flag: 4, value: [0]}  //大写字符
        ]
    },
    {
        level: 2,
        rule: [
            {flag: 8, value: [0]},  //特符
            {flag: 9, value: [1, 1]},  //数字(>=1)+特符>=1)
            {flag: 10, value: [1, 1]},  //小写(>=1)+特符>=1)
            {flag: 12, value: [1, 1]},  //大写(>=1)+特符>=1)
            {flag: 3, value: [1, 1]},  //数字(>=1)+小写(>=1)
            {flag: 5, value: [1, 1]},  //数字(>=1)+大写(>=1)
            {flag: 6, value: [1, 1]}  //小写(>=1)+大写(>=1)
        ]
    },
    {
        level: 3,
        rule: [
            {flag: 11, value: [1, 1, 1]},  //数字(>=1)+小写(>=1)+特符(>=1)
            {flag: 13, value: [1, 1, 1]},  //数字(>=1)+大写(>=1)+特符(>=1)
            {flag: 14, value: [1, 1, 1]},  //小写(>=1)+大写(>=1)+特符(>=1)
            {flag: 7, value: [1, 1, 1]}  //数字(>=1)+小写(>=1)+大写(>=1)
        ]
    }
];