$(document).ready(function() {
  $('.calendar-select-all').change(function() {
    var check = $(this).is(":checked");
    $('.calendar-box').each(function() {
      this.checked = check;
    });
  });
});

function fillCalendar(element, data) {
  var max_activity = d3.max(data, function(d) { return d.activity } );
  var steps_scale = d3.scale.linear().domain([0, max_activity]).range([0, 144]);
  var steps_color = d3.scale.linear().domain([0, max_activity]).range(["#7f7f6e", "#7f7fff"]);

  evs = [];
  data.forEach(function(d, i) {
    evs.push({
      d: d,
      title: d.activity + " activity",
      start: d.datetime,
      color: steps_color(d.activity),
      textColor: 'black',
      steps_scaled: Math.round(steps_color(d.activity))
    });
  });

  $(element).fullCalendar({
    header: {
        left: 'prev,next today',
        center: 'title',
      },
      defaultDate: data[0].datetime,
      displayEventTime: false,
      businessHours: false,
      editable: false,
      events: evs,
      eventRender: function(ev, el) {
        el.addClass("day-item");
        el.css('height', '5px');
        el.css('padding', '6px 12px 14px 12px');
        el.css('font-weight', 'bold');

        var checkbox = $('<input type=checkbox class="calendar-box"></input>')
        checkbox.attr("value", ev.start);

        el.append(checkbox);

        // var svg = $("<svg></svg>");
        // svg.attr("width", 100)
        //    .attr("height", 100);

        // var circle = $("<circle></circle>");
        // circle.attr("cx", 10)
        //       .attr("cy", 10)
        //       .attr("r", 50)
        //       .attr("fill", "red");

        // el.append(svg);
        // svg.append(circle);
      }
  });
}
