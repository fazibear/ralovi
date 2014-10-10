class RailsLogParser  

  regexps = [
    # start request
    regexp: /^Started ([A-Z]+) "([^"]+)" for ([0-9.]+) at (.+)$/,
    callback: (match) ->
      @data['time'] = new Date(match[4])
      @data['method'] = match[1]
      @data['path'] = match[2]
      @data['ip'] = match[3]
  ,  
    #end request
    regexp: /^Completed ([0-9]+) OK in ([0-9.ms]+) \((.+)\)$/,
    callback: (match) ->
      @data['return_code'] = match[1]
      @data['duration'] = match[2]
      
      @callback.call(this, @data)
      @data = {}
  ,  
    #processing data
    regexp: /^Processing by (\S+)#(\S+) as (\S+)$/,
    callback: (match) ->
      @data['controller'] = match[1]
      @data['controller_method'] = match[2]
      @data['response_format'] = match[3]
  ,
    #parameteres
    regexp: /^  Parameters: (.+)$/
    callback: (match) ->
      params = match[1]
      params = params.replace(/\=\>/g, ':')
      @data['parameters'] = JSON.parse(params)
      #@data['formatted_parameters'] = JSON.stringify(params, null, 2)
  ,
    #sql queries
    regexp: /^  (\S+) Load \(([0-9.ms]+)\) (.+)$/
    callback: (match) ->
      @data['sql_queries'] = [] unless @data['sql_queries']
      @data['sql_queries'].push
        model: match[1]
        duration: match[2]
        query: match[3]
        #formatted_query: sqlParser.parser.parse(sqlParser.lexer.tokenize(match[3])).toString()
  ,
    #solr queries
    regexp: /^  SOLR Request \(([0-9.ms]+)\) (.+)$/
    callback: (match) ->
      @data['solr_queries'] = [] unless @data['solr_queries']
      @data['solr_queries'].push
        duration: match[1]
        query: match[2]
  ,
    #templates
    regexp: /^  Rendered (\S+) \(([0-9.ms]+)\)$/
    callback: (match) ->
      @data['templates'] = [] unless @data['templates']
      @data['templates'].push
        template_path: match[1]
        duration: match[2]
        
  ,
    #deface
    regexp: /^Deface: (.+)$/
    callback: (match) ->
      @data['deface_messages'] = [] unless @data['deface_messages']
      @data['deface_messages'].push
        message: match[1]
  ]
  
  constructor: (callback) ->
    @data = {}
    if callback
      @callback = callback
    else
      @callback = (data) ->
        console.log(@data)
    
  match: (line) ->
    _.each regexps, (r) ->
      match = line.match(r['regexp']) 
      r['callback'].call(this, match) if match
    , this
    

@Parser = new RailsLogParser Meteor.bindEnvironment (request) ->
  Requests.insert request