Pagination = require "pokeball/components/pagination"
class BuzvVendorProfits
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
    search.push "vendorStatus=#{$(".buzv-vendorprofits-form").find("select[name=vendorStatus]").val()}" if !_.isEmpty $(".buzv-vendorprofits-form").find("select[name=startAt]").val()
    search.push "vendorCode=#{$(".buzv-vendorprofits-form").find("input[name=vendorCode]").val()}" if !_.isEmpty $(".buzv-vendorprofits-form").find("input[name=vendorCode]").val()
    search.push "periodType=#{$(".buzv-vendorprofits-form").find("select[name=periodType]").val()}" if !_.isEmpty $(".buzv-vendorprofits-form").find("select[name=periodType]").val()
    window.location.href =  "/api/export/vendorcommission?#{search.join("&")}"

module.exports = BuzvVendorProfits
