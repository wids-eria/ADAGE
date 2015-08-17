$(document).ready(function(){	
	$(".class_dropdown").each(function(data){
		var value = $(this).val();
		var url = $(this).parent().find(".dashboard_link").attr("href");
		if(url) $(this).parent().find(".dashboard_link").attr("href",url+"/"+value);
	});

	$(".class_dropdown").change(function(){
		var value = $(this).val();
		var url = $(this).parent().find(".dashboard_link").attr("href");
		if(url){
			url = url.split("/").slice(0,-1).join("/")+"/"+value;
			$(this).parent().find(".dashboard_link").attr("href",url);
		}
	});
});