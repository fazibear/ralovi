Template.header.events
  'click #tail': ->
    filename = document.getElementById("filename").value
    Meteor.call('set_tailer', filename)

Meteor.call 'get_tailer', (err, data) ->
  document.getElementById("filename").value = data if data