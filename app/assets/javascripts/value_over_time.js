$(document).ready(function () {
console.log(counts);
var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"), 
    width: 300, 
    height: 200, 
    renderer: 'line',
    series: [players]
});
var legend = new Rickshaw.Graph.Legend({
    graph: graph,
    element: document.querySelector('#chart')
});

graph.render();
});
