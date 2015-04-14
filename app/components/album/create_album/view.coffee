Modal = require "pokeball/components/modal"
itemTemplate = Handlebars.templates["album/create_album/templates/item"]

class CreateAlbum
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    $("input[name=file][data-condition]").on "click", @fileUpload
    $("input[name=file][data-excel]").on "click", @excelUpload
    $(".album-form").validator()
    $(".album-form").on "submit", @formSubmit

  fileUpload: ->
    _this = @
    $infoInput = $(_this).parent().siblings(".info-input")
    $imgshow = $(_this).parent().siblings(".img")
    $btncircle = $(_this).parent().closest(".btn-primary")
    picInfo = $(_this).data "condition"
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/files/upload"
      type: "POST"
      dataType: "json"
      formData: picInfo
      success: (data)=>
        $infoInput.val(data.url).change()
        $imgshow.attr "src", data.url
      submit: (e, data)=>
        unless /(\.|\/)(gif|jpe?g|png)$/.test(data.originalFiles[0].name)
          new Modal
            "icon": "error"
            "title": "上传失败"
            "content": "请选择正确格式图片"
          .show()
          e.preventDefault()
      complete: =>
        $btncircle.spin(false)
        $imgshow.parent().removeClass("error empty")

  excelUpload: ->
    _this = @
    $btncircle = $(_this).parent().closest(".btn-success")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/items/excel/import"
      type: "POST"
      dataType: "json"
      success: (data)=>
        $("table.item-table tbody").children().remove()
        $("table.item-table tbody").append itemTemplate({data})
      complete: =>
        $btncircle.spin(false)

  formSubmit: (evt)=>
    evt.preventDefault()
    data = @organizeData()
    type = "POST"
    if $("input[name=id]").length is 1
      data.id = $("input[name=id]").val()
      type = "PUT"
    $.ajax
      url: "/api/albums/album"
      type: type
      contentType: "application/json"
      data: JSON.stringify(data)
      success: (data)->
        new Modal
          "icon": "success"
          "title": "保存成功"
          "content": "专辑保存成功"

  organizeData: ->
    album = $(".album-form").serializeObject()
    album.tag = album.tag.join ","
    items = _.map $(".album-form table.item-table tbody tr"), (item)->
      taobaoId = $(item).find("input[name=taobaoId]").val()
      mainImage = $(item).find("input[name=mainImage]").val()
      recommend =  $(item).find("input[name=recommend]").val()
      {taobaoId, mainImage, recommend}

    {album, items}

module.exports = CreateAlbum
