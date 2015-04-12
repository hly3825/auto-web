Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
returnMoney = Handlebars.templates["operation/order-list/templates/confirm"]

class OperationOrders
  constructor: ($) ->
    @$startAtInput = $("#orderDateStart")
    @$endAtInput = $("#orderDateEnd")
    @$showMutiConfirmModal = $(".js-return-mutimoney")
    @$showOneConfirmModal = $(".js-return-onemoney")
    @selectAll = $(".js-select-all")
    @$mutiOmsstatus = $(".js-muti-omsstatus")
    @$oneOmsstatus = $(".js-retransmit-omsstatus")
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
    @$mutiOmsstatus.on "click", @tranMutiOmsstatus
    @$oneOmsstatus.on "click", @tranOneOmsstatus
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
          status is -7 or status is -3
        )
      if statusArray.length > 0
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择可以退款/退货的数据"
        .show()
      else
        num = 0
        for i in array
          ids[num] = $(i).val()
          num = num + 1
        OperationOrders::openModal(ids)

  showConfirmOne: ->
    ids = []
    ids[0] = $(@).data "id"
    status = $(@).data "status"
    if status isnt -7 and status isnt -3
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请选择可以退款/退货的数据"
      .show()
    else
      OperationOrders::openModal(ids)

  openModal:(ids)->
    returnFee = new Modal(returnMoney({ids}))
    $(".modalReturnMoney .js-return-fee").data("ids", ids)
    returnFee.show()
    $(".modalReturnMoney .js-return-fee").on "submit", {"modal":returnFee}, OperationOrders::confirmSubmit

  confirmSubmit: (evt)->
    evt.preventDefault()
    modal = evt.data.modal
    idsString = $(".modalReturnMoney .js-return-fee").data("ids")
    $.ajax
      url: "/api/order/returnMoney"
      type: "POST"
      data: {ids: idsString}
      success: (data)->
        modal.close()
        new Modal
          "icon": "success"
          "title": "退款成功"
          "content": "退款成功"
        .show ->
          window.location.href = "/operation/dashboard"

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

  tranMutiOmsstatus: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请选择一个订单号"
      .show()
    else
      statusArray = _.reject(array, (i)->
        omsstatus = $(i).data "omsstatus"
        omsstatus is -1
      )
      if statusArray.length >0
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择发送oms失败的订单号"
        .show()
      else
        ids = _.map(array, (i)->
            $(i).val()
          ).join(",")
        OperationOrders::retransOmsstatus(ids)

  tranOneOmsstatus: ->
    ids = $(@).data "id"
    omsstatus = $(@).data "omsstatus"
    if omsstatus isnt -1
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请选择发送oms失败的订单号"
      .show()
      return
    else
      OperationOrders::retransOmsstatus(ids)

  retransOmsstatus: (ids)->
    $.ajax
     url: "/api/order/transOmsstatus"
     type: "POST"
     data: {ids:ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "OMS状态重置"
        "content": "OMS状态重置成功"
      .show ->
        window.location.href = "/operation/dashboard"

module.exports = OperationOrders
