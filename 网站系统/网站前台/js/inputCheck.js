/*验证是否为空*/
function isNotEmpty(obj){
	if(arguments.length == 1) 
		msg = "必填项不能为空！";
	else
		msg=arguments[1];
	if(obj.value == ""){
		alert(msg);
		obj.focus();
		return false;
	}
	else
		return true;
}
/*验证是否为空,不获得焦点*/
function isNotEmpty2(obj,isAlertMsg){
	if(arguments.length == 1) 
		msg = "必填项不能为空！";
	else
		msg=arguments[1];
	if(obj.value == ""){
		if (isAlertMsg) {
			alert(msg);
		}
		return false;
	}
	else
		return true;
}
/*验证是否为空,不提示错误*/
function isNullOrEmpty(obj){		
	if(obj.value == ""||obj.value.trim()==""){
		return false;
	}
	else
		return true;
}
/*验证obj1,obj2两项输入是否一致*/
function isSame(obj1,obj2,isAlertMsg){
	if(arguments.length == 3)
		msg = "两次输入的密码不一致！";
	else
		msg = arguments[2];
	var strPass1=obj1.value.trim();
	var strPass2=obj2.value.trim();
	if(strPass1 != strPass2){
		if(isAlertMsg == 1){
			alert(msg);
		}
		
		return false;
	}
	else
		return true;
}
/*验证密码长度是否在6到16位之间*/
function isPassLen(obj,isAlertMsg){
	if(arguments.length == 2)
		msg = "密码长度不正确！";
	else
		msg = arguments[1];
	var strPass=obj.value.trim();
	if(strPass.length < 6 || strPass.length > 100){
		if(isAlertMsg == 1){
			alert(msg);
		}		
		return false;
	}
	else
		return true;
}

/*验证密码输入是否正确*/
function isPass(obj,isAlertMsg){
	if(arguments.length == 2)
		msg = "密码含有非法字符！";
	else
		msg = arguments[2];	
	var str = obj.value;
	var i,j,s;
	j = 0;
	s = " ";
	for(i = 0;i < str.length;i++){
		if(str.charCodeAt(i) < 32 || str.charCodeAt(i) > 126 || str.charCodeAt(i) == s.charCodeAt(0)){
			j = 1;
			break;
		}
	}	
	if(j == 0)
		return true;
	else
		if(isAlertMsg == 1){
			alert(msg);
		}
		
		return false;
}
/*验证Email输入是否正确*/
function isEmail(obj){	
	var re = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
	if(!re.test(obj.value)){		
		return false;
	}
	else
		return true;
}

