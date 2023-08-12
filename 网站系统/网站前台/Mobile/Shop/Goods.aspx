<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Goods.aspx.cs" Inherits="Game.Web.Mobile.Shop.Goods" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/base.css">
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/shop/goods.css">
</head>
<body>
    <div class="ui-content">
        <ul class="ui-goods-list fn-clear">
            <asp:Repeater ID="rptData" runat="server">
                <ItemTemplate>
                    <li>
                        <div class="ui-goods-showcase">
                            <span><%# Eval("AwardName") %></span>
                            <div class="ui-goods-pic">
                               <a href="Buy.aspx?param=<%# Eval("AwardID") %>">
                                  <img src="<%# Game.Facade.Fetch.GetUploadFileUrl(Eval("SmallImage").ToString())%>">
                               </a>
                            </div>
                            <p>
                               <i></i> <img src="../Image/2.png" /><span><%# Eval("Price") %></span>
                            </p>
                        </div>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
    </div>
</body>
</html>
