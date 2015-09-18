@Spots = new Mongo.Collection 'spots'

if Meteor.isServer
  Meteor.publish 'spots', (query={}, options={}) ->
    Spots.find query, options

  Spots.deny
    insert: -> true
    update: -> true
    remove: -> true
