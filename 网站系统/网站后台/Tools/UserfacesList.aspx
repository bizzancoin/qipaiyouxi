<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript">
        var api = frameElement.api;
        if (api != null) {
            var W = api.opener;
        }

        function PI(faceID, faceUrl) {
            var inFaceID = document.getElementById("inFaceID");
            var inFaceUrl=document.getElementById("inFaceUrl");

            if (inFaceID.value != "") {
                document.getElementById("lnkFaceID" + inFaceID.value).className = "";               
            }
            
            inFaceID.value = faceID;
            inFaceUrl.value = faceUrl;
            document.getElementById("lnkFaceID" + faceID).className = "faceHover";
            save();
        }

        function save() {
            var faceID = document.getElementById("inFaceID").value;
            var faceUrl = document.getElementById("inFaceUrl").value;

            if (faceID == null || faceID == "") {
                api.cancel();
                return;
            }
            
            var srcFaceID = W.document.getElementById('inFaceID')
            var srcFaceUrl = W.document.getElementById('picFace')
            if (srcFaceUrl != null) {
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
    <div class="popping">
        <div>
            <span>
                <i>
                    <% 
                        for (int i = 0; i < 200; i++)
                        {
                            Response.Write("<a id=\"lnkFaceID" + i + "\" href=\"javascript:void(0);\" onclick=\"javascript:PI(" + i + ",'/gamepic/Avatar" + i + ".png');\" hidefocus=\"true\"><img src=\"../gamepic/Avatar" + i + ".png\" alt='' /></a>"); 
                        }
                    %>
                </i>
            </span>
        </div>
    </div>
</body>
</html>
