@Spots = new Mongo.Collection 'spots'

if Meteor.isServer
  Meteor.publish 'continents', ->
    continentSpotsIds = _.pluck _.uniq(Spots.find().fetch(), 'continent'), '_id'
    Spots.find {_id: {$in: continentSpotsIds}}
  Meteor.publish 'regionsInContinent', (continent) ->
    regionSpotsIds = _.pluck _.uniq(Spots.find({continent: continent}).fetch(), 'region'), '_id'
    Spots.find {_id: {$in: regionSpotsIds}}
  Meteor.publish 'spotsInRegion', (region) ->
    spotsIds = _.pluck _.uniq(Spots.find({region: region}).fetch(), 'spot'), '_id'
    Spots.find {_id: {$in: spotsIds}}


  Spots.deny
    insert: -> true
    update: -> true
    remove: -> true
