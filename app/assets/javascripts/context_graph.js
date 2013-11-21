$(document).ready(function () {

scales = [];

var palette = new Rickshaw.Color.Palette( { scheme: 'munin' } );

var series = [];

console.log(contexts)
contexts.forEach( function(s) {
		series.push( {
			data: s.data,
			color: palette.color()
		} );
} );

 
var graph = new Rickshaw.Graph( {
    element: document.querySelector("#context_graph"), 
    width: 600, 
    height: 200, 
    renderer: 'bar',
    series: series
});

graph.renderer.unstack = true;
var yAxis = new Rickshaw.Graph.Axis.Y({
    graph: graph
});


var format = function(n) {

  console.log(n)
  g = n - .5
	return context_names[g];
}

var x_ticks = new Rickshaw.Graph.Axis.X( {
	graph: graph,
	orientation: 'bottom',
	element: document.getElementById('x_axis'),
	tickFormat: format
} );

yAxis.render();


graph.render();
});
