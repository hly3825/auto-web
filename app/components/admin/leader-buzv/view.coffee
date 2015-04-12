Pagination = require "pokeball/components/pagination"

class AdminLeaderBuzv
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    new Pagination(".leaders-pagination").total($(".leaders-pagination").data("total")).show(20)

module.exports = AdminLeaderBuzv
