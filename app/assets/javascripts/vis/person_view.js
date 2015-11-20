$(document).ready(function() {
  // VIEW CLOCKS
  $('#view-clocks').click(function() {
    if ($(".calendar-box:checked").length === 0) {
      alert("Please select at least one day.");
      return false;
    }

    $(".person-wrapper").animate({"margin-left": "0"}, 650);
    $('.clock-arcs').hide();
    calendarSelectedDays.forEach(function(id) {
      addClockToView(id);
    });
    $('.clocks').fadeIn(547);

    return false;
  });

  // BACK TO CALENDAR
  $('#back-to-calendar').click(function() {
    $('.clocks').fadeOut(547);
    $(".person-wrapper").animate({"margin-left": "24.5%"}, 650);
    return false;
  });

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
  });

  // press escape closes all graphics
  $(document).keydown(function(event) {
    if (event.which === 27) {
      $(".slice-info").remove();
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
});
