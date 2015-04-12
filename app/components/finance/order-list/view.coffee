Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
returnMoney = Handlebars.templates["finance/order-list/templates/confirm"]

class FinanceOrders
  constructor: ($) ->
    @$startAtInput = $("#orderDateStart")
    @$endAtInput = $("#orderDateEnd")
    @$showMutiConfirmModal = $(".js-return-mutimoney")
    @$showOneConfirmModal = $(".js-return-onemoney")
    @selectAll = $(".js-select-all")
    @$exportOrderButton = $(".js-export-searchorder")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#orderDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#orderDateStart").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".orders-pagination").total($(".orders-pagination").data("total")).show(20)
    @$showMutiConfirmModal.on "click", @showConfirmMuti
    @$showOneConfirmModal.on "click", @showConfirmOne
    @selectAll.on "change", @toggleAllCheckbox
    @$exportOrderButton.on "click", @exportOrder
    @returnSummary()

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  showConfirmMuti: ->
    array = $("table tbody input[type=checkbox]:checked")
    ids = []
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个订单"
      .show()
    else
      statusArray = _.reject(array, (i)->
          status = $(i).data("status")
          status is -8
        )
      if statusArray.length > 0
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择待退款的数据"
        .show()
      else
        num = 0
        for i in array
          ids[num] = $(i).val()
          num = num + 1
        FinanceOrders::openModal(ids)

  showConfirmOne: ->
    ids = []
    ids[0] = $(@).data "id"
    status = $(@).data "status"
    if status isnt -8
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请选择待退款的数据"
      .show()
    else
      FinanceOrders::openModal(ids)

  openModal:(ids)->
    returnFee = new Modal(returnMoney({ids}))
    $(".modalReturnMoney .js-return-fee").data("ids", ids)
    returnFee.show()
    $(".modalReturnMoney .js-return-fee").on "submit", {"modal":returnFee}, FinanceOrders::confirmSubmit

  confirmSubmit: (evt)->
    evt.preventDefault()
    modal = evt.data.modal
    ids = $(".modalReturnMoney .js-return-fee").data("ids")
    $.ajax
      url: "/api/order/returnMoney"
      type: "POST"
      data: {ids: ids}
      success: (data)->
        modal.close()
        new Modal
          "icon": "success"
          "title": "退款成功"
          "content": "退款成功"
        .show ->
          window.location.href = "/finance/dashboard"

  returnSummary: ->
    $.ajax
      url: "/api/order/returnSummary"
      type: "POST"
      success: (data)->
        $(".js-has-retund").text(data.notRefund)
        $(".js-not-retund").text(data.totalRefund)

  exportOrder: ->
    status = $(".operation-order-form").find("select[name=status]").val()
    $.ajax
      url: "/api/grouporder/redisAddress"
      type: "POST"
      data: {status:status}
      success: (data)->
        window.open data

  # exportOrder:->
  #   search = []
  #   search.push "groupOrderId=#{$(".operation-order-form").find("input[name=groupOrderId]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=groupOrderId]").val()
  #   search.push "payNo=#{$(".operation-order-form").find("input[name=payNo]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=payNo]").val()
  #   search.push "transactionNo=#{$(".operation-order-form").find("input[name=transactionNo]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=transactionNo]").val()
  #   search.push "omsNo=#{$(".operation-order-form").find("input[name=omsNo]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=omsNo]").val()
  #   search.push "status=#{$(".operation-order-form").find("select[name=status]").val()}" if !_.isEmpty $(".operation-order-form").find("select[name=status]").val()
  #   search.push "payType=#{$(".operation-order-form").find("select[name=payType]").val()}" if !_.isEmpty $(".operation-order-form").find("select[name=payType]").val()
  #   search.push "orderDateStart=#{$(".operation-order-form").find("input[name=orderDateStart]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=orderDateStart]").val()
  #   search.push "orderDateEnd=#{$(".operation-order-form").find("input[name=orderDateEnd]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=orderDateEnd]").val()
  #   search.push "orderId=#{$(".operation-order-form").find("input[name=orderId]").val()}" if !_.isEmpty $(".operation-order-form").find("input[name=orderId]").val()
  #   window.open "/api/export/grouporder?#{search.join("&")}"

module.exports = FinanceOrders
