<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="Game.Web.Mobile.Feedback" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/base.css" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/feedback.css" />
</head>
<body>
    <main>
        <form class="ui-content" id="form1" runat="server" method="post" enctype="multipart/form-data">
            <div class="ui-feed-info">
              <%--<div class="ui-left-info">
                <div class="ui-input-box">
                <input type="file" name="add-img" id="ui-add-img" />
                <label for="ui-add-img"></label>
                </div>
                <p>添加图片</p>
              </div>--%>
                <div class="ui-right-content">
                    <textarea class="ui-right-details" title="建议" name="content" placeholder="欢迎您对我们的游戏提出宝贵意见，您的意见会让我们做的更好！"></textarea>
                </div>
                <div class="ui-tel-num">
                    客服电话：<%=contents %>
                </div>
                 <input type="submit" value="" id="ui-send" />
            </div>
        </form>
        <a href="Myfeedback.aspx" class="ui-my-feedback">我的反馈</a>
    </main>
</body>
</html>
