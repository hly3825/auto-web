Pagination = require "pokeball/components/pagination"

class LeaderBuzv
  constructor: ($) ->
    @batchButton = $(".js-batch-freeze")
    @selectAll = $(".js-select-all")
    @bindEvents()

  bindEvents: ->
    new Pagination(".leaders-pagination").total($(".leaders-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

module.exports = LeaderBuzv
