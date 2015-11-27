var calendarSelectedDays = [];

function fillCalendar(element, data) {
  var max_activity = d3.max(data, function(d) { return d.activity } );
  var steps_scale = d3.scale.linear().domain([0, max_activity]).range([0, 144]);
  var steps_color = d3.scale.linear().domain([0, max_activity / 2, max_activity]).range(["#ff1a1a", "#ffff1a", "#1aff1a"]);

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
      weather: d.weather
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
          updateMapMarkers();
        });

        var weather = $("<div>");
        if (!ev.weather) { weather.attr("class", "cal-weather sun"); }
        else if (ev.weather.indexOf("Rain") >= 0) { weather.attr("class", "cal-weather rain"); }
        else if (ev.weather.indexOf("Thunderstorm") >= 0) { weather.attr("class", "cal-weather thunder"); }

        var fullHistogram = $('<a class="button tiny full-histogram-link">').text("H");
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
          console.log("request to " + url);
          $.ajax({
            url: url,
            success: function(data) {
              var margin = {top: 12, right: 24, bottom: 18, left: 40};
              var width = 1024 - margin.left - margin.right;
              var height = 250 - margin.top - margin.bottom;

              var x = d3.time.scale().range([0, width]);
              var y = d3.scale.linear().range([height, 0]);
              var xAxis = d3.svg.axis().scale(x).orient("bottom");
              var yAxis = d3.svg.axis().scale(y).orient("left");

              var area = d3.svg.area()
                  .x(function(d) { return x(d.datetime); })
                  .y0(height)
                  .y1(function(d) { return y(d.activity); });

              var svg = histo.append("div").attr("class", "graph").append("svg")
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
  });
}
