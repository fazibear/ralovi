Template.requests_list.requests = ->
  Requests.find {},
    sort: 
      time: -1
    
Template.requests_list.active = ->
  'active' if Session.get('request_id') == this._id

Template.requests_list.events
  'click a': (event) ->
    Session.set('request_id', event.currentTarget.id)
  