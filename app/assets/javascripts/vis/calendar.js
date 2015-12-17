var calendarSelectedDays = [];

function fillCalendar(element, data) {
  var max_activity = d3.max(data, function(d) { return d.activity } );
  var steps_color = d3.scale.linear().domain([0, max_activity / 2, max_activity]).range(["#ff1a1a", "#ffff1a", "#1aff1a"]);

  var max_work = d3.max(data, function(d) { return d.work } );
  var work_color = d3.scale.linear().domain([0, max_work / 2, max_work]).range(["#bbbbbb", "#6699ff"]);

  evs = [];
  data.forEach(function(d, i) {
    evs.push({
      d: d,
      title: d.activity + " activity",
      start: d.datetime,
      allDay: true,
      color: steps_color(d.activity),
      textColor: 'black',
      steps_scaled: Math.round(steps_color(d.activity)),
      weather: d.weather,
      doit: true,
      order: 1
    });
    if (d.work > 0) {
      var hh = Math.floor(d.work / 60);
      var mm = d.work - (hh * 60);
      evs.push({
        d: d,
        title: hh + ":" + ("0" + mm).slice(-2) + " worked",
        start: d.datetime,
        allDay: true,
        color: work_color(d.work),
        textColor: 'black',
        work_scaled: Math.round(work_color(d.work)),
        order: 2
      });
    }
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
      eventOrder: 'order',
      eventRender: function(ev, el) {
        el.addClass("day-item");
        el.css('height', '5px');
        el.css('padding', '6px 12px 14px 12px');
        el.css('font-weight', 'bold');

        if (ev.doit) {
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
            updateMapMarkers();
          });

          var weather = $("<div>");
          if (!ev.weather) { weather.attr("class", "cal-weather sun"); }
          else if (ev.weather.indexOf("Rain") >= 0) { weather.attr("class", "cal-weather rain"); }
          else if (ev.weather.indexOf("Thunderstorm") >= 0) { weather.attr("class", "cal-weather thunder"); }

          var fullHistogram = el;
          fullHistogram.on("mousedown", function() {
            $(".full-histogram").remove();
            var histo = d3.select(element).append("div").attr("class", "full-histogram");

            histo.append("div")
              .attr("class", "close-histo float-right")
            .append("a")
              .attr("class", "button round alert tiny")
              .text("X")
              .on("mousedown", function() {
                histo.remove();
              });

            histo.append("h3").text(dayid);
            var user_id = $("#current-person").data("id");
            var dd = new Date(ev.d.datetime);

            var url = "/person/" + user_id + "/histogram/" + dd.getFullYear() + "/" + (dd.getMonth()+1) + "/" + dd.getDate();
            $.ajax({
              url: url,
              success: function(data) {
                var xaxis = ['x'];
                var yaxis = ['activities'];
                data.forEach(function(d) {
                  xaxis.push(new Date(d.datetime));
                  yaxis.push(+d.activity);
                });

                var chart = c3.generate({
                  bindto: histo.append("div"),
                  size: {
                    height: 220
                  },
                  data: {
                    x: 'x',
                    columns: [xaxis, yaxis],
                    type: 'bar'
                  },
                  axis: {
                    x: {
                      type: 'timeseries',
                      tick: {
                        format: '%H:%M'
                      }
                    }
                  }
                });
              },
              error: function() {
                console.log("error loading histogram data");
              }
            });
          });

          var holder = $("<div>").attr("class", "ev-cal-holder");
          holder.append(checkbox);
          holder.append(weather);
          holder.append(fullHistogram);
          holder.append(el);
          return holder;
        }
      }
  });
}
