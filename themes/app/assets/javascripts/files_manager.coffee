class @FilesManager
  constructor: ->
    $(".mmenu input").click ->
      switch @id
        when "add_default", "add_folder"
          $("#jsTree").jstree "create", null, "last",
            attr:
              rel: @id.toString().replace("add_", "")
        when "search"
          $("#jsTree").jstree "search", document.getElementById("text").value
        when "refresh"
          $("#code").html('')
          $('#jsTree').jstree('refresh',-1);
        else
          $("#jsTree").jstree @id

  @initHandlers = ->
    $("#file_submit").click ->
      $("#form_for_file").submit()

    $("#form_for_file").submit ->
      $('#file_content').val(CodeMirrorManager.editor.getValue())
      FilesManager.saveFile()
      false


  @saveFile = ->
    $.ajax
      url: "/refinery/themes/editor/save_file"
      type: "POST"
      beforeSend: (request) ->
        $("#spinner").show()
        $("#file_submit").hide()

      data: $.param($("#form_for_file").serializeArray())
      dataType: "html"
      success: (D) ->
        $("#code").html(D)
        FilesManager.initHandlers()
        $.jGrowl "File successfully saved!",
          life: 5000