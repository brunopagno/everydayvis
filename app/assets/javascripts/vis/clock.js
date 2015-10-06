function clock(element, data) {
  var width = 250;
  var height = 250;
  var radius = Math.min(width, height) / 2;
  var activityRadius = 0.7 * radius;
  var luminosityRadius = 0.55 * radius;
  var dayAndNightRadius = 0.4 * radius;

  var activity_scale = d3.scale.linear().domain([0, data.max_activity]).range([0, 100]);

  var pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return 1; });

  // Activity

  var activityArc = d3.svg.arc()
      .innerRadius(activityRadius)
      .outerRadius(function(d) { 
        return (radius - activityRadius) * (activity_scale(d.data) / 100.0) + activityRadius;
      });

  var activityOutlineArc = d3.svg.arc()
      .innerRadius(activityRadius)
      .outerRadius(radius);

  var svg = d3.select(element).append("svg")
      .attr("class", "daily-clock")
      .attr("width", width)
      .attr("height", height);

  var activitySvg = svg.append("g")
      .attr("class", "activity-arc")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var path = activitySvg.selectAll(".solid-arc")
      .data(pie(data.activities))
    .enter().append("path")
      .attr("class", "solid-arc")
      .attr("d", activityArc);

  var outerPath = activitySvg.selectAll(".outline-arc")
      .data(pie(data.activities))
    .enter().append("path")
      .attr("class", "outline-arc")
      .attr("d", activityOutlineArc);

  // Luminosity

  var luminositySvg = svg.append("g")
      .attr("class", "luminosity-arc")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var luminosityArc = d3.svg.arc()
      .innerRadius(luminosityRadius)
      .outerRadius(activityRadius - 1);

  var luminosityOuterPath = luminositySvg.selectAll(".luminosity-outline-arc")
      .data(pie(data.luminosity))
    .enter().append("path")
      .attr("class", "luminosity-outline-arc")
      .attr("fill", function(d) { return "rgb(" + d.data * 3 + "," + d.data * 2.5 + "," + d.data * 1.5 + ")"; })
      .attr("d", luminosityArc);

  // Day and night

  var dayAndNightSvg = svg.append("g")
      .attr("class", "day-and-night-arc")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  var dayAndNightArc = d3.svg.arc()
      .innerRadius(dayAndNightRadius)
      .outerRadius(luminosityRadius);

  var dayAndNightOuterPath = dayAndNightSvg.selectAll(".luminosity-outline-arc")
      .data(pie(data.day_and_night))
    .enter().append("path")
      .attr("class", "day-and-night-outline-arc")
      .attr("fill", "gray")
      .attr("d", dayAndNightArc);
}
