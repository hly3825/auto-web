Pagination = require "pokeball/components/pagination"

class Stock
  constructor: ($) ->
    @$exportStock = $(".js-export-stock")
    @bindEvents()

  bindEvents: ->
    new Pagination(".stock-pagination").total($(".stock-pagination").data("total")).show(20)
    @$exportStock.on "click", @exportStockList

  exportStockList: ->
    $.ajax
      url: "/api/groupstock/redisAddress"
      type: "POST"
      success: (data)->
        window.open data

module.exports = Stock
