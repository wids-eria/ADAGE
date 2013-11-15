$(document).ready(function () {
var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"), 
    width: 500, 
    height: 300, 
    renderer: 'bar',
    series: [{
        color: 'steelblue',
        data: counts,  
        name: 'Play Sessions'
    }
    ]
});
var legend = new Rickshaw.Graph.Legend({
    graph: graph,
    element: document.querySelector('#chart')
});

graph.render();
});
