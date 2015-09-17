Template.login.onCreated ->
  @autorun ->
    if Meteor.userId()
      Router.go 'location'

Template.login.events
  'click .button-signup': ->
    Accounts.createUser
      email: $('input[name=email]').val()
      password: $('input[name=password]').val()

  'click .button-login': ->
    Meteor.loginWithPassword $('input[name=email]').val(), $('input[name=password]').val()
