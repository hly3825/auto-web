Pagination = require "pokeball/components/pagination"
class AlbumRank
  constructor: ($) ->
    @bindEvents()
    @init()

  bindEvents: ->
    new Pagination(".album-rank-pagination").total($(".album-rank-pagination").data("total")).show(20)
    $(".sort-select").on "change", @sortSearch

  init: ->

  sortSearch: ->
    sort = $(@).val()
    field = $(@).data "field"
    window.location.search = $.query.remove("sort").set("sort", sort).remove("field").set("field", field)

module.exports = AlbumRank
