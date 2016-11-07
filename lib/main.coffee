ReactCosmosView = null

isReactCosmosView = (object) ->
  ReactCosmosView ?= require './react-cosmos-view'
  object instanceof ReactCosmosView

module.exports =
  activate: ->
    atom.commands.add 'atom-workspace',
      'react-cosmos:toggle': =>
        @toggle()

    atom.workspace.addOpener (uriToOpen) =>
      [protocol, path] = uriToOpen.split('://')
      return unless protocol is 'react-cosmos'

      path = decodeURI(path)
      @createReactCosmosView(editorId: path.substring(7))

  createReactCosmosView: (state) ->
    ReactCosmosView ?= require './react-cosmos-view'
    new ReactCosmosView(state)

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    @addPreviewForEditor(editor) unless @removePreviewForEditor(editor)

  uriForEditor: (editor) ->
    "react-cosmos://editor/#{editor.id}"

  removePreviewForEditor: (editor) ->
    uri = @uriForEditor(editor)
    previewPane = atom.workspace.paneForURI(uri)
    if previewPane?
      previewPane.destroyItem(previewPane.itemForURI(uri))
      true
    else
      false

  addPreviewForEditor: (editor) ->
    uri = @uriForEditor(editor)
    previousActivePane = atom.workspace.getActivePane()
    options =
      searchAllPanes: true
      split: 'right'
    atom.workspace.open(uri, options).then (reactCosmosView) ->
      if isReactCosmosView(reactCosmosView)
        previousActivePane.activate()
