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
        el.css('height', '10px');
        el.css('padding', '12px');
        el.css('font-weight', 'bold');
      }
  });
}
