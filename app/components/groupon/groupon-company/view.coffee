Pagination = require "pokeball/components/pagination"

class GrouponCompany
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    new Pagination(".groupon-company-pagination").total($(".groupon-company-pagination").data("total")).show(20)

module.exports = GrouponCompany
