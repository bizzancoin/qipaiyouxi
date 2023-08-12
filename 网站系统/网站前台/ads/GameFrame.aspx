<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GameFrame.aspx.cs" Inherits="Game.Web.ads.GameFrame" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link href="/ads/Images/ads.css" type="text/css" rel="Stylesheet" />
	<title></title>
</head>
<body style="background: #ed971c; text-align: center">
     <a href="<%= targetURL %>" target="_blank">
        <img src="<%= resourceURL %>" id="_pics" alt=""/>
    </a>
</body>
</html>
