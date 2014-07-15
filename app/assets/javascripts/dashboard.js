$(document).ready(function () {

    $(".graph").each(function(g){
        var data = [{data:[]}];
        var graph = new Rickshaw.Graph( {
          element: this,
          width: 400,
          height: 250,
          series: data,
          min: 'auto',
          interpolation: 'linear',
          renderer: 'line',
        });


        var jqxhr = $.get( "remote_graph.json", function(response) {
          data[0].name = response['name'];
          data[0].data = response['data'];
          data[0].color = 'steelblue';
          graph.update();

          var hoverDetail = new Rickshaw.Graph.HoverDetail( {
            graph: graph,
          });

          var legend = new Rickshaw.Graph.Legend( {
            graph: graph,
            element: document.getElementById('legend')
          });

          var xAxis = new Rickshaw.Graph.Axis.Time({
            graph: graph,
            orientation: 'bottom',
          });

          var yAxis = new Rickshaw.Graph.Axis.Y({
            graph: graph,
          });
          yAxis.render();
          xAxis.render();

        })
        .fail(function() {})
        .always(function() {});

    });

});
