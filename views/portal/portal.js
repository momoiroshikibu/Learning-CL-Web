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
            var marker = new google.maps.Marker({
                id: location.id,
                position: {
                    lat: location.lat,
                    lng: location.lng
                },
                map: map,
                title: 'Hello World!'
            });
            marker.addListener('click', () => {
                fetchLocation(marker.id).then((location) => {
                    var infowindow = new google.maps.InfoWindow({
                        content: JSON.stringify(location)
                    });
                    infowindow.open(map, marker);
                })
            })
        })
    })
}


function fetchLocation(locationId) {
    return new Promise((resolve, reject) => {
        fetch(`/locations/${locationId}`, {
            method: 'GET',
            credentials: 'same-origin'
        }).then((response) => {
            return response.json();
        }).then((location) => {
            resolve(location);
        }).catch((error) => {
            reject(error);
        })
    })
}
