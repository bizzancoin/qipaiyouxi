<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="Game.Web.Index" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="styles/layout.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="scripts/common.js"></script>
    <script type="text/javascript" src="scripts/comm.js"></script>
    <script type="text/javascript" src="scripts/jquery.js"></script>
    <title><%=SiteName%></title>
</head>
<body class="warper">
    <table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
        <tbody>
            <tr>
                <td class="topIndex">
                    <div class="logo left">
                        <img src="/Upload/Site/AdminLogo.png" /></div>
                    <div class="left hui f12 Tmg20 lh Lmg10">
                        <div>
                            欢迎您,<a class="f" href="javascript:openWindow('Module/BackManager/BaseUserUpdate.aspx?id=<%= userExt.UserID %>',500, 354)"
                                class="white12"><span class="cheng"><%= userExt.Username %></span></a>【<%= roleName%>】
                                | <a href="/Module/WebManager/FeedbackList.aspx" target="frm_main_content" class="f">您有未处理留言反馈： <span style="color:Red;" id="newMessage">0</span> 条</a>
                            | <a href="/Module/MallManager/MallOrderList.aspx" target="frm_main_content" class="f">您有新订单：  <span style="color:Red;" id="newOrder">0</span> 张</a>
                        </div>
                        <div>
                            <a href="Index.aspx" class="f">后台首页</a>
                            |
                            <a href="LoginOut.aspx" class="f">安全退出</a>
                            |
                            <span id="ipbind">
                                <%= userExt.IsBand == 1 ? "<a href='javascript:void(0);' onclick='BindIp(0);' class='f'>绑定IP</a>" : "<a href='javascript:void(0);' onclick='BindIp(1);' class='f'>取消绑定</a>"%>
                            </span>
                        </div>
                    </div>
                    <%--<div class="right hui f12 Tmg7 lh Rpd10" ><a href="#" class="f">后台首页</a> | <a href="#" class="f">前台首页</a> | <a href="#" class="f">论坛首页</a></div>--%>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="sidebar_a">
                        <iframe src="Left.aspx" frameborder="0" style="width: 173px; height: 100%; visibility: inherit"></iframe>
                    </div>
                    <div class="sidebar_b">
                        <iframe name="frm_main_content" id="frm_main_content" height="100%" src="right.aspx" frameborder="no" width="100%"></iframe>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
    <div id="msgBoxDIV" style="position: absolute; display:none; width: 100%; padding-top: 4px; height: 24px; top: 55px; text-align: center;"><span class="msg" id="spnTopMsg"></span></div>
</body>
</html>

<script type="text/javascript">
    $(document).ready(function() {
        //获取未处理留言和新的订单数
        window.GetNewMessageAndNewOrder = function() {
            $.ajax({
                url: "/Tools/Operating.ashx?action=GetNewMessageAndNewOrder",
                type: "get",
                dataType: 'json',
                success: function(result) {
                    if (result.data.valid) {
                        $("#newMessage").html(result.data.newMessage);
                        $("#newOrder").html(result.data.newOrder);
                    }
                }
            });
            setTimeout(GetNewMessageAndNewOrder, 1000 * 60 * 5);
        }
        GetNewMessageAndNewOrder();
    });

    //绑定IP
    function BindIp(id) {
        $.get(
        "/Tools/AdminHandler.ashx?action=bindip&isbind=" + id + "&x=" + Math.random(),
        function(data) {
        if (data < 0) {
            alert("操作失败！");
        }
        $("#ipbind").html(data == 1 ? "<a href='javascript:void(0);' onclick='BindIp(0);' class='f'>绑定IP</a>" : "<a href='javascript:void(0);' onclick='BindIp(1);' class='f'>取消绑定</a>");
        }
        );
    }
</script>

