Pagination = require "pokeball/components/pagination"

class BuzvReport
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @$startAtInput = $("#buzvreportDateStart")
    @$endAtInput = $("#buzvreportDateEnd")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate) ->
        $("#buzvreportDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate) ->
        $("#buzvreportDateStart").date("pikaday").setMaxDate(selectedDate)
    new Pagination(".buzvreport-pagination").total($(".buzvreport-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

module.exports = BuzvReport
