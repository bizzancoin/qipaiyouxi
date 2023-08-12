/**
 * Created by Administrator on 2014/7/3.
 */
$(function () {
    var oCounts = $('#count'),
        oTotal = $('#total-price'),
        price = oTotal.attr('data-price');

	AreaCombox();

	$('#minus').click(function () {
		if (oCounts.val().trim() == '1') return;
		oCounts.val(oCounts.val() - 1);
		oTotal.text(oCounts.val() * price);
	});

	$('#plus').click(function () {
		if (oCounts.val().trim() == '99') return;
		oCounts.val(parseInt(oCounts.val()) + 1);
		oTotal.text(oCounts.val() * price);
	});

	oCounts.keyup(function () {
		var val = $.trim(this.value);
		if (isNaN(val) || val === '0') {
			this.value = '1';
		}
		oTotal.text(this.value * price);
	});

	var form = $('#form');
	var msg = $('#span-message');
	$('#a-submit').click(function () {
		$.ajax({
			type: 'post',
			url: form.prop('action'),
			data: form.serialize()
		}).done(function (result) {
		    msg.html(result.msg);
		    if (result.data.valid) {
		        window.location.href = "ryweb://param:js";
		    }
		});
	});
});