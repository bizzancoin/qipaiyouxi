<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Game.Web.ads.Contact" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
    <title>联系客服</title>
    <link href="/css/base.css" rel="stylesheet" type="text/css" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <style>
        body {
            width: 456px;
            height: 270px;
            background: #251b14 url("/images/popup/contact_bg.png") no-repeat;
        }

        .ui-contact {
            padding: 5px;
        }

        .ui-contact-us {
            margin-left: 38px;
        }

        .ui-contact-qq {
            margin-top: 34px;
        }

            .ui-contact-qq a {
                font-size: 0;
                display: block;
                width: 196px;
                height: 76px;
                background: url("/images/popup/contact_qq.png") no-repeat;
            }

                .ui-contact-qq a:hover {
                    background-position: 0 -76px;
                }

        .ui-hotline {
            font-size: 0;
            margin-top: 36px;
        }

        .ui-contact-way {
            width: 156px;
            height: 260px;
            padding-left: 23px;
            background: url("/images/popup/contact_line.png") left center no-repeat;
        }

            .ui-contact-way h3 {
                font-size: 14px;
                line-height: 20px;
                color: #fc9;
                margin: 60px 0 16px;
            }

            .ui-contact-way p,
            .ui-contact-way p > a {
                font-size: 13px;
                line-height: 20px;
                color: #fc9;
                word-break:break-all;
            }

                .ui-contact-way p > a:hover {
                    color: #fc0;
                }

                .ui-contact-way p > span {
                    color: #875d38;
                }
      .ui-hot-num{
        font-size: 24px;
        color: #fc9;
      }
    </style>
</head>
<body>
    <div class="ui-contact fn-clear">
        <div class="ui-contact-us fn-left">
            <div class="ui-contact-qq">
                <a id="BizQQWPAInfo" href="Contact.html" target="_blank"></a>                
            </div>
            <div class="ui-hotline">
             <p> <img src="/images/popup/contact_phone.png" /></p>
              <p class="ui-hot-num"><%=phone %></p>
            </div>
        </div>
        <div class="ui-contact-way fn-right">
            <h3>其他联系方式:</h3>
            <p><span>传真:</span><br /><a href="javascript:;"><%=fax %></a></p>
            <p><span>邮件:</span><br /><a href="javascript:;"><%=email %></a></p>
        </div>
    </div>
</body>
</html>
