<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Buy.aspx.cs" Inherits="Game.Web.Shop.Buy" %>
<%@ Register TagPrefix="qp" TagName="Header" Src="~/Themes/Standard/Common_Header.ascx" %>
<%@ Register TagPrefix="qp" TagName="Footer" Src="~/Themes/Standard/Common_Footer.ascx" %>
<%@ Register TagPrefix="qp" TagName="ShopSidebar" Src="~/Themes/Standard/Shop_Sidebar.ascx" %>
<%@ Register TagPrefix="qp" TagName="Download" Src="~/Themes/Standard/Common_Download.ascx" %>
<%@ Register TagPrefix="qp" TagName="Speedy" Src="~/Themes/Standard/Common_Speedy.ascx" %>
<%@ Register TagPrefix="qp" TagName="ShopTop" Src="~/Themes/Standard/Shop_Top.ascx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/shop/shop-exchange.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.min.js"></script>
    <script src="/js/utils.js" type="text/javascript"></script>
</head>
<body>
    <!--头部开始-->
    <qp:Header ID="sHeader" runat="server" PageID="7"/>
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
          <span>游戏商城</span>
          <i class="ui-page-title-current"></i>
          <span><%= pageName%></span>
          <div class="ui-page-title-right"><span>GAME&nbsp;SHOP</span><strong>游戏商城</strong></div>
        </div>
        <div class="fn-clear">
          <div class="ui-main-speedy fn-left">
            <!--商城左边开始-->
            <qp:ShopSidebar ID="sShopSidebar" runat="server" />
            <!--商城左边结束-->
            <!--游戏下载开始-->
            <qp:Download ID="sDownload" runat="server" />
            <!--游戏下载结束-->
            <!--快速通道开始-->
            <qp:Speedy ID="sSpeedy" runat="server" />
            <!--快速通道结束-->
          </div>
          <div class="ui-main-details fn-right">
            <!--商城用户登录开始-->
            <qp:ShopTop ID="sShopTop" runat="server" />
            <!--商城用户登录结束-->
            <form id="form" action="/WS/Shop.ashx?action=buyaward&TypeID=0" method="post" onsubmit="return false;">
              <div class="ui-goods-info">
                <table>
                  <thead>
                    <tr>
                      <th>商品信息</th>
                      <th>商品价格[元宝]</th>
                      <th>数量</th>
                      <th>总额</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><img src="<%= smallImage %>"/><%= awardName%></td>
                      <td><%= price %></td>
                      <td>
                        <a href="javascript:;"><img id="minus" src="/images/minus.png"/></a>
                        <input id="quantity" name="counts" type="text" value="1" class="ui-text-3"/>
                        <a href="javascript:;"><img id="plus" src="/images/add.png"/></a>
                      </td>
                      <td id="total-price" data-price="<%= price %>"><%= price %></td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div class="ui-exchange-info">
                <h2 class="ui-title-solid">订单信息</h2>
                <ul>
                  <li runat="server" id="divRealName" visible="false">
                    <label>收货人姓名：</label>
                    <input id="consignee" class="ui-text-1" type="text" name="name" value="<%= realName%>" placeholder="请输入收货人姓名"/>
                  </li>
                  <li runat="server" id="divPhone" visible="false">
                    <label>手机号码：</label>
                    <input id="mobile" class="ui-text-1" type="text" name="phone" value="<%= phone%>" placeholder="输入手机号码"/>
                  </li>
                  <li runat="server" id="divQQ" visible="false">
                    <label>QQ/微信：</label>
                    <input id="qq" class="ui-text-1" type="text" name="qq" placeholder="输入QQ号码"/>
                  </li>
                  <div runat="server" id="divAddress" visible="false">
                  <li>
                    <label>个人所在地：</label>
                    <select id="province" name="province" data-selected="<%= province%>">
                        <option title="请选择" value="-1">请选择</option>
                    </select>
                    <span>省</span>
                    <select id="city" name="city" data-selected="<%= city%>">
                        <option title="请选择" value="-1">请选择</option>
                    </select>
                    <span>市</span>
                    <select id="area" name="area" data-selected="<%= area%>">
                        <option title="请选择" value="-1">请选择</option>
                    </select>
                    <span>区</span>
                  </li>
                  <li>
                    <label>详细地址：</label>
                    <input id="address" class="ui-text-2" type="text" name="address" value="<%= address %>" placeholder="请输入详细地址"/>
                  </li>
                  <li>
                    <label>邮编：</label>
                    <input id="zip-code" class="ui-text-1" type="text" name="postalCode" placeholder="输入邮编"/>
                  </li>
                  </div>
                  <li class="ui-shop-submit">
                    <input type="hidden" name="awardID" value="<%= IntParam %>" />
                    <input type="submit" value="提交订单" class="ui-btn-1"/>
                    <input type="button" value="重新选择" class="ui-btn-1" onclick="goURL('/Shop/Index.aspx');" />
                  </li>
                </ul>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!--尾部开始-->
    <qp:Footer ID="sFooter" runat="server" />
    <!--尾部结束-->
<script src="/js/jquery.min.js" type="text/javascript"></script>
<script src="/js/areacombox/es5-safe.js" type="text/javascript"></script>
<script src="/js/areacombox/area.js" type="text/javascript"></script>
<script src="/js/areacombox/areacombox.js" type="text/javascript"></script>
<script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
<script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
<script src="/js/view/shop/buy.js" type="text/javascript"></script>
</body>
</html>
