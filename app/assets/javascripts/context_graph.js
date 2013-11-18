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
    width: 800, 
    height: 400, 
    renderer: 'bar',
    series: series
});

graph.renderer.unstack = true;

graph.render();
});
