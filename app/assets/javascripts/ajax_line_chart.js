
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
      url: url,
      type: "GET",
      dataType: "json",
      success: onDataReceived
    });

    setTimeout(fetchData, 1000);
  }

});
