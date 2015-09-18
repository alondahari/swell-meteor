Template.location.onCreated ->
  @selectedContinent = new ReactiveVar 'Europe'
  @selectedRegion = new ReactiveVar 'Azores'
  GoogleMaps.load()
  @subscribe 'continents'
  @autorun =>
    regions = @subscribe 'regions', @selectedContinent.get()
    @subscribe 'spots', @selectedRegion.get(), =>
      onReady: centerMap Spots.findOne {region: @selectedRegion.get()}

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
