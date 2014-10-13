Handlebars.registerHelper 'json_formatter', (object) ->
  JSON.stringify(object, null, 2)

Template.request_details.request = ->
  Requests.findOne(Session.get('request_id'))
