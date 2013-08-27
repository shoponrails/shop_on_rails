#= require jstree/jquery.jstree

class @JstreeManager
  constructor: ->
    @tree = $("#jsTree")
    @buildTree()
    @tree

  uploadFile = (obj) ->
    iframe = $("<iframe id='dialog_iframe' frameborder='0' marginheight='0' marginwidth='0' border='0'></iframe>")
    iframe.corner "8px"  unless $.browser.msie
    iframe.dialog
      title: "Upload New File"
      modal: true
      resizable: false
      autoOpen: true
      open: onOpenDialog
      close: onCloseDialog
    iframe.attr "src", "/refinery/themes/editor/upload_file?app_dialog=true&dialog=true&path="+obj.attr("fullpath")

  buildTree: ->
    @tree.jstree(
      plugins: ["themes", "json_data", "ui", "crrm", "cookies", "dnd", "search", "types", "contextmenu"]
      contextmenu:
        items:
          upload:
            label: "Upload File"
            action: (obj) -> uploadFile obj
            _class: "upload_file"
          create:
            separator_before: false
            separator_after: true
            label: "Create"
            action: false
            submenu:
              create_file:
                seperator_before: false
                seperator_after: false
                label: "File"
                action: (obj) -> this.create(obj, "last", {"attr" : {"rel" : "default"}})
              create_folder:
                seperator_before: false
                seperator_after: false
                label: "Folder"
                action: (obj) -> this.create(obj, "last", {"attr" : { "rel" : "folder"}})
      themes:
        url: "/assets/jstree/themes/apple/style.css"
      json_data:
        ajax:
          url: "/refinery/themes/editor/list"
          type: "POST"
          data: (n) ->
            fullpath: (if n.attr then n.attr("fullpath") else "")
      search:
        ajax:
          url: "/refinery/themes/editor/search"
          data: (str) ->
            search_str: str
      types:
        max_depth: -2
        max_children: -2
        valid_children: ["drive"]
        types:
          default:
            valid_children: "none"
            icon:
              image: "/assets/jstree/file.png"
          folder:
            valid_children: ["default", "folder"]
            icon:
              image: "/assets/jstree/folder.png"
          drive:
            valid_children: ["default", "folder"]
            icon:
              image: "/assets/jstree/root.png"
            start_drag: false
            move_node: false
            delete_node: false
            remove: false
    ).bind("select_node.jstree", (e, data) ->
      if data.rslt.obj.attr("rel") is "default"
        $.ajax
          async: false
          type: "POST"
          url: "/refinery/themes/editor/file"
          beforeSend: (request) ->
            return true
          data:
            fullpath: data.rslt.obj.attr("fullpath")
          success: (result) ->
            if result
              $("#code").html result
              FilesManager.initHandlers()
              $.jGrowl data.rslt.obj.attr("fullpath") + " was loaded.",
                life: 5000
            else
              $.jGrowl result.notice,
                life: 5000

    ).bind("create.jstree", (e, data) ->
      $.post "/refinery/themes/editor/add",
        fullpath: data.rslt.parent.attr("fullpath")
        title: data.rslt.name
        type: data.rslt.obj.attr("rel"),
        (result) ->
          if result.status
            $(data.rslt.obj).attr "fullpath", result.fullpath
            $("#jsTree").jstree "rename_node", $(data.rslt.obj), result.node_name
            $.jGrowl result.notice,
              life: 5000
          else
            $.jstree.rollback data.rlbk
            $.jGrowl result.notice,
              life: 5000

    ).bind("remove.jstree", (e, data) ->
      if (confirm("Are you sure?"))
        $.ajax
          async: false
          type: "POST"
          url: "/refinery/themes/editor/delete"
          data:
            fullpath: data.rslt.obj.attr("fullpath")
            type: data.rslt.obj.attr("rel")

          success: (result) ->
            if result.status
              data.inst.refresh()
              $.jGrowl result.notice,
                life: 5000
            else
              $.jstree.rollback data.rlbk
              $.jGrowl result.notice,
                life: 5000
      else
        $.jstree.rollback data.rlbk

    ).bind("rename.jstree", (e, data) ->
      $.ajax
        async: true
        type: "POST"
        url: "/refinery/themes/editor/rename"
        data:
          fullpath: data.rslt.obj.attr("fullpath")
          new_name: data.rslt.new_name
          type: data.rslt.obj.attr("rel")

        success: (result) ->
          if result.status
            $(data.rslt.obj).attr "fullpath", result.fullpath
            $("#jsTree").jstree "rename_node", $(data.rslt.obj), result.node_name
            $.jGrowl result.notice,
              life: 5000

          else
            $.jstree.rollback data.rlbk
            $.jGrowl result.notice,
              life: 5000

    ).bind "move_node.jstree", (e, data) ->
      data.rslt.o.each (i) ->
        $.ajax
          async: false
          type: "POST"
          url: "/refinery/themes/editor/move"
          data:
            fullpath: $(this).attr("fullpath")
            ref: data.rslt.np.attr("fullpath")
            title: data.rslt.name
            copy: (if data.rslt.cy then 1 else 0)

          success: (result) ->
            unless result.status
              $.jstree.rollback data.rlbk
            else
              $(data.rslt.oc).attr "fullpath", "node_" + result.fullpath
              data.inst.refresh data.inst._get_parent(data.rslt.oc)  if data.rslt.cy and $(data.rslt.oc).children("UL").length