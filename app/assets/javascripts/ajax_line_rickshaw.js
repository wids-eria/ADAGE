
$(document).ready(function () {

  
  
  var xAxis, yAxis, legend;
  var graph = new Rickshaw.Graph.Ajax( {
    element: document.getElementById("chart"),
    width: 1000,
    height: 500,
    renderer: 'multi',
    stack: false,
    dataURL: url,

    onData: function(d) {
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
        var format = function(d) {
          if(d > 100000000) 
          {
            d = new Date(d);
            return d3.time.format("%b %e %I:%M")(d);
          }
          else
          {
            return d;
          }
            
        }
        xAxis = new Rickshaw.Graph.Axis.X( { 
          graph: graph,
          tickFormat: format,
        } );
        xAxis.render();
      }

      if(!legend)
      {
        legend = new Rickshaw.Graph.Legend({
          graph: graph,
          element: document.getElementById('legend'),
        });
        legend.render();

        var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
        	graph: graph,
	        legend: legend
        } );

        var order = new Rickshaw.Graph.Behavior.Series.Order( {
	        graph: graph,
        	legend: legend
        } );

        var highlighter = new Rickshaw.Graph.Behavior.Series.Highlight( {
          graph: graph,
  	      legend: legend
        } );
      }

      graph.request();


    }

  } );

    
  refreshGraph();

  
  function refreshGraph() {
    graph.request();
    setTimeout(refreshGraph, 1000);

  }
  

 
});
