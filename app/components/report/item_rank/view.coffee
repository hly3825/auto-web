Pagination = require "pokeball/components/pagination"
class ItemRank
  constructor: ($) ->
    @bindEvents()
    @init()

  bindEvents: ->
    new Pagination(".item-rank-pagination").total($(".item-rank-pagination").data("total")).show()
    $(".sort-select").on "change", @sortSearch

  init: ->

  sortSearch: ->
    sort = $(@).val()
    field = $(@).data "field"
    window.location.search = $.query.remove("sort").set("sort", sort).remove("field").set("field", field)

module.exports = ItemRank
