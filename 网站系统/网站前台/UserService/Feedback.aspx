<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="Game.Web.UserService.Feedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <style>
      body {width: 456px; height: 470px; background: #251b14 url("/images/popup/feedback_bg.png") no-repeat;}
      form {padding: 13px 27px 0;}
      .ui-feedback-list {height: 268px; overflow: hidden;}
      .ui-feedback-list li {
        padding: 10px 1px 12px; width: 400px;
        background: url("/images/popup/feedback_line.png") bottom no-repeat;
      }
      .ui-feedback-list span {font-size: 12px; line-height: 20px; display: inline-block; *zoom: 1; *display: inline;}
      .ui-question, .ui-answer {font-size: 12px; line-height: 20px;}
      .ui-sort {width: 60px; vertical-align: top;}
      .ui-sort-detail {width: 340px;}
      .ui-gray {color: #875d38;}
      .ui-orange {color: #f60;}
      .ui-white {color: #fc9;}
      .ui-paging {text-align: center; line-height: 48px;}
      .ui-paging span {font-size: 12px; display: inline-block; *zoom: 1; *display: inline;}
      span.ui-prev, span.ui-next {font-size: 0; vertical-align: middle;}
      span.ui-prev {margin-right: 40px;}
      span.ui-next {margin-left: 40px;}
      span.ui-prev a,
      span.ui-next a {
        font-size: 0; display: inline-block; *zoom: 1; *display: inline; width: 11px; height: 19px;
        background: url("/images/popup/feedback_paging.png") no-repeat;
      }
      span.ui-prev a { background-position: -33px 0;}
      span.ui-next a { background-position: -22px 0;}
      span.ui-prev a.ui-no-next {background-position: 0 0; cursor: default;}
      span.ui-next a.ui-no-next {background-position: -11px 0; cursor: default;}
      .ui-write {font-size: 12px; height: 74px; position: relative;}
      .ui-write-tips {position: absolute; top:-20px; right: 0; font-size: 12px;}
      .ui-write textarea {
        width: 382px; height: 54px; padding: 9px; border: 1px solid; background: #2b190e; resize: none;
        border-color: rgba(99, 63, 38, 0.6) rgba(168, 153, 143, 0.3) rgba(168, 153, 143, 0.3) rgba(99, 63, 38, 0.6);
        -webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; overflow-y: hidden;
      }
      .ui-feedback-btn {margin-top: 7px;}
      .ui-tips {font-size: 12px; line-height: 16px; color: #875d38; width: 174px; padding-left: 6px;}
      .ui-btn-box input {font-size: 0; border: none; width: 92px; height: 34px; cursor: pointer;}
      input.ui-submit {background: url("/images/popup/feedback_submit.png") no-repeat; margin-right: 5px;}
      input.ui-empty {background: url("/images/popup/feedback_empty.png") no-repeat;}
    </style>
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script type="text/javascript">
        function checkInput() {
            if ($.trim($("#txtContent").val()) == "") {
                msgBox("请输入内容！");
                $("#txtContent").focus();
                return false;
            }
            if ($("#txtContent").val().length > 4000) {
                msgBox("内容长度不能超过80个字符！");
                return false;
            }
        }

        jQuery(document).ready(function () {
            document.getElementById('txtContent').onkeydown = function () { if (this.value.length >= 80 && event.keyCode != 8) event.returnValue = false; }
        });
    </script>    
</head>
<body>
    <form id="form1" runat="server">
    <div class="ui-feedback-box">        
        <ul class="ui-feedback-list">
            <li runat="server" id="litMessage" class="ui-orange">您暂未提交任何反馈信息</li>
            <asp:Repeater ID="rptFeedBackList" runat="server">
                <ItemTemplate>
                    <li>
                        <div class="ui-question"><span class="ui-sort ui-gray">我的提问：</span><span class="ui-sort-detail ui-orange"><%# Eval( "FeedbackContent" ).ToString()%></span></div>
                        <div class="ui-answer"><span class="ui-sort ui-gray">客服回答：</span><span class="ui-sort-detail <%#string.IsNullOrEmpty( Eval("RevertContent").ToString())?"ui-gray":"ui-white" %>"><%#string.IsNullOrEmpty( Eval("RevertContent").ToString())?"暂无答复……": Eval("RevertContent") %></span></div>
                    </li>
                </ItemTemplate>
            </asp:Repeater>          
        </ul>
        <div style="display:none;">
            <webdiyer:AspNetPager ID="anpPage" runat="server" AlwaysShow="true" FirstPageText="首页" FirstLastButtonClass="ui-news-paging-prev" NextPrevButtonClass="ui-news-paging-prev"  
                LastPageText="末页" PageSize="3" NextPageText="下一页&nbsp;>" PrevPageText="<&nbsp;上一页" ShowBoxThreshold="0" 
                LayoutType="Table" NumericButtonCount="5" CustomInfoHTML="共 %PageCount% 页" ShowPageIndexBox="Never"
                UrlPaging="true" ShowCustomInfoSection="Never" CurrentPageButtonClass="null">
            </webdiyer:AspNetPager>
        </div>
        <div class="ui-paging">
          <span class="ui-prev"><a href="javascript:;" runat="server" id="preLink"></a></span>
          <%= pageInfo %>
          <span class="ui-next"><a href="javascript:;" runat="server" id="nextLink"></a></span>
        </div>
        <div class="ui-write">
          <asp:TextBox ID="txtContent" runat="server" CssClass="ui-orange" TextMode="MultiLine"></asp:TextBox>
          <div class="ui-write-tips ui-orange">（可输入80字）</div>
        </div>
        <div class="ui-feedback-btn fn-clear">
          <div class="ui-tips fn-left">客服将会在24小时日内反馈玩家的意见或建议，请您耐心等待。</div>
          <div class="ui-btn-box fn-right">
            <asp:Button ID="btnPublish" runat="server" Text="提交" OnClientClick="return checkInput()" CssClass="ui-submit" OnClick="btnPublish_Click" /><!--
            --><input type="reset" value="清空" class="ui-empty"/>
          </div>
        </div>
      </div>
    </form>
</body>
</html>
