import mapboxgl from 'mapbox-gl';
import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css';

const StationMap = {
  createMap() {
    mapboxgl.accessToken = 'pk.eyJ1IjoiY2hyaXN2aWRpYyIsImEiOiJjbDlvanA1Z2gwMzEwM25yMGtsOTIybmI1In0.fWAFVRe_dNP4qRNWLMbkeg';

    var map = new mapboxgl.Map({
      container: 'station-map',
      style: 'mapbox://styles/mapbox/outdoors-v11', // stylesheet location
      center: [-105.2705, 40.0150],
      zoom: 8
    });
    var geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl,
      marker: false,
      flyTo: false,
      countries: "US"
    });

    const view = this;


    return map
  },
  mounted() {
    this.map = this.createMap()
    const map = this.map
    doc = document.getElementById('station-map')
    let solo_lng = doc.getAttribute('phx-value-lng')
    let solo_lat = doc.getAttribute('phx-value-lat')
    let precip = doc.getAttribute('phx-value-precip')
    const view = this;
    this.map.on('load', function () {
      if (solo_lng != null){
        const center = new mapboxgl.LngLat(solo_lng,solo_lat);
        map.setCenter(center);
        map.addLayer({
          id: 'placeHolderPoint',
          type: 'symbol',
          source: {
            type: 'geojson',
            data: {
              type: 'FeatureCollection',
              features: [
                {
                  type: 'Feature',
                  geometry: {
                    type: 'Point',
                    coordinates: [solo_lng,solo_lat]
                  },
                  properties: {
                    icon: 'communications-tower',
                    title: (Math.round(solo_lng * 10000) / 10000).toString() + ', ' + (Math.round(solo_lat * 10000) / 10000).toString()
                  }
                }
              ]
            },
            tolerance: 0.00001
          },
          layout: {
            'icon-image': '{icon}-15',
            'icon-size': 1.25,
            'text-field': '{title}',
            'text-font': ['Open Sans Semibold', 'Arial Unicode MS Bold'],
            'text-offset': [0, 0.6],
            'text-anchor': 'top',
            'icon-allow-overlap': true,
            'text-allow-overlap': true
          }
        });
        view.pushEvent("assign_station")
      }
      map.on('click', function (e) {
        const mapLayer = map.getLayer('placeHolderPoint')

        if (typeof mapLayer !== 'undefined') {
          // Remove map layer & source.
          map
            .removeLayer('placeHolderPoint')
            .removeSource('placeHolderPoint')
        }
        map.addLayer({
          id: 'placeHolderPoint',
          type: 'symbol',
          source: {
            type: 'geojson',
            data: {
              type: 'FeatureCollection',
              features: [
                {
                  type: 'Feature',
                  geometry: {
                    type: 'Point',
                    coordinates: [e.lngLat.lng, e.lngLat.lat]
                  },
                  properties: {
                    icon: 'marker',
                    title: (Math.round(e.lngLat.lat * 10000) / 10000).toString() + ', ' + (Math.round(e.lngLat.lng * 10000) / 10000).toString()
                  }
                }
              ]
            },
            tolerance: 0.00001
          },
          layout: {
            'icon-image': '{icon}-15',
            'icon-size': 1.25,
            'text-field': '{title}',
            'text-font': ['Open Sans Semibold', 'Arial Unicode MS Bold'],
            'text-offset': [0, 0.6],
            'text-anchor': 'top',
            'icon-allow-overlap': true,
            'text-allow-overlap': true
          }
        });
        view.pushEvent("selected_location", { location: e.lngLat })
      });
    });
    this.handleEvent("update_station" , data => {
      let lat = data.lat
      let lng = data.lng
      const center = new mapboxgl.LngLat(lat,lng);
      this.map.setCenter(center);
      this.map.on('load', function () {
        map.addLayer({
          id: 'placeHolderPoint',
          type: 'symbol',
          source: {
            type: 'geojson',
            data: {
              type: 'FeatureCollection',
              features: [
                {
                  type: 'Feature',
                  geometry: {
                    type: 'Point',
                    coordinates: [lat,lng]
                  },
                  properties: {
                    icon: 'communications-tower',
                    title: (Math.round(lat * 10000) / 10000).toString() + ', ' + (Math.round(lng * 10000) / 10000).toString()
                  }
                }
              ]
            },
            tolerance: 0.00001
          },
          layout: {
            'icon-image': '{icon}-15',
            'icon-size': 1.25,
            'text-field': '{title}',
            'text-font': ['Open Sans Semibold', 'Arial Unicode MS Bold'],
            'text-offset': [0, 0.6],
            'text-anchor': 'top',
            'icon-allow-overlap': true,
            'text-allow-overlap': true
          }
        });
        view.pushEvent("assign_station")
      });
    });
    this.handleEvent("clicked", data => {
      let lat = data.station_info.lat
      let lng = data.station_info.lng
      const towerLayer = map.getLayer("currentStationPoint")
      if (typeof towerLayer !== 'undefined') {
        map
          .removeLayer("currentStationPoint")
          .removeSource("currentStationPoint")
      }


      this.map.addLayer({
            id: "currentStationPoint",
            type: 'symbol',
            source: {
              type: 'geojson',
              data: {
                type: 'FeatureCollection',
                features: [
                  {
                    type: 'Feature',
                    geometry: {
                      type: 'Point',
                      coordinates: [lng, lat]
                    },
                    properties: {
                      icon: 'communications-tower',
                      title: (Math.round(lng * 10000) / 10000).toString() + ', ' + (Math.round(lat * 10000) / 10000).toString()
                    }
                  }
                ]
              },
              tolerance: 0.00001
            },
            layout: {
              'icon-image': '{icon}-15',
              'icon-size': 1.25,
              'text-field': '{title}',
              'text-font': ['Open Sans Semibold', 'Arial Unicode MS Bold'],
              'text-offset': [0, 0.6],
              'text-anchor': 'top',
              'icon-allow-overlap': true,
              'text-allow-overlap': true
            }
          });
        view.pushEvent("assign_data", { lat: data.station_info.lat, lng: data.station_info.lng,station_name: data.station_name, triplet: data.triplet})
    }
    )
  },
  updated() {
    this.map = this.createMap()
    const map = this.map
    const view = this;
      map.on('click', function (e) {
        const mapLayer = map.getLayer('placeHolderPoint')
        if (typeof mapLayer !== 'undefined') {
          map
            .removeLayer('placeHolderPoint')
            .removeSource('placeHolderPoint')
        }
        map.addLayer({
          id: 'placeHolderPoint',
          type: 'symbol',
          source: {
            type: 'geojson',
            data: {
              type: 'FeatureCollection',
              features: [
                {
                  type: 'Feature',
                  geometry: {
                    type: 'Point',
                    coordinates: [e.lngLat.lng, e.lngLat.lat]
                  },
                  properties: {
                    icon: 'marker',
                    title: (Math.round(e.lngLat.lat * 10000) / 10000).toString() + ', ' + (Math.round(e.lngLat.lng * 10000) / 10000).toString()
                  }
                }
              ]
            },
            tolerance: 0.00001
          },
          layout: {
            'icon-image': '{icon}-15',
            'icon-size': 1.25,
            'text-field': '{title}',
            'text-font': ['Open Sans Semibold', 'Arial Unicode MS Bold'],
            'text-offset': [0, 0.6],
            'text-anchor': 'top',
            'icon-allow-overlap': true,
            'text-allow-overlap': true
          }
        });
        view.pushEvent("clear_location", { location: e.lngLat })
        view.pushEvent("selected_location", { location: e.lngLat })
      });
    // });
  }
}

export default StationMap