
$(document).ready(function () {

  
  
  var xAxis, yAxis, legend;
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
      
      if(!yAxis)
      {
        yAxis = new Rickshaw.Graph.Axis.Y({
          graph: graph,
        });
        yAxis.render();
      }

      if(!xAxis)
      {
        xAxis = new Rickshaw.Graph.Axis.Time( { graph: graph } );
        xAxis.render();
      }



    }

  } );

    
  refreshGraph();

  
  function refreshGraph() {
    graph.request();
    setTimeout(refreshGraph, 1000);

  }
  

 
});
