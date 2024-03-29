jQuery.cookie = function(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        // CAUTION: Needed to parenthesize options.path and options.domain
        // in the following expressions, otherwise they evaluate to undefined
        // in the packed version for some reason...
        var path = options.path ? '; path=' + (options.path) : '';
        var domain = options.domain ? '; domain=' + (options.domain) : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
};

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px");
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +  $(window).scrollLeft()) + "px");
    return this;
}

Array.prototype.avg = function(len) {
    var av = 0;
    var cnt = 0;
    //var len = this.length;
    for (var i = 0; i < len; i++) {
    var e = +this[i];
    if(!e && this[i] !== 0 && this[i] !== '0') e--;
        if (this[i] == e) {av += e; cnt++;}
    }
    return av/cnt;
}

//example.com?param1=name&param2=&id=6
//$.getURLParam('param1'); // name
//$.getURLParam('id');        // 6
//$.getURLParam('param2');   // null

$.getURLParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return results[1] || 0;
    }
}

function escapeVal(txt, replaceWith){
    txt = escape(txt);
    for (i=0; i<txt.length; i++){
	    if (txt.indexOf("%0D%0A") > -1) {
	        txt = txt.replace("%0D%0A", replaceWith);
	    } else if (txt.indexOf("%0A") > -1) {
	        txt = txt.replace("%0A", replaceWith);
	    } else if (txt.indexOf("%0D")> -1) {
	        txt = txt.replace("%0D", replaceWith);
	    }
    }
    return (unescape(txt));
}

// function unescapeVal(txt){
//     txt = escape(txt);
//     for (i=0; i<txt.length; i++){
//         if (txt.indexOf("<br />") > -1) {
//             txt = txt.replace("<br />", "%0D%0A");
//         } else if (txt.indexOf("<BR />") > -1) {
//             txt = txt.replace("<BR />", "%0D%0A");
//         } else if (txt.indexOf("<br/>") > -1) {
//             txt = txt.replace("<br/>", "%0D%0A");
//         } else if (txt.indexOf("<br>") > -1) {
//             txt = txt.replace("<br>", "%0D%0A");
//         } else if (txt.indexOf("<BR>") > -1) {
//             txt = txt.replace("<BR>", "%0D%0A");
//         }
//     }
// }

function signOutAdmin(){
    deleteAllCookies();
    window.location.href="index.html";
}


function deleteAllCookies() {
    var cookies = d.cookie.split(";");
    for (var i = 0; i < cookies.length; i++) {
        var cookie = cookies[i];
        var eqPos = cookie.indexOf("=");
        var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
        d.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
    }
}

function deleteDiv(divName){
    $('#'+divName).remove();
}

function cancelSubmit(){
    $('#DIV_FINAL').hide();
    $('#DIV_FINAL_CONTENT').html('');
    $('.backButton').show();
}

function closeModal(div){
    $('#'+div+'_content').html('');
    $('#'+div).hide();
}

function toggleSelection(item, stat){
    // alert(stat.checked);
    $('.'+item).each(function(){
        $(this).prop('checked', stat.checked);
    });
}

function createNewModalDiv(title, ID_NAME, width){
    // var ID_NAME = 'TEMP_OPENASSIGNMENTDETAILS';
    var div = '<div ID="'+ID_NAME+'" class="w3-modal" style="display: block; z-index: 5001;">';
    div += '<div class="w3-modal-content w3-card-4 w3-light-grey" style="width: '+width+'px; min-height: 300px;">';
    // div += '<div class="w3-modal-content w3-card-4  w3-light-grey" style="max-width: '+width+'px; min-height: 300px;">';
    div += '<div class="w3-container w3-top-bar" >';
    // div += '<h4 style="padding: 1px 30px 0px 2px;">'+title+'</h4>';
    div += '<h4 style="padding: 0px; margin: 0px; margin-right: 30px;">'+title+'</h4>';
    div += '<span onclick="$(\'#'+ID_NAME+'\').remove();" class="w3-button w3-display-topright w3-hover-red">X</span>';
    
    div += '</div>';
    div += '<div ID="x_modal_Content" style="margin-top: 8px; padding: 4px;" class="w3-white w3-border"></div>';
    div += '</div>';
    div += '</div>';
    $('html').prepend(div);
}