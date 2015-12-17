$(document).ready(function() {
  // VIEW CLOCKS
  $('#view-clocks').click(do_view_clocks);

  // CHANGE CLOCKS RELATIVE TO ALL
  $('.clocks-relative-to-all').change(function() { do_view_clocks(); });

  // SELECT ALL
  $('.calendar-select-all').change(function() {
    var check = $(this).is(":checked");
    $('.calendar-box').each(function() {
      this.checked = check;
      if (this.checked) {
        var dayid = $(this).attr("dayid");
        if (calendarSelectedDays.indexOf(dayid) < 0) {
          calendarSelectedDays.push($(this).attr("dayid"));
        }
      } else {
        calendarSelectedDays = [];
      }
    });
    updateMapMarkers();
  });

  // press escape closes all graphics
  $(document).keydown(function(event) {
    if (event.which === 27) {
      d3.select(".slice-info").style("visibility", "hidden");
    }
  });

  function do_view_clocks() {
    calendarSelectedDays.forEach(function(id) {
      addClockToView(id);
    });
  
    return false;
  }

  function addClockToView(date) {
    person_id = $("#current-person").data("id");
    url = "/person/" + person_id + "/clock/" + date.substr(0, 4) + "/"  + date.substr(5, 2) + "/"  + date.substr(8, 2);
    $.ajax({
      url: url,
      success: function(data) {
        new Clock().draw(".clocks", data);
      },
      error: function() {
        console.log("Something went wrong with clocks request.");
      }
    });
  }
});
