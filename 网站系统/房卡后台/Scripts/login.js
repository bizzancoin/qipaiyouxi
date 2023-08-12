$(function () {
    $('#picVerifyCode').on('click', function () {
        $(this).attr("src", "/ValidateImage2.aspx?r=" + Math.random());
    });

    $('#txtAccounts, #txtPassword')
      .on('focus', function () {
          $(this)
            .closest('.ui-user-info')
            .addClass('focus');
      })
      .on('blur', function () {
          $(this)
           .closest('.ui-user-info')
           .removeClass('focus');
      });
})