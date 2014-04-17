$(document).ready(function () {
 
  var url = '/get_events.json?app_token=alpha_c6aa55221dc7d1e559581ba75babb193&time_range=0&events_list=FGQuestEnd" 
  
  var ajaxGraph = new Rickshaw.Graph.Ajax( {
        element: document.getElementById("chart"),
        width: 800,
        height: 400,
        renderer: 'line',
        dataURL: '/get_events.json',
        onData: function(data) {
        
        },
        onComplete: function() {
            // this is also where you can set up your axes and hover detail
            this.graph.render();
        }
    } );


});
