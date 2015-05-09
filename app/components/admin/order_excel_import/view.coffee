Modal = require "pokeball/components/modal"
class OrderImport
  constructor: ($) ->
    @bindEvents()
    @init()

  bindEvents: ->
    $("input[name=file]").on "click", @excelUpload

  init: ->


  excelUpload: ->
    _this = @
    $btncircle = $(_this).parent().closest(".btn-success")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/orders/excel/import"
      type: "POST"
      dataType: "json"
      success: (data)=>
        new Modal
          "icon": "success"
          "title": "文件上传成功"
          "content": "订单数据导入中，请稍候刷新页面查看导入结果"
        .show()
      complete: =>
        $btncircle.spin(false)

module.exports = OrderImport
