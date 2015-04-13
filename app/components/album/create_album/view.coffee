Modal = require "pokeball/components/modal"

class CreateAlbum
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    $("input[name=file]").on "click", @fileUpload

  fileUpload: ->
    _this = @
    $infoInput = $(_this).parent().siblings(".info-input")
    $imgshow = $(_this).parent().siblings(".img")
    $btncircle = $(_this).parent().closest(".btn-primary")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/files/upload"
      type: "POST"
      dataType: "json"
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

module.exports = CreateAlbum
