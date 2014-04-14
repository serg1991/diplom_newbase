function load() { 
     var hash = window.location.hash.substring(1);
     if (hash!="") {
     		var a = document.getElementsByTagName('a');
     		var parent = null;

			for (var idx= 0; idx < a.length; ++idx){
				if (a[idx].name==hash) {
    				parent = a[idx].parentNode;
    			}
			}
			
			var b = document.getElementsByTagName('body')[0].children;
			for (var idx= 0; idx < b.length; ++idx){
				if (b[idx] != parent) {
					b[idx].hidden=true;
				}
			}
     } 
     }