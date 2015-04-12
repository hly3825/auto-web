Pagination = require "pokeball/components/pagination"

class FinanceSearchOrders
  constructor: ($) ->
    @$startAtInput = $("#orderDateStart")
    @$endAtInput = $("#orderDateEnd")
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
    @$exportOrderButton.on "click", @exportOrder
    @orderSummary()

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

module.exports = FinanceSearchOrders
