Pagination = require "pokeball/components/pagination"
class BuzvProfitsRule
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @bindEvents()

  bindEvents: ->
    new Pagination(".profitsrule-pagination").total($(".profitsrule-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox


  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

module.exports = BuzvProfitsRule
