/////////////////////////////////////////////////
// Clock
/////////////////////////////////////////////////

function Clock() {
  this._arcs = [
    new SunArc(this),
    new LuminosityArc(this),
    new ActivityArc(this)
  ];
  this._size = 300;
  this._margin = 5;
  this._data = [];
  this._elid = "";
  this._innerRadius = 0;
}

Clock.prototype.preprocess = function(data) {
  if (data.size) this._size = data.size;
  if (data.margin) this._margin = data.margin;

  this._elid = data.date.substr(0, 10);
  data.date = new Date(data.date);

  this._radius = this._size / 2 - this._margin;
}

Clock.prototype.validate = function(data) {
  for (var i = 0; i < this._arcs.length; i++) {
    this._arcs[i].validate(data);
  };

  return true;
}

Clock.prototype.draw = function(element, data) {
  if (!this.validate(data)) {
    console.log("There was an error in the data provided to the clock");
    return;
  }

  this.preprocess(data);

  var svg = d3.select(element).append("svg")
      .attr("id", this._elid)
      .attr("class", "clock-arcs")
      .attr("width", this._size)
      .attr("height", this._size);

  var outerRadius = this._radius;
  var walkedRadius = 0;
  for (var i = 0; i < this._arcs.length; i++) {
    var arc = this._arcs[i];
    var innerRadius = this._radius * (1 - arc._width) - walkedRadius;
    arc.draw(svg, data, outerRadius, innerRadius)
    outerRadius = innerRadius;
    walkedRadius += this._radius - innerRadius;
  };
  this._innerRadius = outerRadius;

  this.drawText(svg, data);

  this.setInteraction(element, svg, data);
}

Clock.prototype.drawText = function(svg, data) {
  var textSvg = svg.append("g")
      .attr("class", "text-arc")
      .attr("transform", "translate(" + this._size / 2 + "," + this._size / 2 + ")");

  var hours = -1;
  var time = 0;
  var degrees = 15 * Math.PI / 180;
  var textOffset = this._size / 35;
  var radiusPercent = this._radius * 0.75;
  var textLayer = textSvg.selectAll(".clock-label")
      .data(data.activities)
    .enter().append("text")
      .attr("class", "clock-label")
      .attr("x", function(d) {
        hours += 1;
        return radiusPercent * Math.cos((degrees * hours) + (degrees / 2) - 1.5708) - textOffset;
      })
      .attr("y", function(d) {
        hours += 1;
        return radiusPercent * Math.sin((degrees * hours) + (degrees / 2) - 1.5708) + textOffset;
      })
      .text(function(d) {
        if (time >= 23) time = -1;
        return time += 1;
      });

  svg.append("svg:text")
    .attr("class", "clock-date")
    .attr("dy", ".35em")
    .attr("text-anchor", "middle")
    .attr("transform", "translate(" + this._size / 2 + "," + this._size / 2 + ")")
    .text(data.date.getDate() + "/" + (data.date.getMonth() + 1) + "/" + data.date.getFullYear());
}

Clock.prototype.setInteraction = function(element, svg, data) {
  var pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return 1; });

  var interactionSvg = svg.append("g")
      .attr("class", "luminosity-arc")
      .attr("transform", "translate(" + this._size / 2 + "," + this._size / 2 + ")");

  var interactionArc = d3.svg.arc()
      .innerRadius(this._innerRadius)
      .outerRadius(this._radius);

  var clock_width = this._size;
  var interactionPath = interactionSvg.selectAll(".interaction-arc")
      .data(pie(data.luminosity))
    .enter().append("path")
      .attr("class", "interaction-arc")
      .attr("fill", "transparent")
      .attr("d", interactionArc)
      .on("mousedown", function(d, hourNumber) {
        $(".interaction-arc").attr("class", "interaction-arc");
        $(this).attr("class", "interaction-arc highlight");
        showDataForClockSlice(element, data.user_id, data.date, hourNumber + 1, clock_width);
      });
}

/////////////////////////////////////////////////
// Sun Arc
/////////////////////////////////////////////////

function SunArc(clock) {
  this._clock = clock;
  this._active = true;
  this._width = 0.08;
  this._pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return 1; });
}

SunArc.prototype.validate = function(data) {
  if (!data.sunrise || !data.sunset) {
    this._active = false;
  } else {
    if (!(data.sunrise instanceof Date)) data.sunrise = new Date(data.sunrise);
    if (!(data.sunset instanceof Date)) data.sunset = new Date(data.sunset);
  }
  return this._active;
}

