<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Buy.aspx.cs" Inherits="Game.Web.Mobile.Shop.Buy" %>
<!DOCTYPE html>
<html>
  <head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/mobile/base.css">
    <link type="text/css" rel="stylesheet" href="/Mobile/Css/shop/record.css">
  </head>
  <body>
    <main>
        <div class="ui-content fn-clean-space">
            <em></em>
          <div class="ui-left-content">
          <i></i>
          <div>
            <img src="<%= imgUrl %>">
            <p><%= name %></p>
            <p>元宝：<span><%= price %></span></p>
            </div>
          </div>
          <div class="ui-right-content">
              <div class="ui-notice-content">
                  <form id="form" action="/WS/Shop.ashx?action=buyaward&TypeID=1" method="post" onsubmit="return false;">
                    <p>
                    <span>兑换数量：</span>
                    <label for="count" class="ui-count-box">
                    <i></i>
                    <a class="ui-left-pic" id="minus" href="javascript:;">
                    <img src="/Mobile/Img/shop/minus.png">
                    </a>
                    <input type="text" id="count" name="counts" value="1" readonly>
                    <a class="ui-right-pic" id="plus" href="javascript:;">
                    <img src="/Mobile/Img/shop/plus.png">
                    </a>
                    </label>
                    <span class="ui-last">剩余<%= inventory %></span>
                    </p>
                    <p><span>所需元宝：</span><span data-price="<%= price %>" id="total-price" class="color-facc26"><%= price %></span><span>您的元宝剩余：</span><span class="color-facc26"><%= userMedals %></span> </p>
                    <p><span>收货人姓名：</span><input type="text" id="consignee" name="name" value="<%= realName %>"></p>
                    <p><span>手机号码：</span><input type="text" id="mobile" name="phone" value="<%= phone %>"></p>
                    <p class="ui-address-details">
                     <span>地址：</span><select id="province" name="province"></select><span>省</span><select id="city" name="city"></select><span>市</span><select id="area" name="area"></select><span>区</span></p>
                    <p><span>详细地址：</span><input type="text" id="address" name="address" value="<%= address %>"></p>
                    <div>
                        <button id="a-submit"><img src="/Mobile/Img/shop/submit-01.png"></button>
                        <input type="hidden" name="awardID" value="<%= IntParam %>" />
                        <p><span style="color: wheat;text-align: left; font-size:1rem;" id="span-message"></span></p>
                    </div>
                   </form>
                   <div class="ui-notice-return fn-hide">
                   <p>你的兑换申请已经提交，客服会尽快受理您的申请！</p>
                   <a href="javascript:;"><img src="/Mobile/Img/shop/notice-return.png"></a>
                    </div>
                  </div>
              </div>
            </div>
    </main>
<script src="/Mobile/Js/mobile/zepto/1.1.6/zepto.min.js" type="text/javascript"></script>
<script src="/js/jquery.min.js" type="text/javascript"></script>
<script src="/js/areacombox/es5-safe.js" type="text/javascript"></script>
<script src="/js/areacombox/area.js" type="text/javascript"></script>
<script src="/js/areacombox/areacombox.js" type="text/javascript"></script>
<script src="/js/formvalidator/formValidator.js" type="text/javascript"></script>
<script src="/js/formvalidator/formValidatorRegex.js" type="text/javascript"></script>
<script src="/Mobile/Js/shop/buy.js" type="text/javascript"></script>
  </body>
</html>