function initializeMap() {
    var map = createMap(document.getElementById('map'));
    setMarker(map);
}

function createMap(mapElement) {
    return new google.maps.Map(mapElement, {
        center: {
            lat: 43.7706,
            lng: 142.364
        },
        zoom: 7
    });
}

function setMarker(map) {
    fetch('/locations', {
        method: 'GET',
        credentials: 'same-origin'
    }).then((response) => {
        return response.json();
    }).then((locations) => {
        console.log(locations);
        locations.forEach((location) => {
            console.log({
                lat: location[3],
                lng: location[5]
            })
            var marker = new google.maps.Marker({
                position: {
                    lat: location[3],
                    lng: location[5]
                },
                map: map,
                title: 'Hello World!'
            });
        })
    })
}
