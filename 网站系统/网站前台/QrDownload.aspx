<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QrDownload.aspx.cs" Inherits="Game.Web.QrDownload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>手游下载</title>
    <link href="/css/base.css" rel="stylesheet" type="text/css"/>
    <style type="text/css">
      body {
        background-color: #231a11;
      }
      .ui-container {
        width: 367px; height: 351px;
        margin: 0 auto; padding: 15px;
        text-align: center;
        background: url(/images/qrcode_download_bg.png) no-repeat center;
      }
      .ui-title {
        font-size: 16px; font-weight: bold; height: 40px; line-height: 40px;
      }
      .ui-qrcode {
        width: 125px; height: 125px;
        margin: 18px auto 0; padding: 8px;
        border: 1px solid #ad8b54;
      }
      .ui-qrcode {
        width: 125px; height: 125px;
      }
      .ui-game-info {
        display: inline-block;
        *display: inline; *zoom: 1;
        text-align: left;
        margin: 35px auto 0;
      }
      .ui-game-info > p {
        height: 12px;
        font-size: 12px;
        line-height: 12px;
        color: #4f2f14;
      }
      .ui-game-info > p + p {
        margin: 8px 0;
      }
      .ui-notice {
        color: #4e2e13;
        font-size: 12px;
        height: 42px;
        line-height: 42px;
        margin: 12px auto 0;
      }
    </style>
</head>
<body>
    <div class="ui-container">
      <p class="ui-title">扫码下载</p>
      <div class="ui-qrcode">
        <img src="/WS/QRCode.ashx?qt=<%=downLoadUrl %>&qm=<%=gameIcoURL %>&qs=125" />
      </div>
      <p class="ui-notice">请用手机二维码扫描软件扫描下载</p>
    </div>
  </body>
</html>
