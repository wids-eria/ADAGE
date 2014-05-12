
$(document).ready(function () {

  
  var graph = new Rickshaw.Graph.Ajax( {
    element: document.getElementById("chart"),
    width: 1000,
    height: 500,
    renderer: 'line',
    dataURL: url,

    onData: function(d) {
  	  Rickshaw.Series.zeroFill(d);
  	  return d;
  	},
  	onComplete: function(transport) {
  	  var graph = transport.graph;
  	  var yAxis = new Rickshaw.Graph.Axis.Y({
          graph: graph,
      });

      var xAxis = new Rickshaw.Graph.Axis.Time( { graph: graph } );

      xAxis.render();

      yAxis.render();
    }

  } );

  

  


  //fetchData();

    

  function onDataReceived(series) {

    // Load all the data in one pass; if we only got partial
    // data we could merge it with what we already have.
   
    graph.series = series;
    console.log(series);
    graph.render(); 

        

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
