
$(document).ready(function () {

  var ctx = $("#playtime_chart").get(0).getContext("2d");

  var myNewChart = new Chart(ctx);

  fetchData();

  function onDataReceived(series) {

    // Load all the data in one pass; if we only got partial
    // data we could merge it with what we already have.
    myNewChart.Line(series, {animation : false});

  }


  function fetchData() {
    $.ajax({
      url: "/data/field_values.json?app_token=alpha_c6aa55221dc7d1e559581ba75babb193&time_range=0&key=FGQuestEnd&bin=all&user_ids=2&field_name=health",
      type: "GET",
      dataType: "json",
      success: onDataReceived
    });

    setTimeout(fetchData, 1000);
  }

});
