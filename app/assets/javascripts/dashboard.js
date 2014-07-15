$(document).ready(function () {

    $(".graph").each(function(g){
        var data = [{data:[]}];
        var graph = new Rickshaw.Graph( {
            element: this,
            width: 400,
            height: 250,
            series: data,
            min: 'auto',
        });

        var jqxhr = $.get( "remote_graph.json", function(response) {
          result = response['data'];
         // console.log(result);
          data[0].data = result;
          data[0].color = 'steelblue';
          graph.update();
        })
        .fail(function() {})
        .always(function() {});

    });

});
