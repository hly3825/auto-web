Pagination = require "pokeball/components/pagination"

class AgentVendorProfits
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @$exportButton = $(".js-export")
    @$startAtInput = $("#payDateStart")
    @$endAtInput = $("#payDateEnd")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#payDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#payDateStart").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".vendorprofits-pagination").total($(".vendorprofits-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox
    @$exportButton.on "click", @export

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  export: ->
    search = []
    search.push "vendorStatus=#{$(".agent-vendorprofits-form").find("select[name=vendorStatus]").val()}" if !_.isEmpty $(".agent-vendorprofits-form").find("select[name=startAt]").val()
    search.push "vendorCode=#{$(".agent-vendorprofits-form").find("input[name=vendorCode]").val()}" if !_.isEmpty $(".agent-vendorprofits-form").find("input[name=vendorCode]").val()
    search.push "periodType=#{$(".agent-vendorprofits-form").find("select[name=periodType]").val()}" if !_.isEmpty $(".agent-vendorprofits-form").find("select[name=periodType]").val()
    window.location.href =  "/api/export/vendorcommission?#{search.join("&")}"

module.exports = AgentVendorProfits
