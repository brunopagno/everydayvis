var calendarSelectedDays = [];

function fillCalendar(element, data) {
  var max_activity = d3.max(data, function(d) { return d.activity } );
  var steps_scale = d3.scale.linear().domain([0, max_activity]).range([0, 144]);
  var steps_color = d3.scale.linear().domain([0, max_activity]).range(["#1A75FF", "#FF471A"]);

  evs = [];
  data.forEach(function(d, i) {
    evs.push({
      d: d,
      title: d.activity + " activity",
      start: d.datetime,
      allDay: true,
      color: steps_color(d.activity),
      textColor: 'black',
      steps_scaled: Math.round(steps_color(d.activity))
    });
  });

  $(element).fullCalendar({
    header: {
        left: 'prev,next',
        center: 'title',
        right: 'month'
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

        var dayid = ev.d.datetime.substr(0, 10);
        var checkbox = $('<input type=checkbox class="calendar-box">')
        checkbox.attr("dayid", dayid);
        checkbox.attr("value", ev.start);
        checkbox.prop("checked", calendarSelectedDays.indexOf(dayid) >= 0 || $('.calendar-select-all').prop('checked'));

        // CHECK CALENDAR DAY
        checkbox.change(function() {
          if (this.checked) {
            calendarSelectedDays.push($(this).attr("dayid"));
          } else {
            var index = calendarSelectedDays.indexOf($(this).attr("dayid"));
            if (index > -1) {
              calendarSelectedDays.splice(index, 1);
            }
          }
        });

        var holder = $("<div>").attr("class", "ev-cal-holder");
        holder.append(checkbox);
        holder.append(el);
        return holder;
      }
  });
}
