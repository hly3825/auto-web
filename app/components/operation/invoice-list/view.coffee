Pagination = require "pokeball/components/pagination"

class OrderInvoice
  constructor: ($) ->
    @$startAtInput = $("#beginTime")
    @$endAtInput = $("#endTime")
    @$exportInvoiceButton = $(".js-export-searchinvoice")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#endTime").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#beginTime").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".invoice-pagination").total($(".invoice-pagination").data("total")).show(20)
    @$exportInvoiceButton.on "click", @exportInvoice

  exportInvoice:->
    search = []
    search.push "orderId=#{$(".operation-invoice-form").find("input[name=orderId]").val()}" if !_.isEmpty $(".operation-invoice-form").find("input[name=orderId]").val()
    search.push "status=#{$(".operation-invoice-form").find("select[name=status]").val()}" if !_.isEmpty $(".operation-invoice-form").find("select[name=status]").val()
    search.push "beginTime=#{$(".operation-invoice-form").find("input[name=beginTime]").val()}" if !_.isEmpty $(".operation-invoice-form").find("input[name=beginTime]").val()
    search.push "endTime=#{$(".operation-invoice-form").find("input[name=endTime]").val()}" if !_.isEmpty $(".operation-invoice-form").find("input[name=endTime]").val()
    window.open "/api/export/groupinvoice?#{search.join("&")}"

module.exports = OrderInvoice
