Tail = Meteor.npmRequire('tail').Tail
tail = new Tail "/Users/fazi/dev/arena-pl/log/development.log" 

stripAnsi = Meteor.npmRequire 'strip-ansi'

tail.on "line", (line) ->
  Parser.match stripAnsi(line)
  
tail.on "error", (error) ->
  console.log error
  