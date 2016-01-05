var max_selected_activity = 0;

$(document).ready(function() {
  // CHANGE CLOCKS RELATIVE TO ALL
  $('.clocks-relative-to-all').change(function() { do_view_clocks(); });

   // press escape closes all graphics
  $(document).keydown(function(event) {
    if (event.which === 27) {
      d3.select(".slice-info").style("visibility", "hidden");
    }
  });

  function do_view_clocks() {
    $(".clocks").children(".clock").each(function(i, clock) {
      clock.remove();
    });
    calendarSelectedDays.forEach(function(id) {
      addClockToView(id);
    });
  
    return false;
  }
});

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

function updateMaxSelectedActivity() {
  max_selected_activity = 0;
  person_id = $("#current-person").data("id");
  for (var i = 0; i < calendarSelectedDays.length; i++) {
    date = calendarSelectedDays[i];
    url = "/person/" + person_id + "/max_activity/" + date.substr(0, 4) + "/"  + date.substr(5, 2) + "/"  + date.substr(8, 2);
    $.ajax({
      url: url,
      success: function(data) {
        if (data > max_selected_activity) {
          max_selected_activity = data;
        }
      },
      error: function() {
        console.log("Something went wrong with clocks request.");
      }
    });
  }
}
