
$(document).ready(function () {

  var ctx = $("#playtime_chart").get(0).getContext("2d");

  console.log(playtimes);
  var myNewChart = new Chart(ctx).Line(playtimes);

});
