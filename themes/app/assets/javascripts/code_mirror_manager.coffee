#= require codemirror/codemirror
#= require codemirror/util/simple-hint
#= require codemirror/util/dialog
#= require codemirror/util/searchcursor
#= require codemirror/util/search
#= require codemirror/util/javascript-hint
#= require codemirror/util/overlay
#= require codemirror/util/formatting
#= require codemirror/util/closetag
#= require codemirror/mode/css/css
#= require codemirror/mode/xml/xml
#= require codemirror/mode/liquid/liquid
#= require codemirror/mode/javascript/javascript
#= require codemirror/mode/yaml/yaml
#= require codemirror/mode/htmlmixed/htmlmixed
#= require codemirror/mode/htmlembedded/htmlembedded
# require codemirror/mode/scheme/scheme

#= require_self

class @CodeMirrorManager
  constructor: (@text_area_id, @mode) ->
    @editor = CodeMirror.fromTextArea(document.getElementById(@text_area_id),
      lineNumbers: true
      extraKeys:
        F11: (cm) ->
          setFullScreen cm, not isFullScreen(cm)
        Esc: (cm) ->
          setFullScreen cm, false  if isFullScreen(cm)
        "Ctrl-Space": "autocomplete"
      mode: @mode
      tabMode: "indent"
      autoCloseTags: true
    )
    #@editor.on "change", =>
      #$('#file_content').val(CodeMirrorManager.editor.getValue())
      #clearTimeout delay
      #delay = setTimeout(@updatePreview, 300)

    #setTimeout @updatePreview, 300

    CodeMirror.commands.autocomplete = (cm) ->
      CodeMirror.simpleHint cm, CodeMirror.javascriptHint

    CodeMirror.on window, "resize", ->
      showing = document.body.getElementsByClassName("CodeMirror-fullscreen")[0]
      return  unless showing
      showing.CodeMirror.getWrapperElement().style.height = winHeight() + "px"

    CodeMirrorManager.editor = @editor


#TODO auto-detect the language
# function looksLikeScheme(code) {
#   return !/^\s*\(\s*function\b/.test(code) && /^\s*[;\(]/.test(code);
# }
  updatePreview: =>
    #TODO auto-detect the language
    # @editor.setOption("mode", looksLikeScheme(@editor.getValue()) ? "scheme" : "javascript");
    previewFrame = document.getElementById('preview')
    preview = previewFrame.contentDocument or previewFrame.contentWindow.document
    preview.open()
    preview.write @editor.getValue()
    preview.close()

  @selectTheme: ->
    input = document.getElementById('select')
    theme = input.options[input.selectedIndex].innerHTML
    @editor.setOption "theme", theme
    choice = document.location.search and decodeURIComponent(document.location.search.slice(1))
    if choice
      input.value = choice
      @editor.setOption "theme", choice

  @getSelectedRange: ->
    from: @editor.getCursor(true)
    to: @editor.getCursor(false)

  @autoFormatSelection: ->
    range = @getSelectedRange()
    @editor.autoFormatRange range.from, range.to

  @commentSelection: (isComment) ->
    range = @getSelectedRange()
    @editor.commentRange isComment, range.from, range.to

  isFullScreen: (cm) ->
    /\bCodeMirror-fullscreen\b/.test cm.getWrapperElement().className

  winHeight: ->
    window.innerHeight or (document.documentElement or document.body).clientHeight

  @setFullScreen: (cm, full) ->
    wrap = cm.getWrapperElement()
    if full
      wrap.className += " CodeMirror-fullscreen"
      wrap.style.height = winHeight() + "px"
      document.documentElement.style.overflow = "hidden"
    else
      wrap.className = wrap.className.replace(" CodeMirror-fullscreen", "")
      wrap.style.height = ""
      document.documentElement.style.overflow = ""
    cm.refresh()


