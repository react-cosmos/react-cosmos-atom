{ScrollView} = require 'atom-space-pen-views'

module.exports =
class ReactCosmosView extends ScrollView
  @content: ->
    @div class: 'react-cosmos', tabindex: -1

  constructor: ({@editorId}) ->
    super

  attached: ->
    @editor = @editorForId(@editorId)
    # TODO: Comunicate error when editor isn't found
    @renderCosmosIframe(@getCosmosUrl()) if @editor

  editorForId: (editorId) ->
    for editor in atom.workspace.getTextEditors()
      return editor if editor.id?.toString() is editorId.toString()
    null

  getCosmosUrl: ->
    file = @editor.buffer.file
    matches = file.path.match(/^(.+)\/(fixtures|__fixtures__)\/(.+)\/(.+)\.(js|json)/)
    serverHost = atom.config.get('react-cosmos.serverHost')
    serverPort = atom.config.get('react-cosmos.serverPort')
    showFixtureEditor = atom.config.get('react-cosmos.showFixtureEditor')
    componentName = matches[3]
    fixtureName = matches[4]
    "http://#{serverHost}:#{serverPort}/?component=#{componentName}&fixture=#{fixtureName}&fullScreen=true&editor=#{showFixtureEditor}"

  renderCosmosIframe: (cosmosUrl) ->
    template = document.createElement('template')
    template.innerHTML = "<iframe src=\"#{cosmosUrl}\" width=\"100%\" height=\"100%\" />"
    domFragment = template.content.cloneNode(true)
    @html(domFragment)

  getTitle: ->
    "React Cosmos Preview"

  getURI: ->
    "react-cosmos://editor/#{@editorId}"
