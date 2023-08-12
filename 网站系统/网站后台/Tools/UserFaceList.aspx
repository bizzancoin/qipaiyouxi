<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserFaceList.aspx.cs" Inherits="Game.Web.Tools.UserFaceList" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>无标题页</title>
   <script type="text/javascript">
       var api = frameElement.api;
       if (api != null) {
           var W = api.opener;
       }
       function PI(faceID, faceUrl, faceType) {
           var inFaceID = document.getElementById("inFaceID");
           var inFaceUrl = document.getElementById("inFaceUrl");
           var inFaceType = document.getElementById("inFaceType");

           if (inFaceID.value != "") {
               document.getElementById("lnkFaceID" + inFaceID.value).className = "";
           }

           inFaceID.value = faceID;
           inFaceUrl.value = faceUrl;
           inFaceType.value = faceType;
           save();
       }

       function save() {
           var faceID = document.getElementById("inFaceID").value;
           var faceUrl = document.getElementById("inFaceUrl").value;
           var faceType = document.getElementById("inFaceType").value;
           if (faceID == null || faceID == "") {
               api.cancel();
               return;
           }

           var srcFaceType = W.document.getElementById('faceType');
           var srcFaceID = W.document.getElementById('inFaceID');
           var srcFaceUrl = W.document.getElementById('picFace');
           if (srcFaceUrl != null) {
               if (srcFaceType != null) {
                   srcFaceType.value = faceType;
               }
               srcFaceID.value = faceID;
               srcFaceUrl.src = faceUrl;
           }
           api.close();
       }
    </script>
    <style type="text/css">
      html,body{width:500px;padding:0;margin:0;}          
      .popping div{width:500px;float:left;padding:5px 0px 5px 10px;line-height:22px;background-color:#FFFFFF;border:none; font-size:12px;}
      .popping div img{width:48px;height:48px;border:0; }
      .popping div a{color:#004eff;margin:0 5px;line-height:15px;float:right;}
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
    <input id="inFaceType" type="hidden" value="" />
    <div class="popping">
        <div id="divCustomFace" runat="server">
            <div style="height: 20px;">
                自定义头像：
            </div>
            <span><i>
                <asp:Repeater ID="rptCustom" runat="server">
                    <ItemTemplate>
                        <a href="javascript:PI('<%# Eval("ID")%>','/Tools/UserFace.ashx?customID=<%# Eval("ID")%>',2)" >
                            <img src="/Tools/UserFace.ashx?customID=<%# Eval("ID")%>" alt="" /></a>
                    </ItemTemplate>
                </asp:Repeater>
            </i></span>
        </div>
        <div>
            <div style="height: 20px;">
                系统头像：
            </div>
            <span><i>
                <%= systemFaceList %>
            </i></span>
        </div>
    </div>
</body>
</html>
