<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FaceList.aspx.cs" Inherits="Game.Web.FaceList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>图像列表</title>
    <script type="text/javascript">
        var api = frameElement.api;
        var W = api.opener;

        function PI(faceID,faceUrl) {
            W.document.getElementById('hfFaceID').value = faceID;
            W.document.getElementById('picFace').src = faceUrl;
            api.close();
        }
    </script>
    <style type="text/css">
     html,body{width:500px;padding:0;margin:0;}          
      .popping div{width:500px;float:left;padding:5px 0px 5px 10px;line-height:22px;background-color:#FFFFFF;border:none; font-size:12px;}
      .popping div img{width:48px;height:48px;border:0; }
      .popping div a{color:#004eff;margin:0 5px;line-height:8px;float:right;}
      .popping div a:hover{color:#FF0000;}
      .popping div b{width:300px;margin:0 0 0 10px;}
      .popping div i{float:left;}
      .popping div i a{float:left;border:2px solid #cccccc;margin:5px;}
      .popping div i a:hover{border:#2cc5fe 2px solid;padding:0;}
      .popping div i .faceHover {border:#FF0000 1px solid;padding:0;}
    </style>
</head>
<body>
    <input id="inFaceID" type="hidden" value="" />
    <input id="inFaceUrl" type="hidden" value="" />
    <div class="popping">
        <div>
            <span>
                <i>
                   <% for (int i = 0; i < 200; i++)
                       { %>
                    <a id="lnkFaceID<%=i %>" href="javascript:void(0);" onclick="javascript:PI(<%=i %>,'/gamepic/Avatar<%=i %>.png');" hidefocus="true"><img src="../gamepic/Avatar<%=i %>.png" alt='' /></a>
                    <% } %>
                </i>
            </span>
        </div>
    </div>
</body>
</html>
