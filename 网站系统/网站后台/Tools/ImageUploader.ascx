<%@ Control Language="C#" Inherits="Game.Uploader.UploaderImage" %>
<asp:FileUpload runat="server" ID="fu" CssClass="test"/>
<asp:TextBox runat="server" ID="txtFilePath"></asp:TextBox>
<asp:Image ID="imgThumbnails" runat="server" ImageAlign="Middle"></asp:Image>
<asp:LinkButton ID="btnView" runat="server"></asp:LinkButton>
<asp:LinkButton ID="btnDelete" runat="server"></asp:LinkButton>
