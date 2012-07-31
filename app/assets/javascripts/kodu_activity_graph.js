$(function() {  
  var width = 800,
      height = 300,
      format = d3.time.format("%Y-%m-%d");

  var x = d3.time.scale()
    .range([0, width]);
   
  var y = d3.scale.linear()
    .range([0, height - 40]);

  var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

  var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");
      
  var chart = d3.select("#kodu_chart").append("svg")
    .attr("class", "chart")
    .attr("width", width)
    .attr("height", height)
    .style("margin-left", "32px") // Tweak alignment…
  .append("g")
    .attr("transform", "translateo(10,15)");

  chart.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  chart.append("g")
    .attr("class", "y axis")
    .call(yAxis)

  var line = d3.svg.line()
    .x(function(d,i) { 
        return x(new Date(d.created_at));
      })
    .y(function(d,i) { 
        if(d.data == "Programming")
        { 
          //console.log('Programming: ' + y(2)); 
          return y(0);
        }
        else if(d.data == "InGame")
        {
          //console.log('InGame: ' + y(3)); 
          return y(3);
        }
        else if(d.data == "HomeMenu" || d.data.indexOf("ToolMenu") != -1 )
        {
          //console.log('HomeMenu: ' + y(1)); 
          return y(2);
        }
        //console.log('Everything else: ' + y(0)); 
        return y(1);
      })


  d3.json("http://localhost:3000/user_kodu_activity_data.json?user_id=3466", function(json) {
   

    x.domain([new Date(json[0].created_at), new Date(json[json.length-1].created_at)]);
    y.domain([0, 3]);

    chart.selectAll("path")
        .data(json)
      .enter().append("svg:path")
        .attr("class", "blueline")
        .attr("d", line(json))

  });
})
