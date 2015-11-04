$(document).ready(function() {
  $('#view-clocks').click(function() {
    if ($(".calendar-box:checked").length === 0) {
      alert("Plsease select at least one day.");
      return false;
    }
    $('.calendar').fadeOut(547);
    $('.clocks').fadeIn(547);
    return false;
  });
});
