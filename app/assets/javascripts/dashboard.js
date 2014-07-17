$(document).ready(function () {

  function requestGraph(g){
    var self = g;
    var data = [{data:[]}];
    var graph = new Rickshaw.Graph( {
      element: g,
      width: 380,
      height: 250,
      series: data,
      min: 'auto',
      interpolation: 'linear',
      renderer: 'line',
      padding: { top: 0.08, right: 0, bottom: 0.06, left: 0 },
    });

    var params = {};
    params = jQuery.parseJSON(self.dataset.options);

    var jqxhr = $.get( "remote_graph.json",params, function(response) {
      if(response){
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
      }
    })
    .fail(function() {})
    .always(function() {});
  }

  $(".graph").each(function(g){
    requestGraph(this);
  });

  $(".refresh").click(function(g){
    requestGraph($(this).parent().find(".graph")[0]);
  });
});