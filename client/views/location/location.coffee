Template.location.onCreated ->
  @selectedContinent = new ReactiveVar 'Europe'
  @selectedRegion = new ReactiveVar 'Azores'
  @mapReady = new ReactiveVar false
  GoogleMaps.load()
  GoogleMaps.ready 'surfLocations', =>
    @mapReady.set true
  @subscribe 'continents'
  @autorun =>
    regions = @subscribe 'regionsInContinent', @selectedContinent.get()
    @subscribe 'spotsInRegion', @selectedRegion.get(), =>
      centerMap Spots.findOne {region: @selectedRegion.get()}

    if @subscriptionsReady() and @mapReady.get()
      spots = Spots.find({region: @selectedRegion.get()}).fetch()
      # remove all markers from other regions
      _.each @markers, (marker) ->
        marker.setMap(null)
      @markers = []
      # add all markers of the current region
      _.each spots, (spot) =>
        spotCoords = new google.maps.LatLng spot.lat, spot.lng
        marker = new google.maps.Marker
          position: spotCoords
          map: GoogleMaps.maps.surfLocations.instance
          title: spot.spot
          id: spot._id
          icon: '/surf-marker.svg'

        google.maps.event.addListener marker, 'click', ->
          $('.location-select[name=spots]').val @id
          centerMap {lat: @position.H, lng: @position.L}

        @markers.push marker


Template.location.helpers
  mapOptions: ->
    if GoogleMaps.loaded()
      zoom: 10
      mapTypeId: google.maps.MapTypeId.HYBRID
      # HACK: default the map on the first spot in the DB. Not good if the db changes.
      center: new google.maps.LatLng(39.42, -31.26)

  continents: ->
    _.uniq Spots.find().fetch(), 'continent'

  regions: ->
    _.uniq Spots.find({continent: Template.instance().selectedContinent.get()}).fetch(), 'region'

  spots: ->
    Spots.find({region: Template.instance().selectedRegion.get()})

Template.location.events
  'change .location-select': (e) ->
    $target = $(e.target)
    selectLevel = $target.attr('name')
    spot = null
    if selectLevel is 'continents'
      Template.instance().selectedContinent.set $target.val()
      spot = Spots.findOne {continent: $target.val()}
      Template.instance().selectedRegion.set spot.region
    else if selectLevel is 'regions'
      Template.instance().selectedRegion.set $target.val()
    else if selectLevel is 'spots'
      centerMap Spots.findOne {_id: $target.val()}

# Helperz
# -------
centerMap = (spot) ->
  GoogleMaps.maps.surfLocations?.instance.setCenter
    lat: spot.lat
    lng: spot.lng
