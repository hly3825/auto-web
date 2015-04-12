Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"

class BuzvPay
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @$startAtInput = $("#applyDateStart")
    @$endAtInput = $("#applyDateEnd")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#applyDateStart").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#applyDateEnd").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".pays-pagination").total($(".pays-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

module.exports = BuzvPay
