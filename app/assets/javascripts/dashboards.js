$(document).ready(function(){	
	$(".class_dropdown").each(function(data){
		var value = $(this).val();
		$(this).parent().find("#dashboard_class_id").val(value);
	});

	$(".class_dropdown").change(function(){
		var value = $(this).val();
		$(this).parent().find("#dashboard_class_id").val(value);
	});
});
