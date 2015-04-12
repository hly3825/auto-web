Pagination = require "pokeball/components/pagination"
class LeaderItems
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @bindEvents()

  bindEvents: ->
    new Pagination(".items-pagination").total($(".items-pagination").data("total")).show(20)
    $("table").on "click", ".js-link-click", @openImage
    @selectAll.on "change", @toggleAllCheckbox

  openImage: (evt)->
    evt.preventDefault()
    window.open $(@).attr "href"

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))


module.exports = LeaderItems
