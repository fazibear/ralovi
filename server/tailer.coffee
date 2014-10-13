class Tailer
  
  Tail = Meteor.npmRequire('tail').Tail
  StripAnsi = Meteor.npmRequire 'strip-ansi'
  
  tail: (filename) ->
    @filename = filename
    @tailer = new Tail @filename
    
    @tailer.on "line", (line) ->
      Parser.match StripAnsi(line)

    @tailer.on "error", (error) ->
      console.log error

@tailer = new Tailer()

Meteor.methods
  set_tailer: (filename) ->
    tailer.tail(filename)
    
  get_tailer: ->
    tailer.filename
  