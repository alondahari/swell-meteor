Template.location.onCreated ->
  @selectedContinent = new ReactiveVar 'Europe'
  @selectedRegion = new ReactiveVar 'Azores'
  GoogleMaps.load()
  @subscribe 'spots'

Template.location.helpers
  mapOptions: ->
    if GoogleMaps.loaded()
      zoom: 10
      mapTypeId: google.maps.MapTypeId.HYBRID
      center: new google.maps.LatLng(-37.8136, 144.9631)

  continents: ->
    _.uniq Spots.find().fetch(), 'continent'

  regions: ->
    selectedContinent = Template.instance().selectedContinent.get()
    _.uniq Spots.find({continent: selectedContinent}).fetch(), 'region'

  spots: ->
    selectedRegion = Template.instance().selectedRegion.get()
    Spots.find {region: selectedRegion}

Template.location.events
  'change .location-select': (e) ->
    selectLevel = $(e.target).attr('name')
    if selectLevel is 'continents'
      Template.instance().selectedContinent.set $(e.target).val()
      Template.instance().selectedRegion.set Spots.findOne({continent: $(e.target).val()}).region
    else if selectLevel is 'regions'
      Template.instance().selectedRegion.set $(e.target).val()
