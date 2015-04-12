Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"

class BuzvPayHistory
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    new Pagination(".payhistory-pagination").total($(".payhistory-pagination").data("total")).show(20)

module.exports = BuzvPayHistory
