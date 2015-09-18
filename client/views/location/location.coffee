Template.location.onCreated ->
  @selectedContinent = new ReactiveVar 'Europe'
  @selectedRegion = new ReactiveVar 'Azores'
  # @selectedSpot = new ReactiveVar null
  GoogleMaps.load()
  @subscribe 'spots'

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
    selectedContinent = Template.instance().selectedContinent.get()
    _.uniq Spots.find({continent: selectedContinent}).fetch(), 'region'

  spots: ->
    selectedRegion = Template.instance().selectedRegion.get()
    Spots.find({region: selectedRegion}).fetch()

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
      spot = Spots.findOne {region: $target.val()}
    else if selectLevel is 'spots'
      spot = Spots.findOne {_id: $target.val()}
    centerMap spot

# Helperz
# -------
centerMap = (spot)->
  GoogleMaps.maps.surfLocations?.instance.setCenter {
    lat: spot.lat
    lng: spot.lng
  }
