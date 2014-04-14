var UI = {

	// Методы для вывода сообщений на экран
	message: function(options){
		if(!options)
			return;
		if(typeof(options) != "object")
			return console.log('ERROR: метод `message` может принимать в качестве параметра только объект.'), false;

		var close = $('<i class="icon-close">×</i>');
		var container = $('<div class="pop-up-message" />');
		var text = $('<div/>').html(options.text);
		var id = 'popupmessage' + new Date().getTime();
		var veil;
		var display = {
			width: $('html').width(),
			height: $('html').height()
		};

		if(options.group){
			container.attr('group', options.group);
			this.closeMessages(options.group);
		}

		// Veil
		if(options.veil){
			veil = $('#veil');
			if(!veil.is('div')){
				veil = $('<div id="veil"/>');
				veil.appendTo('body');
			}
			veil.fadeIn(250);
			container.addClass('with-veil');
		}else
			container.removeClass('with-veil');

		container.attr('id', id);
		if(!options.noClose)
			close.appendTo(container);
		cose = container.find('i').first();
		container
			.css('position', 'absolute')
			.css('left', '-9999px');
		text.appendTo(container);
		container.appendTo('body');
		container.css('max-width', (display.width * .9) - 40);
		container.css('max-height', (display.height * .9) - 40);
		container
			.css('margin-left', '-' + ((container.width() + 40) / 2) + 'px')
			.css('margin-top', '-' + ((container.height() + 40) / 2) + 'px')
			.css('position', 'fixed')
			.css('left', '50%')
			.css('height', container.height())
			.hide()
			.fadeIn(200);

		close.click(function(){
				setTimeout('$("#' + id + '").remove()', 100);
				setTimeout('$("#veil").fadeOut(100)', 100);
			});

		if(!options.timer)
			options.timer = 5000;

//		if(options.veil)
//			setTimeout('$("#veil").fadeOut(250)', options.timer-100);
//		setTimeout('$("#'+id+'").fadeOut(100)', options.timer-100);
//		setTimeout('$("#'+id+'").remove()', options.timer);

        if(container.css('position') == 'absolute'){

            function updatePosotion(){
                var scrollTop = $(document).scrollTop();
                $("#veil").css('height', '50000px');
                container.css('top', 0);
                container.css('margin-top', (scrollTop + ((display.height / 2) - (container.height() / 2))) + 'px');
            }

            $(document).scroll(function(){
                updatePosotion();
    		});

    		updatePosotion();
        }
		

		return container;
	},

	updatePosotion: function(){
        ;
	},

	closeMessages: function(group){
		var messages;
		if(group)
			messages = $('.pop-up-message[group="'+group+'"]');
		else
			messages = $('.pop-up-message');

		messages.remove();
		$("#veil").hide();
	},

	// Возвращает целое
	intval: function(i){
		if(isNaN(parseInt(i)))
			return 0;
		else
			return parseInt(i);
	},
	
	ge: function(s){
		return document.getElementById(s);
	}
}