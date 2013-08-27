#= require jquery.cookie
# require jquery.hotkeys
#= require jquery.jgrowl_minimized
#= require fancybox/jquery.fancybox
#= require jstree_manager
#= require files_manager
#= require code_mirror_manager
#= require_self

class @Themes
  @resetToDefaultTheme = (url) ->
    if (confirm("Are you sure?"))
      window.location = url

$ ->
  $(".fancybox").fancybox
    openEffect: "elastic"
    closeEffect: "elastic"
    helpers:
      title:
        type: "inside"