$(document).ready(function() {
  // VIEW CLOCKS
  $('#view-clocks').click(function() {
    if ($(".calendar-box:checked").length === 0) {
      alert("Plsease select at least one day.");
      return false;
    }
    $('.calendar').fadeOut(547);
    $('.clocks').fadeIn(547);
    return false;
  });

  // SELECT ALL
  $('.calendar-select-all').change(function() {
    var check = $(this).is(":checked");
    $('.calendar-box').each(function() {
      this.checked = check;
    });
  });
});
