Handlebars.registerHelper 'json_formatter', (object) ->
  JSON.stringify(object, null, 2)

Handlebars.registerHelper 'sql_formatter', (sql) ->
  tokens = sqlParser.lexer.tokenize(sql)
  console.log tokens
  sqlParser.parser.parse(sqlParser.lexer.tokenize(sql)).toString()

Template.request_details.request = ->
  Requests.findOne(Session.get('request_id'))