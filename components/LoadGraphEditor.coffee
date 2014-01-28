noflo = require 'noflo'

class LoadGraphEditor extends noflo.Component
  constructor: ->
    @graph = null
    @container = null

    @inPorts =
      graph: new noflo.Port 'object'
      container: new noflo.Port 'object'
    @outPorts =
      graph: new noflo.Port 'object'
      editor: new noflo.ArrayPort 'object'

    @inPorts.graph.on 'data', (@graph) =>
      do @loadEditor
    @inPorts.container.on 'data', (@container) =>
      do @loadEditor

  loadEditor: ->
    return unless @graph and @container

    @container.innerHTML = ''
    editor = document.createElement 'the-graph-editor'
    @setSize editor
    @container.appendChild editor

    editorReady = =>
      @outPorts.editor.send editor
      @outPorts.editor.disconnect()
      editor.removeEventListener 'graph', editorReady, false
    if @outPorts.editor.isAttached()
      @outPorts.editor.connect()
      editor.addEventListener 'graph', editorReady, false
    editor.graph = @graph

    window.addEventListener 'resize', =>
      @setSize editor

    if @outPorts.graph.isAttached()
      @outPorts.graph.send @graph
      @outPorts.graph.disconnect()

    # Reset state
    @graph = null
    @runtime = null

  subscribeEditorReady: =>

  setSize: (editor) ->
    editor.width = window.innerWidth
    editor.height = window.innerHeight

exports.getComponent = -> new LoadGraphEditor
