$(document).ready(function () {
  $(".graph").each(function(g){
    var self = this;
    var data = [{data:[]}];
    var graph = new Rickshaw.Graph( {
      element: this,
      width: 380,
      height: 250,
      series: data,
      min: 'auto',
      interpolation: 'linear',
      renderer: 'line',
      padding: { top: 0.08, right: 0, bottom: 0.06, left: 0 },
    });

    var jqxhr = $.get( "remote_graph.json", function(response) {
      data[0].name = response['name'];
      data[0].data = response['data'];
      data[0].color = 'steelblue';
      graph.update();

      var hoverDetail = new Rickshaw.Graph.HoverDetail( {
        graph: graph,
        orientation: 'left',
      });

      var legend = new Rickshaw.Graph.Legend( {
        graph: graph,
        element: $(self).parent().find("#legend")[0]
      });

      var xAxis = new Rickshaw.Graph.Axis.Time({
        graph: graph,
        orientation: 'bottom',
      });

      var yAxis = new Rickshaw.Graph.Axis.Y({
        graph: graph,
        element: $(self).parent().find("#yaxis")[0]
      });
      yAxis.render();
      xAxis.render();

    })
    .fail(function() {})
    .always(function() {});

  });
});