Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"

class AgentOrders
  constructor: ($) ->
    @batchButton = $(".js-batch-freeze")
    @selectAll = $(".js-select-all")
    @$startAtInput = $("#orderDateStart")
    @$endAtInput = $("#orderDateEnd")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#orderDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#orderDateStart").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".orders-pagination").total($(".orders-pagination").data("total")).show(20)
    $("table").on "click", ".js-status", @putawayOrsoldout
    @batchButton.on "click",  @putawayOrsoldoutBatch
    @selectAll.on "change", @toggleAllCheckbox

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

module.exports = AgentOrders
