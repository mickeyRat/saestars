    var d=document;
    var sid = $.cookie('SID');
    var loading = '<center class="center-screen "><i class="fa fa-spinner fa-pulse fa-3x fa-fw"></i></br><span class="w3-xlarge sr-only">Loading...</span></center>';

$( d ).ready(function(){
    var url_string = window.location.href;
    var url        = new URL(url_string);
    var fileID     = url.searchParams.get("fileID");
    var vid        = url.searchParams.get("vid");
    if (vid){
        // viewAllFinalResults();
    } else {
        // viewPostResults(fileID);
        post_viewResults(fileID);
    }
});
function viewAllFinalResults(){
    var eventIDX = $.cookie('LOCATION');
    console.log('eventIDX='+eventIDX);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/post.pl',
        data: {'do':'viewAllFinalResults','act':'print','eventIDX':eventIDX},
        success: function(str){
            $('#main').html(str);
        }
    });
}
function post_viewResults(key) {
    var eventIDX = $.cookie('LOCATION');
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/post.pl',
        data: {'do':'post_viewResults','act':'print','eventIDX':eventIDX, 'key':key},
        success: function(str){
            $('#main').html(str);
        }
    }).done(function(){
        // console.log("Done");
        
        // sortTableByColumn(d.querySelector("table"),1);
        document.querySelectorAll(".table th").forEach(headerCell => {
            headerCell.addEventListener("click", () => {
                // const tableElement = headerCell.parentElement.parentElement.parentElement;
                const tableElement = headerCell.closest('.table');
                const headerIndex = Array.prototype.indexOf.call(headerCell.parentElement.children, headerCell);
                const currentIsAscending = headerCell.classList.contains("th-sort-asc");
                const dType = $(headerCell).data('type');
                // console.log($(headerCell).data('type'));
        
                sortTableByColumn(tableElement, headerIndex, dType, !currentIsAscending);
            });
        });
    });
}
function viewPostResults(fileID){
    var location = $.cookie('LOCATION');
    // console.log(fileID);
    $.ajax({
        type: 'POST',
        url: '../cgi-bin/post.pl',
        data: {'do':'viewPostResults','act':'print','fileID':fileID,'location':location},
        success: function(str){
            // console.log(str);
            $('#main').html(str);
        }
        // error: function(XMLHttpRequest, textStatus, errorThrown) { console.log(XMLHttpRequest); }
    }).done(function(){
        // console.log("Done");
        
        // sortTableByColumn(d.querySelector("table"),1);
        document.querySelectorAll(".table th").forEach(headerCell => {
            headerCell.addEventListener("click", () => {
                // const tableElement = headerCell.parentElement.parentElement.parentElement;
                const tableElement = headerCell.closest('.table');
                const headerIndex = Array.prototype.indexOf.call(headerCell.parentElement.children, headerCell);
                const currentIsAscending = headerCell.classList.contains("th-sort-asc");
                const dType = $(headerCell).data('type');
                // console.log($(headerCell).data('type'));
        
                sortTableByColumn(tableElement, headerIndex, dType, !currentIsAscending);
            });
        });
    });
}

function sae_toggleView(obj){
    $('.'+obj).toggleClass("w3-hide");
}