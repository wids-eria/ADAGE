//$(function() {
//    $(".side_navigation>ul>a").click(function(){
//    var name = $(this).attr("class")+"_hidden";
//    $(".side_navigation>ul>div").fadeOut();
//    $("#"+name).fadeToggle();
//    });
//});


//$(function() {
//    $(".side_navigation>ul>a>li>span").click(function(){
//    $(this).toggleClass("icon_active");
//    var name = $(this).attr("class")+"_hidden";
//    $(".side_navigation>ul>div").fadeOut();
//    $("#"+name).fadeToggle();
//    });
//});

$(function() {
    
    $(".side_navigation>ul>a").click(function(){
    var name = $(this).attr("class")+"_hidden";
    
    if($(this).find("span").hasClass("icon_active")){
        $(".side_navigation>ul>a").find("span").removeClass("icon_active");
        $(this).find("span").removeClass("icon_active");
        $(".side_navigation>ul>div").fadeOut('fast');
            }else{
                $(".side_navigation>ul>a").find("span").removeClass("icon_active");
                $(this).find("span").addClass("icon_active");
                $(".side_navigation>ul>div").fadeOut('fast');
                $("#"+name).fadeIn('fast');
                }
    }); 
});





