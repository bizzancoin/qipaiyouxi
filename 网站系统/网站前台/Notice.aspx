<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notice.aspx.cs" Inherits="Game.Web.Notice" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title></title>
<link href="/css/base.css" rel="stylesheet" type="text/css" />
<link href="/css/common.css" rel="stylesheet" type="text/css" />
<style>
   html, body { overflow: hidden; }
  .ui-news-list {padding: 5px 5px 99999px; background: #18142f; width: 186px;}
  .ui-system-panel {
    font-size: 12px; line-height: 20px; background: url("/images/news_list.png") left center no-repeat;
    padding-left: 8px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; width: 178px;
  }
  .ui-system-panel a {color: #d0a663;}
  .ui-system-panel a:hover {color: #fc0; text-decoration: underline;}
  .ui-system-panel a.ui-news-hot {color: #f00;}
</style>
</head>
<body>
    <ul class="ui-news-list">
        <asp:Repeater ID="rptNotice" runat="server">
            <ItemTemplate>
                <li class="ui-system-panel">
                    <a <%# Container.ItemIndex==0?"class=\"ui-news-hot\"":"" %> href='/News/NewsView.aspx?param=<%# Eval("NewsID") %>'target="_blank"><%# Eval("Subject")%></a>
                </li>
            </ItemTemplate>
        </asp:Repeater>
    </ul>
</body>
</html>