/*验证电话号码输入是否正确*/
function isPhone(obj){
	if(arguments.length == 1)
		msg = "电话号码格式不正确！";
	else
		msg = arguments[1];
	var re = /(^[0-9]{3,4}-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^([0-9]{3,4})[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/;
	if(!re.test(obj.value)){
		alert(msg);
		obj.select();
		return false;
	}
	else
		return true;
}

/*验证手机号码输入是否正确*/
function isMobile(obj){
alert(arguments.length);
	if(arguments.length == 1)
		msg = "手机号码格式不正确！";
	else
		msg = arguments[1];
	var reg = /^((\(\d{2,3}\))|(\d{3}\-))?((13\d{9})|(15[389]\d{8})|(18\d{9}))$/;
	var result = false;
    if(reg.test(obj.value))
        result = true;
	if(!result){
		alert(msg);
		obj.select();
		return false;
	}else
		return true;
		
}

/*验证身份证号码*/
function isIDCard(obj){	
	var re = /^\d{15}(\d{2}[0-9Xx])?$/;
	if(!re.test(obj.value)){		
		return false;
	}
	else
		return true;	
}	

/*验证下拉列表是否选择*/
function isSelected(obj){
	if(arguments.length == 1)
		msg = "请选择!";
	else
		msg = arguments[1];
	if(obj.selectedIndex == 0){
		alert(msg);
		return false;
	}
	else
		return true;
}
/*验证输入是否为中文*/
function isChinese(obj){
	if(arguments.length == 1)
		msg = "只能输入中文！";
	else
		msg = arguments[1];
	var re = /[^\u4E00-\u9FA5]/g;
	if(re.test(obj.value)){
		alert(msg);
		obj.select();
		return false;
	}
	else
		return true;
}
/*验证输入是否为英语字母*/
function isEnglish(obj){
	if(arguments.length == 1)
		msg ="只能输入英语字母！";
	else
		msg = arguments[1];
	var re = /[^a-zA-Z]/;
	if(re.test(obj.value)){
		alert(msg);
		obj.select();
		return false;
	}
	else
		return true;
}
/*验证输入是否为数字*/
function isNumber(obj,hitmsg,isAlertMsg){
	if(arguments.length == 1)
		msg = "只能输入数字！";
	else
		msg = arguments[1];
	var re = /\D/;
	if(re.test(obj.value)){
		if (isAlertMsg) {
			alert(msg);			
		}
		return false;
	}
	else
		return true;
}
/*验证输入是否为英语字母和数字*/
function isEN(obj,msg){
	var reg=/^[a-z0-9.]*$/gi
	if(reg.test(obj.value))
		return true
	else{
		alert((msg?msg:'只能输入英语字母或数字！'));
		obj.select();
		return false;
	}
}

/*验证输入是否为字母、数字和下划线的组合*/
function isE_N_UL(obj,isAlertMsg){
	if(arguments.length == 2)
		msg = "只能输入字母、数字和下划线的组合！";
	else
		msg = arguments[2];	
	//var reg = /^([a-zA-Z]|\d|_)*$/;
	var reg = /^\w+$/;
	if(reg.test(obj.value))
		return true
	else{
		if(isAlertMsg == 1){
			alert(msg);
		}
		obj.select();
		return false;
	}
}

/*验证输入是否为字母、数字、下划线和汉字的组合*/
function isE_N_UL_CN(obj,isAlertMsg){
	if(arguments.length == 2)
		msg = "只能输入字母、数字、下划线和汉字的组合！";
	else
		msg = arguments[2];	
	var reg = /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/
	if(reg.test(obj.value))
		return true
	else{
		if(isAlertMsg == 1){
			alert(msg);
		}
		obj.select();
		return false;
	}
}

/*验证输入是否只包括字母，数字和下划线的组合*/
function isE_N_UL2(obj) {
    if (obj.length == 0) 
        return false;
	var reg="^(([a-zA-Z0-9]{1,15})([a-z0-9A-Z.@_-])*)$";
	var omatch=obj.match(reg);
	if (omatch != null)
		return true;
	
	return false;
}

/*验证输入是否为字母、数字、下划线和汉字的组合(汉字，字母,数字, 中横杠和下划线	)*/
function isE_N_UL_CN2(obj) {
	 //含有空格
	 if (obj.indexOf(" ")>-1 || obj.indexOf("　")>-1)  {
        return 1;
    }
	
	var reg = "([\u4E00-\u9FA5]{1,15}([a-z0-9A-Z@_-])*)";
	var omatch = obj.match(reg);
	//汉字
	if (omatch != null) {	    							   
		if (byteLength(obj)<3 || byteLength(obj)>30) {										
			//汉字位数不足
			return 2;    
		}
		else {
		    //汉字组合正确
			return 5;		
		}				  
	}
	else {
		if (isE_N_UL2(obj)) {
		    if (byteLength(obj)<2 || byteLength(obj)>15) {										
			    //位数不足
			    return 3; 
		    } 
		    else {
		        //字母组合正确
			    return 5;		
			    }
		    }
	}
	
	//未知状态
	return 7;
}

/*验证日期的合法性*/
function isDate(objyear,objmon,objday){
	var year = objyear.value;
	var mon = objmon.value;
	var day = objday.value;
	var count = -1;
	switch (mon)
	{
	case '1':
	case '3':
	case '5':
	case '7':
	case '8':
	case '10':
	case '12':
		count = 31;
		break;
	case '4':
	case '6':
	case '9':
	case '11':
		count = 30;
		break;
	case '2':
		if (year % 4 == 0)
			count = 29;
		else
			count = 28;
		if ((year % 100 == 0) & (year % 400 != 0))
			count = 28;
	}
	if (day > count){
		alert(year+"年"+mon+"月没有"+day+"号！");
		return false;
	}
	else
		return true;
}

/*得到字符长度*/
function getTrueLength(myStr){
	var i,trueLength,temp;
	trueLength = 0;
	for(i = 0;i < myStr.length;i++){
		temp = myStr.charCodeAt(i);
		if(temp>127){
			trueLength = trueLength + 2;
		}else if(temp == 60|| temp == 62){
			trueLength = trueLength + 4;
		}else if(temp == 39){
			trueLength = trueLength + 2;
		}else{
			trueLength = trueLength + 1;
		}
	}
	return trueLength;
}

/*验证是否有非法字符*/
function isLicitStr(obj){
	var filterStr = ";|'|&|%|--|==|<|>|*|(|)| create | select | count | insert | update | drop | from | declare | exec | char |xp_cmdshell| where | or | and | begin |truncate| union | join |script";
	var inputStr = obj.value;																																																 	inputStr = inputStr.toLowerCase()
	filterStrArr = filterStr.split("|")
	for(var i = 0; i < filterStrArr.length; i++){ 
		if(inputStr.indexOf(filterStrArr[i]) != -1){
			alert("输入数据中含有特殊字符："+filterStrArr[i]);
			return false;
		}
	}
	return true;
}
//检测url地址是否正确（http://www.）
function checkeURL(obj){
	if(arguments.length == 1)
		msg = "请输入正确的网址！";
	else
		msg = arguments[1];
	
	 //下面的代码中应用了转义字符"\"输出一个字符"/"
	var Expression = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/;
	var objExp=new RegExp(Expression);
	if(objExp.test(obj.value)){
		return true;
	}else{
		alert(msg);
		obj.select();
		return false;
	}
}
/*判断字符串是否超过默认长度*/
function isStrLen(obj,len){
	var str = obj.value;
	var nlen = 0;
	if(arguments.length == 2)
		msg = "输入的数据太长！";
	else
		msg = arguments[2];
	for(i = 0;i < str.length;i++){
		if(str.charCodeAt(i)>255)
			nlen = nlen + 2;
		else
			nlen = nlen + 1;
	}	   
	if(nlen > len){
		alert(msg);
		obj.select();
		return false;
	}else{
		return true;
	}
}
//检测IP地址
function isIP(obj) 
{ 
	str=obj.value;
	if(arguments.length == 1)
		msg = "请输入正确的IP地址！";
	else
		msg = arguments[1];
		
	var exp=/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/; 
	var reg = str.match(exp); 
	if(reg==null) 
	{ 
	  alert(msg);
	  obj.select();
	  return false;
	} 
	else 
	{ 
		return true;
	} 
} 
//检测身份证号码
function isIdCard(obj){
    card = obj.value;
    if (arguments.length == 1) 
        msg = "请填写正确的身份证号！";
    else 
        msg = arguments[1];
    
    var cardLen;
    var cardDate;
    var chkSex;
    cardLen = card.length;
    //长度
    if (cardLen != 15 && cardLen != 18) {       
        return false;
    }
    
    //验证是否为数字
    if (isNaN(card.substring(0, cardLen - 1))) {       
        return false;
    }
    else {
        chkSex = card.charAt(cardLen - 1);
    }
    
    //取生日
    if (18 == cardLen) {
        cardDate = card.substring(6, 14);
    }
    else {
        cardDate = card.substring(6, 12);
    }
    
    //判断最后一位
    
    if (cardLen == 15) {
        if (isNaN(chkSex)) {           
            return false;
        }
    }
    else {
        if (isNaN(chkSex)) {
            if (chkSex != "x" && chkSex != "X") {               
                return false;
            }
        }
    }
    return true;
}

//排除中文
function excludeCn(input)
{
	if(/[^\w\s\.\-\+\?\\\/\|\[\]\{\}\'\"\`\~\!\#\$\@\%\^\&\*\(\)\=\<\>\:\,;]/.test(input.value))
	{
		input.value=input.value.replace(/[^\w\s\.\-\+\?\\\/\|\[\]\{\}\'\"`~!@#$%^&*()=<>:,;]/g,'');
	}
}

/*计算包含汉字时的字串实际长度，其中一个汉字占两个字符*/
function byteLength(str){
	var length = 0;
	var charArray = str.split("");

	for (i = 0; i < charArray.length; i++){
		if (charArray[i].charCodeAt(0) < 299)
			length ++;
		else
			length += 2;
	}
	
	return length;
}