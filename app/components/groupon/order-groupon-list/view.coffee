Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"

class GroupOrders
  constructor: ($) ->
    @$startAtInput = $("#orderDateStart")
    @$endAtInput = $("#orderDateEnd")
    @$exportOrderButton = $(".js-export-searchorder")
    @selectAll = $(".js-select-all")
    @$mutiOmsstatus = $(".js-muti-omsstatus")
    @$oneOmsstatus = $(".js-retransmit-omsstatus")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#orderDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#orderDateStart").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".orders-pagination").total($(".orders-pagination").data("total")).show(20)
    @$exportOrderButton.on "click", @exportOrder
    @selectAll.on "change", @toggleAllCheckbox
    @$mutiOmsstatus.on "click", @tranMutiOmsstatus
    @$oneOmsstatus.on "click", @tranOneOmsstatus
    @orderSummary()

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  orderSummary: ->
    $.ajax
      url: "/api/order/calcOrderVolumn"
      type: "POST"
      success: (data)->
        $(".js-total-volumn span").text((data.totalTradeVolume/100).toFixed(2))
        $(".js-today-volumn span").text((data.todayTradeVolume/100).toFixed(2))
        $(".js-total-count").text(data.totalTradeCount)
        $(".js-today-count").text(data.todayTradeCount)

  exportOrder: ->
    status = $(".groupon-order-form").find("select[name=status]").val()
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
        GroupOrders::retransOmsstatus(ids)

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
      GroupOrders::retransOmsstatus(ids)

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
        window.location.href = "/group/dashboard"

module.exports = GroupOrders
