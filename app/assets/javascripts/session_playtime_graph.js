$(document).ready(function () {

scales = [];

var palette = new Rickshaw.Color.Palette( { scheme: 'cool' } );

var series = [];

playtimes.forEach( function(s) {
		series.push( {
			data: s.data,
			color: palette.color()
		} );
} );

 
var graph = new Rickshaw.Graph( {
    element: document.querySelector("#playtime_graph"), 
    width: 800, 
    height: 400, 
    renderer: 'bar',
    series: series
});


var hoverDetail = new Rickshaw.Graph.HoverDetail( {
	graph: graph,
	formatter: function(series, x, y) {
		var content = names[x] + ": " + parseInt(y) + '<br>' + 'minutes';
		return content;
	}
} );


graph.render();
});
