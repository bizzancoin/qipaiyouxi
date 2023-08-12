<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountAppeals.aspx.cs" Inherits="Game.Web.Member.AccountAppeals" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="UserSidebar" Src="~/Themes/Standard/User_Sidebar.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/member/member-complaint.css" rel="stylesheet" type="text/css" />
    <script src="/js/jquery.min.js" type="text/javascript"></script>
    <script src="/js/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="4"/>
    <!--头部结束-->
    <div class="ui-banner">
      <div class="ui-banner-bg-1"></div>
      <div class="ui-banner-bg-2"></div>
      <div class="ui-carousel-right">
        <div class="ui-carousel-left">
          <div class="ui-banner-img">
            <a href="javascript:;"><img src="/images/banner_2.png" /></a>
          </div>
        </div>
      </div>
    </div>

    <div class="ui-content">
      <div class="ui-main">
        <div class="ui-page-title fn-clear">
          <a href="/index.aspx"><i class="ui-page-title-home"></i>首页</a>
          <i class="ui-page-title-current"></i>
          <a href="index.aspx">个人中心</a>
          <i class="ui-page-title-current"></i>
          <span>帐号申述</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="6" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form class="ui-complaint" id="form" action="/WS/Account.ashx?action=accountreport" method="post">
              <div class="ui-complaint-email">
                <h2 class="ui-title-solid">申述结果接收邮箱</h2>
                <p><span>申述结果接收邮箱：</span><input id="email" type="text" name="reportEmail" class="ui-text-1" /></p>
              </div>
              <div class="ui-complaint-basic">
                <h2 class="ui-title-solid">基本资料</h2>
                <ul>
                  <li>
                    <label>申述帐号：</label>
                    <input id="txtUser" type="text" name="txtUser" class="ui-text-1" />
                  </li>
                  <li>
                    <label>帐号注册时间：</label>
                    <input id="regDate" type="text" name="regDate" class="ui-text-3" onfocus="WdatePicker({onpicked:function(){$(this).blur();},oncleared:function(){$(this).blur();},dateFmt:'yyyy-MM-dd',maxDate:'%y-%M-%d'})" />
                  </li>
                  <li>
                    <label>申述人真实姓名：</label>
                    <input id="realname" type="text" name="realName" class="ui-text-1" maxlength="32" />
                  </li>
                  <li>
                    <label>申述人身份证号：</label>
                    <input id="idcard" type="text" name="idCard" class="ui-text-1" maxlength="18" />
                  </li>
                  <li>
                    <label>移动电话：</label>
                    <input id="mobile" type="text" name="mobile" class="ui-text-1" maxlength="11" />
                  </li>
                </ul>
              </div>
              <div class="ui-complaint-history">
                <h2 class="ui-title-solid">历史资料</h2>
                <p>请填写你曾经用过的昵称，如果无法记清，请填写您认为最接近的。</p>
                <ul class="ui-game-info">
                  <li>
                    <label>历史昵称1：</label>
                    <input type="text" name="nicknameOne" class="ui-text-1" maxlength="32" />
                  </li>
                  <li>
                    <label>历史昵称2：</label>
                    <input type="text" name="nicknameTwo" class="ui-text-1" maxlength="32" />
                  </li>
                  <li>
                    <label>历史昵称3：</label>
                    <input type="text" name="nicknameThree" class="ui-text-1" maxlength="32" />
                  </li>
                  <li>
                    <label>历史密码1：</label>
                    <input type="password" name="passwordOne" class="ui-text-1" maxlength="32" />
                  </li>
                  <li>
                    <label>历史密码2：</label>
                    <input type="password" name="passwordTwo" class="ui-text-1" maxlength="32" />
                  </li>
                  <li>
                    <label>历史密码3：</label>
                    <input type="password" name="passwordThree" class="ui-text-1" maxlength="32" />
                  </li>
                </ul>
              </div>
              <div class="ui-complaint-passwordcard">
                <h2 class="ui-title-solid">密保资料</h2>
                <ul class="">
                  <li class="ui-li-bg">
                    <label>问题一：</label>
                    <select name="questionOne" class="ui-select-1">
                      <%= questionList%>
                    </select>
                  </li>
                  <li>
                    <label>密保答案：</label>
                    <input type="text" name="answerOne" class="ui-text-1" />
                  </li>
                  <li class="ui-li-bg">
                    <label>问题二：</label>
                    <select name="questionTwo" class="ui-select-1">
                      <%= questionList%>
                    </select>
                  </li>
                  <li>
                    <label>密保答案：</label>
                    <input type="text" name="answerTwo" class="ui-text-1" />
                  </li>
                  <li class="ui-li-bg">
                    <label>问题三：</label>
                    <select name="questionThree" class="ui-select-1">
                      <%= questionList%>
                    </select>
                  </li>
                  <li>
                    <label>密保答案：</label>
                    <input type="text" name="answerThree" class="ui-text-1" />
                  </li>
                </ul>
              </div>
              <div class="ui-complaint-other">
                <h2 class="ui-title-solid">补充资料</h2>
                <p><label>其他说明：</label><textarea id="supplement" name="suppInfo" class="ui-textarea" maxlength="500"></textarea></p>
              </div>
              <div class="ui-complaint-submit">
                <p><input type="submit" name="submit" value="提交资料" class="ui-btn-1" /></p>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
    <script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
    <script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
    <script src="/js/view/member/accountcomplaint.js" type="text/javascript"></script>
</body>
</html>
