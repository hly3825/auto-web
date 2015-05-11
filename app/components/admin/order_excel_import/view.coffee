Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
class OrderImport
  constructor: ($) ->
    @bindEvents()
    @init()

  bindEvents: ->
    new Pagination(".excel-import-pagination").total($(".excel-import-pagination").data("total")).show(20)
    $("input[name=file]").on "click", @excelUpload
    $(".datepicker").datepicker({yearRange: [2014, 2215]})

  init: ->
    @renderCompany()

  renderCompany: ->
    $.ajax
      url: "/api/company"
      type: "GET"
      success: (data)->
        $companySelect = $("select[name=companyId]").empty();
        $companySelect.append("""<option value="">请选择公司</option>""")
        _.each data, (item)->
          $companySelect.append("""<option value="#{item.id}">#{item.companyName}</option>""")


  excelUpload: ->
    debugger
    if $("select[name=companyId]").val() is ""
      new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择公司,然后进行导入"
        .show()
      return
    _this = @
    companyId = $("select[name=companyId]").val()
    $btncircle = $(_this).parent().closest(".btn-success")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/orders/excel/import"
      type: "POST"
      formData: {companyId}
      dataType: "json"
      success: (data)=>
        new Modal
          "icon": "success"
          "title": "文件上传成功"
          "content": "订单数据导入中，请稍候刷新页面查看导入结果"
        .show(
          window.location.reload()
        )
      complete: =>
        $btncircle.spin(false)

module.exports = OrderImport
