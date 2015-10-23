function stripe(element, data, width, height) {
  var width = width | 250;
  var height = height | 250;

  var svg = d3.select(element).append("svg")
      .attr("class", "stripe")
      .attr("width", width)
      .attr("height", height);

  var base = svg.append("g")
      .attr("class", "stripe-base")
      .attr("transform", "translate(0," + height / 2 + ")");

  var rw = 10;
  var i = 0;
  data.values.forEach(function(value) {
    base.append("rect")
      .attr("fill", "blue")
      .attr("x", rw * i + i)
      .attr("y", 8)
      .attr("width", rw)
      .attr("height", value);
    i += 1;
  });
}