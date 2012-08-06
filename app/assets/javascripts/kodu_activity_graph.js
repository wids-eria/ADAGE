$(function() {  
  var margin = {top: 10, right: 10, bottom: 20, left: 80}
      width = 1100 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom,
      format = d3.time.format("%Y-%m-%d");

  var x = d3.scale.linear()
    .range([0, width]);
   
  var y = d3.scale.linear()
    .range([height, 0])
    .domain([0,2]);

  var xAxis = d3.svg.axis()
    .scale(x)
    .ticks(0)
    .orient("bottom")

  var yLabel = function(i) {
      var labels = ["Programming", "Edit", "In Game"];
      return labels[i];
  };

  var yAxis = d3.svg.axis()
    .scale(y)
    .ticks(3)
    .tickFormat(yLabel)
    .orient("left");
  
  var chart = d3.select("#kodu_chart").append("svg")
    //.attr("class", "chart")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .style("margin-left", "32px") // Tweak alignment…
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  chart.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);

  chart.append("g")
    .attr("class", "y axis")
    .call(yAxis)

      

  var line = function(json, start) {
    var func = d3.svg.line(json)
    .interpolate("step-after")
    .x(function(d) { 
        //console.log('x: ' +  x(d3.time.seconds(start,new Date(d.created_at)).length)); 
        //return x(i);
        return x(d3.time.seconds(start,new Date(d.created_at)).length);
      })
    .y(function(d) { 
        if(d.data == "Programming")
        { 
          //console.log('Programming: ' + y(2)); 
          return y(0);
        }
        else if(d.data == "InGame" || d.data == 'ToolMenuRunSim')
        {
          //console.log('InGame: ' + y(3)); 
          return y(2);
        }
        //else if(d.data == "HomeMenu" || d.data.indexOf("ToolMenu") != -1 )
        //{
          //console.log('HomeMenu: ' + y(1)); 
        //  return y(2);
        //}
        //console.log('Everything else: ' + y(0)); 
        return y(1);
      })
    return func(json);  
  };

  var AsyncEach = function(array, iterator, complete) {
    var list    = array,
      n       = list.length,
      i       = -1,
      calls   = 0,
      looping = false;

    var iterate = function() {
      calls -= 1;
      i += 1;
      if (i === n) {
        complete();
        return;
      }
    iterator(list[i], resume);
    };

    var loop = function() {
      if (looping) return;
      looping = true;
      while (calls > 0) iterate();
      looping = false;
    };

    var resume = function() {
      calls += 1;
      if (typeof setTimeout === 'undefined') loop();
      else setTimeout(iterate, 1);
    };
    resume();
  };
  
  d3.json("http://localhost:3000/user_kodu_level_info.json?user_id=3466", function(level_info) {

    var i = 0;
    var max_time = 0;
    AsyncEach(level_info, function(item, resume) {

      var start_time = level_info[i].created_at;
      var end_time = (i < level_info.length-1) ? level_info[i+1].created_at : ""; 
      
      var start = new Date(start_time);
      var end = new Date(end_time);

      if(i > 0)
      {
        return;
      }

      i++;
      console.log("http://localhost:3000/user_kodu_activity_data.json?user_id=3466&start_time="+start_time+"&end_time="+end_time);

     
      d3.json("http://localhost:3000/user_kodu_activity_data.json?user_id=3466&start_time="+start_time+"&end_time="+end_time, function(json) {
   

        console.log(json.length);

        if(json.length > 0)
        {
          var real_end = new Date(json[json.length-1].created_at);

          max_time = (d3.time.seconds(start, real_end).length > max_time) ? d3.time.seconds(start,real_end).length : max_time;
          console.log("current level " + d3.time.seconds(start, real_end).length);
          console.log("max time" + max_time);

          x.domain([0, max_time+5]);
          xAxis.ticks(max_time+5);
        }


        var new_chart = d3.select("#kodu_chart").append("svg")
            //.attr("class", "chart")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .style("margin-left", "32px") // Tweak alignment…
          .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        new_chart.selectAll("path")
            .data(json)
          .enter().append("svg:path")
            .attr("class", "blueline")
            .attr("stroke",'#'+Math.floor(Math.random()*16777215).toString(16))
            .attr("d", line(json, start))
        

        var node = new_chart.selectAll(".bluedot")
          .data(json)
        .enter().append("circle")
          .attr("class", "bluedot")
          .attr("r", 4)
          .attr("fill",'#'+Math.floor(Math.random()*16777215).toString(16))
          .attr("cx", function(d) {return x(d3.time.seconds(start,new Date(d.created_at)).length);})
          .attr("cy", function(d) { 
            if(d.data == "Programming")
            { 
              //console.log('Programming: ' + y(2)); 
              return y(0);
            }
            else if(d.data == "InGame"  || d.data == 'ToolMenuRunSim')
            {
              //console.log('InGame: ' + y(3)); 
              return y(2);
            }
            //else if(d.data == "HomeMenu" || d.data.indexOf("ToolMenu") != -1 )
            //{
              //console.log('HomeMenu: ' + y(1)); 
            //  return y(2);
           // }
            //console.log('Everything else: ' + y(0)); 
            return y(1);
          });

        node.append("title")
          .text(function(d) { return d.name + " " + d.data;});


        resume();
      });
      
    }, function(){});

 
  });
})