SunArc.prototype.draw = function(svg, data, outerRadius, innerRadius) {
  var sun_scale = d3.scale.linear().domain([0, 24]).range([0, 360]);

  var sunSvg = svg.append("g")
      .attr("class", "sun-arc")
      .attr("transform", "translate(" + this._clock._size / 2 + "," + this._clock._size / 2 + ")");

  var dayStartAngle = sun_scale(data.sunrise.getHours() + data.sunrise.getMinutes() / 60) * Math.PI / 180;
  var dayEndAngle = sun_scale(data.sunset.getHours() + data.sunset.getMinutes() / 60) * Math.PI / 180;

  var sunArc = d3.svg.arc()
    .innerRadius(outerRadius)
    .outerRadius(innerRadius);

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
  var r = (outerRadius + innerRadius) / 2;
  var sunSize = outerRadius * 0.03;

  var sunCircleSvg = sunSvg.append("circle")
      .attr("fill", "yellow")
      .attr("cx", r * Math.sin(alpha))
      .attr("cy", -r * Math.cos(alpha))
      .attr("r", sunSize);

  var moonCircleSvg = sunSvg.append("circle")
      .attr("fill", "lightgray")
      .attr("cx", -r * Math.sin(alpha))
      .attr("cy", r * Math.cos(alpha))
      .attr("r", sunSize);
}

/////////////////////////////////////////////////
// Luminosity Arc
/////////////////////////////////////////////////

function LuminosityArc(clock) {
  this._clock = clock;
  this._active = true;
  this._width = 0.08;
}

LuminosityArc.prototype.validate = function(data) {
  if (!data.luminosity) {
    this._active = false;
  }
  return this._active;
}

LuminosityArc.prototype.draw = function(svg, data, outerRadius, innerRadius) {
  var max_luminosity = d3.max(data.luminosity);
  var luminosity_scale = d3.scale.linear().domain([0, max_luminosity]).range(["#000", "#fff"]);

  var innerPie = d3.layout.pie()
      .sort(null)
      .padAngle(-0.01)
      .value(function(d) { return 1; });

  var luminositySvg = svg.append("g")
      .attr("class", "luminosity-arc")
      .attr("transform", "translate(" + this._clock._size / 2 + "," + this._clock._size / 2 + ")");

  var luminosityArc = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius);

  var luminosityOuterPath = luminositySvg.selectAll(".luminosity-outline-arc")
      .data(innerPie(data.luminosity))
    .enter().append("path")
      .attr("class", "luminosity-outline-arc")
      .attr("fill", function(d) { return luminosity_scale(d.data); })
      .attr("d", luminosityArc);
}

/////////////////////////////////////////////////
// Activity Arc
/////////////////////////////////////////////////

function ActivityArc(clock) {
  this._clock = clock;
  this._active = true;
  this._width = 0.3;
}

ActivityArc.prototype.validate = function(data) {
  if (!data.activity) {
    this._active = false;
  }
  return this._active;
}

ActivityArc.prototype.draw = function(svg, data, outerRadius, innerRadius) {
  var max_activity = d3.max(data.activities);
  var activity_scale = d3.scale.linear().domain([0, max_activity]).range([0, 100]);

  var pie = d3.layout.pie()
      .sort(null)
      .value(function(d) { return 1; });

  var activityArc = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius(function(d) { 
        if (d.data == "sleep") {
          return (outerRadius - innerRadius) * (activity_scale(max_activity) / 100.0) + innerRadius;
        } else {
          return (outerRadius - innerRadius) * (activity_scale(d.data) / 100.0) + innerRadius;
        }
      });

  var activityOutlineArc = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius);

  var activitySvg = svg.append("g")
      .attr("class", "activity-arc")
      .attr("transform", "translate(" + this._clock._size / 2 + "," + this._clock._size / 2 + ")");

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
}

/////////////////////////////////////////////////
// Ajax function to load subdata
/////////////////////////////////////////////////

function showDataForClockSlice(element, user_id, date, hour, clock_width) {
  $(".slice-info").remove();
  var slice = d3.select(element).append("div")
      .attr("class", "slice-info")
      .style("left", clock_width + -15 + "px");

  slice.append("h3")
      .text(hour + "h")
    .append("small")
      .text(" of day " + date.getDate());

  var url = "/person/" + user_id + "/" + date.getFullYear() + "/" + (date.getMonth()+1) + "/" + date.getDate() + "/" + hour;
  console.log("request to " + url);
  $.ajax({
    url: url,
    success: function(data) {
      slice.classed("ajax-error", false);

      var margin = {top: 12, right: 24, bottom: 18, left: 40};
      var width = 450 - margin.left - margin.right;
      var height = 220 - margin.top - margin.bottom;

      var x = d3.time.scale().range([0, width]);
      var y = d3.scale.linear().range([height, 0]);
      var xAxis = d3.svg.axis().scale(x).orient("bottom");
      var yAxis = d3.svg.axis().scale(y).orient("left");

      var area = d3.svg.area()
          .x(function(d) { return x(d.datetime); })
          .y0(height)
          .y1(function(d) { return y(d.activity); });

      var svg = slice.append("div").attr("class", "graph").append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      data.forEach(function(d) {
        d.datetime = new Date(d.datetime);
        d.activity = +d.activity;
      });

      x.domain(d3.extent(data, function(d) { return d.datetime; }));
      y.domain([0, d3.max(data, function(d) { return d.activity; })]);

      svg.append("path")
          .datum(data)
          .attr("class", "area")
          .attr("d", area);

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
          .attr("dy", ".71em")
          .style("text-anchor", "end")
          .text("Activity");
    },
    error: function() {
      slice.classed("ajax-error", true);
    }
  });
}