$(document).ready(function(){
	$('a[data-code]').click(function(){
		var that = $(this);
		var code = that.attr('data-code');
		var message = $('#' + code).html();

		UI.message({
			text: message,
			veil: true,
			timer: 300000
		});

		return false;
	});

});

if((navigator.userAgent.indexOf('iPhone') != -1) || (navigator.userAgent.indexOf('iPad') != -1))
    $('meta[name=viewport]').attr('content', '');