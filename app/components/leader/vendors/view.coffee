Modal = require "pokeball/components/modal"
Pagination = require "pokeball/components/pagination"
Buzvvendors = require "buzv/vendors/view"
checkTemplate = Handlebars.templates["leader/vendors/templates/check"]

class LeaderVendors
  constructor: ($) ->
    @$checkVendorButton = $(".js-check-vendor")
    @selectAll = $(".js-select-all")
    @$showItemsButton = $(".js-show-items")
    @bindEvents()

  bindEvents: ->
    new Pagination(".vendors-pagination").total($(".vendors-pagination").data("total")).show(20)
    @$checkVendorButton.on "click", @showCheckModal
    @selectAll.on "change", @toggleAllCheckbox
    @$showItemsButton.on "click", @showItems
    $("table").on "click", ".js-link-qrcode", @openQrCode

  showCheckModal: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个商户"
      .show()
    else
      statusArray = _.reject(array, (i)->
          status = $(i).data("status")
          status is "" or status is 1
        )
      if statusArray.length > 0
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择待审核的数据"
        .show()
      else
        ids = _.map(array, (i)->
            $(i).val()
          ).join(",")
        checkModal = new Modal(checkTemplate({ids}))
        checkModal.show()
        $(".modalVendorAudit .js-audit-vendor").on "submit", {"modal":checkModal}, LeaderVendors::auditSubmit

  auditSubmit: (evt)->
    evt.preventDefault()
    data = $(@).serializeObject()
    data.merchantIds = "#{$(@).data "id"}"
    modal = evt.data.modal
    $.ajax
      url: "/api/vendor/audit"
      type: "POST"
      data: data
      success: (data)->
        modal.close()
        new Modal
          "icon": "success"
          "title": "提交审核成功"
          "content": "提交审核结果成功"
        .show ->
          window.location.href = "/leader/vendors"

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  showItems: ->
    id = $(@).data "id"
    Buzvvendors::showItemsModal(id, -1, "show")

  openQrCode: ->
    href = $(@).data("link")
    window.open href

module.exports = LeaderVendors
