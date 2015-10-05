function clock(element, data) {
  var rect = d3.select(element).node().getBoundingClientRect();

  var svg = d3.select(element).append('svg')
      .attr('width', 100)
      .attr('height', 100)
    .append('g');

  var circle = svg.append("circle")
      .attr('fill', 'red')
      .attr('cx', 50)
      .attr('cy', 50)
      .attr('r', 50);
}
