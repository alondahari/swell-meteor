# Blaze helpers
#==============

# Takes a string like "Happy Days" and returns happy-days (not true)
UI.registerHelper 'lengthGreaterThan', (array, len=0) ->
  array.length > len

# usage: {{#if equals 'fruit' 'pineapple'}}...{{/if}}
UI.registerHelper 'equals', (a, b) ->
  a is b

# usage: {{#if not 'fruit'}}...{{/if}}
UI.registerHelper 'not', (a) ->
  not a

# check that a value is explicitly false and not undefined or null
# usage: {{#if not 'fruit'}}...{{/if}}
UI.registerHelper 'isFalse', (a) ->
  a is false

# usage: {{#if both 'fruit' 'pinapple'}}...{{/if}}
UI.registerHelper 'both', (a, b) ->
  a and b

# usage: {{#if either 'fruit' 'pinapple'}}...{{/if}}
UI.registerHelper 'or', (a, b) ->
  a or b

# usage: {{#if neither 'fruit' 'pinapple'}}...{{/if}}
UI.registerHelper 'neither', (a, b) ->
  not a and not b

UI.registerHelper 'count', (collection) ->
  collection.count()

UI.registerHelper 'escape', (str) ->
  encodeURIComponent(str)


UI.registerHelper 'log', (value) ->
  console.log value

UI.registerHelper 'ifelse', (condition, returnValue, elseValue) ->
  if condition
    returnValue
  else
    elseValue
