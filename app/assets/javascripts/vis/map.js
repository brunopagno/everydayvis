var map;
var markers = [];

// MAP
function initMap() {
  // var max_activity = d3.max(data, function(d) { return d.activity } );
  // var steps_color = d3.scale.linear().domain([0, max_activity / 2, max_activity]).range(["#ff1a1a", "#ffff1a", "#1aff1a"]);

  var lalo = $('.map').data('map');
  var meanLalo = {lat: 0, lng: 0};
  for (var i = 0; i < lalo.length; i++) {
    meanLalo.lat += parseFloat(lalo[i].lat);
    meanLalo.lng += parseFloat(lalo[i].lng);
  }
  meanLalo.lat /= lalo.length;
  meanLalo.lng /= lalo.length;

  var map = new google.maps.Map(document.getElementsByClassName('map')[0], {
    center: meanLalo,
    zoom: 3
  });

  for (var i = 0; i < lalo.length; i++) {
    var marker = new google.maps.Marker({
      position: {lat: parseFloat(lalo[i].lat), lng: parseFloat(lalo[i].lng)},
      map: map,
      title: 'Marker',
      icon: {
        path: google.maps.SymbolPath.CIRCLE,
        scale: 8
      },
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
