Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
confirmTemplate = Handlebars.templates["leader/check-pay/templates/confirm"]

class CheckPay
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @$startAtInput = $("#applyDateStart")
    @$endAtInput = $("#applyDateEnd")
    @checkpayBtn = $(".js-apply-pay")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#applyDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#applyDateStart").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".checkpay-pagination").total($(".checkpay-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox
    @checkpayBtn.on "click", @showCheckModal

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  showCheckModal: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0 or array.length>1
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请选择一个立项号"
      .show()
    else
      statusArray = _.reject(array, (i)->
        status = $(i).data "status"
        payStatus = $(i).data "paystatus"
        status is 1 and payStatus is 2
      )
      if statusArray.length >0
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择申请中的且已付款的立项号"
        .show()
      else
        id = array.val()
        confirmModal = new Modal(confirmTemplate({id}))
        confirmModal.show()
        $(".audit-checkpay .js-audit-checkpay").on "submit", {"modal":confirmModal}, CheckPay::checkpayAudit

  checkpayAudit: (evt)->
    evt.preventDefault()
    data = $(@).serializeObject()
    data.paymentInfoId = "#{$(@).data "id"}"
    modal = evt.data.modal
    $.ajax
      url: "/api/checkpay/checkPay"
      type: "POST"
      data: data
      success: ->
        modal.close()
        new Modal
          "icon": "success"
          "title": "操作"
          "content": "审核操作完成"
        .show ->
          window.location.reload()

module.exports = CheckPay
