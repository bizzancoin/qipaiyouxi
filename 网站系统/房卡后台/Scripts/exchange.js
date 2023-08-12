$(function () {
    var reg = /^\d+$/;

    var gold = $('#getgold');
    var num;
    var rate = parseInt(gold.attr('data-rate'));

    $("input[type='text']").on('input', function () {
        num = $(this).val();
        if (reg.test(num)) {
            gold.html(rate * parseInt(num));
        } else {
            $(this).focus();
            $(this).val('');
            gold.html(0);
        }
    });
})