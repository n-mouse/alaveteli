$.each(graphs_data, function(i, graph){
  	var seriesValues = graph["y_values"].reverse();
  	if (i===0){
  		var marker="";
  		var seriesName="запитів: ";
  		var y_text="Кількість запитів";
  	} else {
  		var marker="%";
  		var seriesName="частка: ";		
  		var seriesValues = $.map(seriesValues, function( a ) {
          return Math.round(a * 100) / 100;
        });
        var y_text="Частка запитів";
  	}
  
  $(".charts").append("<div class='single-chart' id='chart"+i+"'></div>");
  	
  var body_names = [];
  var bodies = graph["public_bodies"];
  $.each(bodies, function(i,pb){
  	body_names.push(pb["name"]);
  });
  $('#chart'+i).highcharts({
        chart: {
            type: 'bar'
        },
        title: {
            text: graph["title"]
        },
        xAxis: {
        	title: {text: "hello"},
            categories: body_names.reverse(),
			lineWidth: 0,
		minorGridLineWidth: 0,
		minorTickLength: 0,
		tickLength: 0,
            title: {
                text: null
            },
            labels: {style: {fontSize: "13px", fontWeight: "400"}}
        },
        yAxis: {
        				lineWidth: 0,
		minorGridLineWidth: 0,
		minorTickLength: 0,
		tickLength: 0,
		gridLineColor :'transparent',
            min: 0,
            title: {
                text: y_text,
            }
        },
        legend: {
          enabled: false
        },
        tooltip: {
        	borderColor: "#2C96B8"
        },
        plotOptions: {
        	bar: {
        		tooltip: {headerFormat: '{point.x}<br><b>{point.series.name}</b><br>', pointFormat:'<b>{point.y}'+marker},
        		states: {hover: {color: "#2C96B8"}}
        	},
        	series: {groupPadding: 0}
        },
        series: [{
            name: seriesName,color: '#E15F42',
            data: seriesValues
        }]
    });
  });