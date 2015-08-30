$(function() {
  $( "#from" ).datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 1,
    onClose: function( selectedDate ) {
      $( "#to" ).datepicker( "option", "minDate", selectedDate );
    }
  });

  var from = $( "#from" ).val();
  if(from != "") $( "#from" ).val(moment(from,"x").format("MM/DD/YYYY"));

  $( "#to" ).datepicker({
    defaultDate: "+1w",
    changeMonth: true,
    numberOfMonths: 1,
    onClose: function( selectedDate ) {
      $( "#from" ).datepicker( "option", "maxDate", selectedDate );
    }
  });

  var to = $( "#to" ).val();
  if(to != "") $( "#to" ).val(moment(from,"x").format("MM/DD/YYYY"));
  $("#apply").click(function(){
  	var filter = {};
  	$.each(Dashboard.filters(),function(key,value){
  		filter[key] = value;
  	});

	$.redirectPost(window.location.href, {filters: filter});
  });
});

$.extend(
{
    redirectPost: function(location, args)
    {
        var form = '';
        $.each( args, function( key, value ) {
            form += '<input type="hidden" name="'+key+'" value='+JSON.stringify(value)+'>';
        });
        $('<form action="' + location + '" method="POST">' + form + '</form>').appendTo($(document.body)).submit();
    }
});

Dashboard = {
	filters: function(){
		//Grab all of the filters
		var temp = [];

		$("#filters .filter").each(function(key,value){
			var filter = {
				type: $(this).attr("filter"),
				key: $(this).attr("key"),
				values: undefined
			}

			if(filter.type == "range"){
				filter.key = "timestamp";
				var from = $(this).find("#from").val().trim();
				var to = $(this).find("#to").val().trim();
				if(from != "" && to != ""){
					filter.values = [
						moment(from).unix(),
						moment(to).unix()
					];
					temp.push(filter);
				}
			}else if(filter.type == "select"){
				if(filter.key == undefined){
					filter.key = $(this).find("#key").text().trim();
				}

				filter.values = $(this).val().trim();
				temp.push(filter);
			}else{
				filter.key = $(this).find("#key").text().trim(),
				filter.values = $(this).find("#val").text().trim();
				temp.push(filter);
			}
		});
		return temp;
	}
};

