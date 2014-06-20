// The following code modified from: 
//		http://bl.ocks.org/mbostock/3883245
//		http://bl.ocks.org/mbostock/3902569

var margin = {top: 20, right: 75, bottom: 30, left: 75},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var parseDate = d3.time.format("%m-%d-%Y %H:%M %Z").parse,
	bisectDate = d3.bisector(function(d) { return d.time; }).left,
	printDate = d3.time.format("%I:%M %p");

var x = null;
var xAxis = null;

setXScale();

var y = d3.scale.log().clamp(true)
    .range([height, 0]);

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

var line = d3.svg.line()
    .x(function(d) { return x(d.time); })
    .y(function(d) { return y(d.volume); });

var svg = null;

function setWidth(newWidth) {
	
	width = newWidth - margin.left - margin.right;
}

function setHeight(newHeight) {
	
	height = newHeight - margin.top - margin.bottom;
}

function setXScale() {
	
	x = d3.time.scale()
	    .range([0, width]);

	xAxis = d3.svg.axis()
	    .scale(x)
	    .orient("bottom");	
}

function setYScaleType(data) {

	var LOG_VALUE_THRESHOLD = 100000;
	var minVal = 0;
	var maxVal = d3.max(data, function(d) { return d.volume; });
	var isLog = false;
	
	if (maxVal > LOG_VALUE_THRESHOLD)
	{
		isLog = true;
		y = d3.scale.log().clamp(true)
		    	.range([height, 0]);
		
		minVal = Math.min(1000,d3.min(data, function(d) { return d.volume }));
	}
	else
	{
		y = d3.scale.linear()
		    	.range([height, 0]);
		
		minVal = 0;
	}

	yAxis = d3.svg.axis()
		    .scale(y)
		    .orient("left");

	y.domain([minVal,Math.max(500,maxVal)]).nice();
	
	return isLog;
}

function fixDataForLogScale(data) {
	
	data.forEach(function(d) {
		if (d.volume <= 0)
	    	d.volume = 1;
	});
}

function showGraph(error, data) {

  if (!svg) return;

  data.forEach(function(d) {
    d.time = parseDate(d.time);
    d.volume = +d.volume;
  });

  x.domain(d3.extent(data, function(d) { return d.time; }));
  if (setYScaleType(data))
  {
	fixDataForLogScale(data);
  }

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em");

  svg.append("path")
      .datum(data)
      .attr("class", "line")
      .attr("d", line);

	  var focus = svg.append("g")
	      .attr("class", "focus")
	      .style("display", "none");

	  focus.append("circle")
	      .attr("r", 3.5);
	
	  svg.append("rect")
	      .attr("class", "overlay")
	      .attr("width", width + 25)
	      .attr("height", height)
	      .on("mouseout", function() { $("#graphinfo").empty(); focus.style("display", "none"); })
		  .on("mouseover", function() { focus.style("display", null); })
	      .on("mousemove", mousemove);

	function mousemove() {

	    var x0 = x.invert(d3.mouse(this)[0]),
	        i = bisectDate(data, x0, 1),
	        d0 = data[i - 1],
	        d1 = data[i];

		var d = d0;
		if (d1)
			d = x0 - d0.date > d1.date - x0 ? d1 : d0;
	
		focus.attr("transform", "translate(" + x(d.time) + "," + y(d.volume) + ")");

		$("#graphinfo").empty()
					   .append("<b>" + printDate(d.time) + "</b> : " + d.volume + " tweets/min");
	}
}

$(function() {
	if (d3.select("#graph"))
	{
		setWidth($("#graph").width());
		setHeight(width/2);
		setXScale();
		
		svg = d3.select("#graph").append("svg").attr("width", width + margin.left + margin.right)
		      .attr("height", height + margin.top + margin.bottom)
		  	  .append("g")
		      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
	}
});
