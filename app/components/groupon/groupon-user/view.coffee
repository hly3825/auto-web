Pagination = require "pokeball/components/pagination"

class GrouponUser
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    new Pagination(".groupon-user-pagination").total($(".groupon-user-pagination").data("total")).show(20)

module.exports = GrouponUser
