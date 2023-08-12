<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Common_Download.ascx.cs" Inherits="Game.Web.Themes.Standard.Common_Download" %>
<div class="ui-download">
    <h2 class="ui-title fn-clear"><a href="/Games/Index.aspx">详情></a>游戏下载</h2>
    <div class="ui-download-pc">
    <a href="/DownSimply.aspx" class="ui-download-pic-1"></a>
    <p>系统WinXP/Win2000/Vista/Win7/Win8</p>
    </div>
    <div class="ui-download-android">
    <a href="<%=androidDownloadURL %>" class="ui-download-pic-2"></a>
    <p>Android客户端</p>
    </div>
    <div class="ui-download-ios">
    <a href="<%=iosDownloadURL %>" class="ui-download-pic-3"></a>
    <p>iOS客户端</p>
    </div>
</div>