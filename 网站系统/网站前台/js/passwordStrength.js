/**************************************************************
 * <p>网站JavaScript Document</p>
 *  @Author:Summer-1900
 *  @Desc: 密码强度检测
 **************************************************************/
 var PasswordStrength=function(txtPassword,strongRankLayout){
	this.minLength=6;
	this.selectedIndex = 0;
	this.pwdLevelClass = new Array("ui-id-safe0", "ui-id-safe1", "ui-id-safe2", "ui-id-safe3");
	this.txtPassword=txtPassword;
	this.strongRankLayout=strongRankLayout;
}
PasswordStrength.prototype.setMinLength = function(n){
	if(isNaN(n)){
		return ;
	}
	n = Number(n);
	if(n>1){
		this.minLength = n;
	}
}

PasswordStrength.prototype.displayLevel = function(level){
	this.selectedIndex = level;
	for (var i = this.pwdLevelClass.length - 1; i >= 0; i--){
		this.strongRankLayout.removeClass(this.pwdLevelClass[i]);		
	}    
	this.strongRankLayout.addClass(this.pwdLevelClass[this.selectedIndex]);
}

PasswordStrength.prototype.checkedStrong= function(s){
	if(s.length < this.minLength){		
		this.displayLevel(0);
		return;
	}
	var ls = -1;
	if (s.match(/[a-z]/ig)){
		ls++;
	}
	if (s.match(/[0-9]/ig)){
		ls++;
	}
 	if (s.match(/(.[^a-z0-9])/ig)){
		ls++;
	}
	if (s.length < 6 && ls > 0){
		ls--;
	}
	 switch(ls) { 
		 case 0:
			 this.displayLevel(1);
			 break;
		 case 1:
			 this.displayLevel(2);
			 break;
		 case 2:
			 this.displayLevel(3);
			 break;
		 default:
			 this.displayLevel(0);
	 }
}

/*
 * 安全级别绑定
 */
function strongRankBind(txtPassword,lblSafeRank){
	var ps=new PasswordStrength(txtPassword,lblSafeRank);
	txtPassword.bind(
		"keyup",function(e){
			ps.checkedStrong($.trim(txtPassword.val()));
		}
	);
}

/*
 * 初始强度样式 
 */
function initStrongRankStyle(lblSafeRank){
	var ps=new PasswordStrength("",lblSafeRank);
	ps.displayLevel(0);
}

