$(document).ready(function() {
  // VIEW CLOCKS
  $('#view-clocks').click(function() {
    if ($(".calendar-box:checked").length === 0) {
      alert("Plsease select at least one day.");
      return false;
    }
    $('.calendar').fadeOut(547);
    $('.clocks').fadeIn(547);

    console.log("selected => " + calendarSelectedDays);
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
});
