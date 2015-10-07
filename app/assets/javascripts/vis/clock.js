function clock(element, data) {
  var width = 500;
  var height = 500;
  var margin = 5;
  var radius = Math.min(width, height) / 2 - margin;
  var luminosityRadius = 0.85 * radius;
  var activityRadius = 0.55 * radius;
  var sunRadius = 0.4 * radius;

  var activity_scale = d3.scale.linear().domain([0, data.max_activity]).range([0, 100]);
  var luminosity_scale = d3.scale.linear().domain([0, data.max_luminosity]).range(["#3a3201", "#ffec6b"]);
  var sun_scale = d3.scale.linear().domain([0, 24]).range([0, 360]);

  var pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return 1; });

  var innerPie = d3.layout.pie()
      .sort(null)
      .padAngle(-0.01)
      .value(function(d) { return 1; });

  var svg = d3.select(element).append("svg")
      .attr("class", "daily-clock")
      .attr("width", width)
      .attr("height", height);

  // Luminosity

  var luminositySvg = svg.append("g")
      .attr("class", "luminosity-arc")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var luminosityArc = d3.svg.arc()
      .innerRadius(luminosityRadius)
      .outerRadius(radius);

  var luminosityOuterPath = luminositySvg.selectAll(".luminosity-outline-arc")
      .data(innerPie(data.luminosity))
    .enter().append("path")
      .attr("class", "luminosity-outline-arc")
      .attr("fill", function(d) { return luminosity_scale(d.data); })
      .attr("d", luminosityArc);

  // Activity

  var activityArc = d3.svg.arc()
      .innerRadius(activityRadius)
      .outerRadius(function(d) { 
        if (d.data == "sleep") {
          return (luminosityRadius - activityRadius) * (activity_scale(data.max_activity) / 100.0) + activityRadius;
        } else {
          return (luminosityRadius - activityRadius) * (activity_scale(d.data) / 100.0) + activityRadius;
        }
      });

  var activityOutlineArc = d3.svg.arc()
      .innerRadius(activityRadius)
      .outerRadius(luminosityRadius - 1);

  var activitySvg = svg.append("g")
      .attr("class", "activity-arc")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var path = activitySvg.selectAll(".solid-arc")
      .data(pie(data.activities))
    .enter().append("path")
      .attr("class", "solid-arc")
      .attr("fill", function(d) { return d.data == "sleep" ? "#3d3d76" : "#4147f0"})
      .attr("d", activityArc);

  var outerPath = activitySvg.selectAll(".outline-arc")
      .data(pie(data.activities))
    .enter().append("path")
      .attr("class", "outline-arc")
      .attr("d", activityOutlineArc);

  // Sun

  var sunSvg = svg.append("g")
      .attr("class", "sun-arc")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var dayStartAngle = sun_scale(data.sunrise.getHours() + data.sunrise.getMinutes() / 60) * Math.PI / 180;
  var dayEndAngle = sun_scale(data.sunset.getHours() + data.sunset.getMinutes() / 60) * Math.PI / 180;

  var sunArc = d3.svg.arc()
    .innerRadius(sunRadius)
    .outerRadius(activityRadius);

  var dayPath = sunSvg.append("path")
      .attr("class", "sun-outline-arc")
      .attr("fill", "#7ec7ee")
      .attr("d", sunArc.startAngle(function(d) {
                          return dayStartAngle;
                        }).endAngle(function(d) {
                          return dayEndAngle;
                        })
      );

  var nightPath = sunSvg.append("path")
      .attr("class", "sun-outline-arc")
      .attr("fill", "#5c5c83")
      .attr("d", sunArc.startAngle(function(d) {
                          return dayEndAngle;
                        }).endAngle(function(d) {
                         return dayStartAngle + Math.PI * 2;
                       })
      );

  var alpha = (dayStartAngle + dayEndAngle) / 2;
  var r = (activityRadius + sunRadius) / 2;

  var sunCircleSvg = sunSvg.append("circle")
      .attr("fill", "yellow")
      .attr("cx", r * Math.sin(alpha))
      .attr("cy", -r * Math.cos(alpha))
      .attr("r", radius * 0.045);

  var moonCircleSvg = sunSvg.append("circle")
      .attr("fill", "lightgray")
      .attr("cx", -r * Math.sin(alpha))
      .attr("cy", r * Math.cos(alpha))
      .attr("r", radius * 0.045);
}
