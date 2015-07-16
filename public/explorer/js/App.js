App = {
	ADAGE: new ADAGE({
		url: "http://adage.gameslearningsociety.org/",
		app_token: "",
		app_secret: ""
	}),
	filters: function(){
		//Grab all of the filters
		var temp = [];

		$("#filters .filter").each(function(key,value){
			var filter = {
				type: $(this).attr("type"),
				key: undefined,
				values: undefined
			}
			if(filter.type == "range"){
				filter.key = "timestamp",
				filter.values = [
					moment($(this).find("#from").text().trim()).unix(),
					moment($(this).find("#to").text().trim()).unix()
				];
			}else{
				filter.key = $(this).find("#key").text().trim(),
				filter.values = $(this).find("#val").text().trim();
			}
			temp.push(filter);
		});
		return temp;
	}
};

