Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"

class TextTool
  constructor: ($)->
    @bindEvent()
    $("input[name=file]").on "click", @fileUpload

  that = this
  bindEvent:->
    that = this
    @textTool()

  textTool: ->
    editor = new wysihtml5.Editor("wysihtml5-editor", {
        toolbar:     "wysihtml5-editor-toolbar",
        parserRules: wysihtml5ParserRules
      })

    editor.on "load", ->
      composer = editor.composer

    $(".wysihtml5-sandbox").addClass("text-tool-iframe")

  fileUpload: ->
    _this = @
    type = $(@).data("role")
    if type is 1 then that.fileToUp(_this) else that.pictoUp(_this)

  fileToUp: (_this)->
    fileName = $(_this).closest(".file-group").find(".file-name")
    $(_this).fileupload
      url: "/api/files/upload"
      type: "POST"
      dataType: "json"
      success: (data)=>
        fileName.text(data.name).attr("title", data.name).closest(".file-group").find(".file-input").val(data.url).data("name", data.name)

  pictoUp: (_this)->
    selecter = $(_this).closest(".image-selecter")
    $(_this).fileupload
      url: "/api/files/upload"
      type: "POST"
      dataType: "json"
      success: (data)=>
        $(selecter).find(".image-input").val(data.url)

module.exports = TextTool
