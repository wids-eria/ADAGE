$(document).ready(function () {
console.log(counts);
var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"), 
    width: 300, 
    height: 200, 
    renderer: 'bar',
    series: [{
        color: 'steelblue',
        data: counts  
    }]
});

graph.render();
});
