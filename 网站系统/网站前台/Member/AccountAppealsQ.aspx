<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AccountAppealsQ.aspx.cs" Inherits="Game.Web.Member.AccountAppealsQ" %>
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
    <link href="/css/member/member-charm-inquire.css" rel="stylesheet" type="text/css" />
    <script src="/js/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function UpdateImage() {
            $("#picVerifyCode").attr("src", "/ValidateImage2.aspx?r=" + Math.random());
        }
    </script>
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
          <span>申述结果查询</span>
          <div class="ui-page-title-right"><span>MEMBER&nbsp;CENTER</span><strong>个人中心</strong></div>
        </div>
        <div class="fn-clear">
          <!--左边开始-->
          <qp:UserSidebar ID="sUserSidebar" runat="server" MemberID="32" />
          <!--左边结束-->
          <div class="ui-main-details fn-right">
            <form class="ui-complaint" name="form" id="form" action="/WS/Account.ashx?action=reportstate" method="post">
                <div class="ui-complaint-basic">
                    <h2 class="ui-title-solid">申诉进度查询</h2>
                    <ul>
                      <li>
                        <label>申述帐号：</label>
                        <input id="txtUser" type="text" name="account" class="ui-text-1" />
                      </li>
                      <li>
                        <label>申诉单号：</label>
                        <input id="reportNo" type="text" name="reportNo" class="ui-text-1" />
                      </li>
                      <li>
                        <label>验证码：</label>
                        <input id="captcha" type="text" name="code" class="ui-text-1" style="width:80px" />
                          <img src="/ValidateImage2.aspx" id="picVerifyCode" style="cursor:pointer;vertical-align:middle;" onclick="UpdateImage()" title="点击更换验证码图片!"/>
                                <a href="javascript:void(0)" onclick="UpdateImage()" class="ll" id="ImageCheck2">看不清楚？ 换一个</a>
                      </li> 
                      <li>
                          <label></label>
                          <input type="submit" name="submit" value="提交资料" class="ui-btn-1" >
                      </li>                     
                    </ul>
                </div>
                <div class="ui-deal-list">
                    <table cellspacing="0">
                        <thead>
                          <tr>
                            <th>申诉号</th>
                            <th>申诉帐号</th>
                            <th>申诉状态</th>                            
                          </tr>
                        </thead>
                        <tbody>
                            <tr class="ui-bg-color" id="result-info">

                            </tr>
                        </tbody>
                    </table>
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
<script src="/js/view/member/complaint-result.js" type="text/javascript"></script>
</body>
</html>
