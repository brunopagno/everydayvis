function clock(element, data) {
  var svg = d3.select(element).append('svg')
      .attr('width', 100)
      .attr('height', 100)
    .append('g')
      .attr('transform', "translate(50, 50)");
}