var QuickUpload = function(file, options) {
//download by http://www.codefans.net	
	this.file = $$(file);
	
	this._sending = false;//是否正在上传
	this._timer = null;//定时器
	this._iframe = null;//iframe对象
	this._form = null;//form对象
	this._inputs = {};//input对象
	this._fFINISH = null;//完成执行函数
	
	$$.extend(this, this._setOptions(options));
};
QuickUpload._counter = 1;
QuickUpload.prototype = {
  //设置默认属性
  _setOptions: function(options) {
    this.options = {//默认值
		action:		"",//设置action
		timeout:	0,//设置超时(秒为单位)
		parameter:	{},//参数对象
		onReady:	function(){},//上传准备时执行
		onFinish:	function(){},//上传完成时执行
		onStop:		function(){},//上传停止时执行
		onTimeout:	function(){}//上传超时时执行
    };
    return $$.extend(this.options, options || {});
  },
  //上传文件
  upload: function() {
	//停止上一次上传
	this.stop();
	//没有文件返回
	if ( !this.file || !this.file.value ) return;
	//可能在onReady中修改相关属性所以放前面
	this.onReady();
	//设置iframe,form和表单控件
	this._setIframe();
	this._setForm();
	this._setInput();
	//设置超时
	if ( this.timeout > 0 ) {
		this._timer = setTimeout( $$F.bind(this._timeout, this), this.timeout * 1000 );
	}
	//开始上传
	this._form.submit();
	this._sending = true;
  },
  //设置iframe
  _setIframe: function() {
	if ( !this._iframe ) {
		//创建iframe
		var iframename = "QUICKUPLOAD_" + QuickUpload._counter++,
			iframe = document.createElement( $$B.ie ? "<iframe name=\"" + iframename + "\">" : "iframe");
		iframe.name = iframename;
		iframe.style.display = "none";
		//记录完成程序方便移除
		var finish = this._fFINISH = $$F.bind(this._finish, this);
		//iframe加载完后执行完成程序
		if ( $$B.ie ) {
			iframe.attachEvent( "onload", finish );
		} else {
			iframe.onload = $$B.opera ? function(){ this.onload = finish; } : finish;
		}
		//插入body
		var body = document.body; body.insertBefore( iframe, body.childNodes[0] );
		
		this._iframe = iframe;
	}
  },
  //设置form
  _setForm: function() {
	if ( !this._form ) {
		var form = document.createElement('form'), file = this.file;
		//设置属性
		$$.extend(form, {
			target: this._iframe.name, method: "post", encoding: "multipart/form-data"
		});
		//设置样式
		$$D.setStyle(form, {
			padding: 0, margin: 0, border: 0,
			backgroundColor: "transparent", display: "inline"
		});
		//提交前去掉form
		file.form && $$E.addEvent(file.form, "submit", $$F.bind(this.remove, this));
		//插入form
		file.parentNode.insertBefore(form, file).appendChild(file);
		
		this._form = form;
	}
	//action可能会修改
	this._form.action = this.action;
  },
  //设置input
  _setInput: function() {
	var form = this._form, oldInputs = this._inputs, newInputs = {}, name;
	//设置input
	for ( name in this.parameter ) {
		var input = form[name];
		if ( !input ) {
			//如果没有对应input新建一个
			input = document.createElement("input");
			input.name = name; input.type = "hidden";
			form.appendChild(input);
		}
		input.value = this.parameter[name];
		//记录当前input
		newInputs[name] = input;
		//删除已有记录
		delete oldInputs[name];
	}
	//移除无用input
	for ( name in oldInputs ) { form.removeChild( oldInputs[name] ); }
	//保存当前input
	this._inputs = newInputs;
  },
  //停止上传
  stop: function() {
	if ( this._sending ) {
		this._sending = false;
		clearTimeout(this._timer);
		//重置iframe
		if ( $$B.opera ) {//opera通过设置src会有问题
			this._removeIframe();
		} else {
			this._iframe.src = "";
		}
		this.onStop();
	}
  },
  //清除程序
  remove: function() {
	this._sending = false;
	clearTimeout(this._timer);
	//清除iframe
	if ( $$B.firefox ) {
		setTimeout($$F.bind(this._removeIframe, this), 0);
	} else {
		this._removeIframe();
	}
	//清除form
	this._removeForm();
	//清除dom关联
	this._inputs = this._fFINISH = this.file = null;
  },
  //清除iframe
  _removeIframe: function() {
	if ( this._iframe ) {
		var iframe = this._iframe;
		$$B.ie ? iframe.detachEvent( "onload", this._fFINISH ) : ( iframe.onload = null );
		document.body.removeChild(iframe); this._iframe = null;
	}
  },
  //清除form
  _removeForm: function() {
	if ( this._form ) {
		var form = this._form, parent = form.parentNode;
		if ( parent ) {
			parent.insertBefore(this.file, form); parent.removeChild(form);
		}
		this._form = this._inputs = null;
	}
  },
  //超时函数
  _timeout: function() {
	if ( this._sending ) { this._sending = false; this.stop(); this.onTimeout(); }
  },
  //完成函数
  _finish: function() {
	if ( this._sending ) { this._sending = false; this.onFinish(this._iframe); }
  }
}