var map;
var markers = [];

// MAP
function initMap() {
  var lalo = $('.map').data('map');
  var meanLalo = {lat: 0, lng: 0};
  for (var i = 0; i < lalo.length; i++) {
    meanLalo.lat += parseInt(lalo[i].lat);
    meanLalo.lng += parseInt(lalo[i].lng);
  }
  meanLalo.lat /= lalo.length;
  meanLalo.lng /= lalo.length;

  var map = new google.maps.Map(document.getElementsByClassName('map')[0], {
    center: meanLalo,
    zoom: 3
  });

  for (var i = 0; i < lalo.length; i++) {
    var marker = new google.maps.Marker({
      position: {lat: parseInt(lalo[i].lat), lng: parseInt(lalo[i].lng)},
      map: map,
      title: 'Marker',
      dayid: lalo[i].date
    });
    markers.push(marker);
  }
}

function updateMapMarkers() {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setVisible(false);
  }
  for (var i = 0; i < markers.length; i++) {
    for (var j = 0; j < calendarSelectedDays.length; j++) {
      if (calendarSelectedDays[j] == markers[i].dayid) {
        // WORKS but does not work =X
        markers[i].setVisible(true);
      }
    }
  }
}
