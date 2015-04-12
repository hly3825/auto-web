Pagination = require "pokeball/components/pagination"
class VendorProfits
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
    search.push "orderStatus=#{$(".vendorprofits-form").find("select[name=orderStatus]").val()}" if !_.isEmpty $(".vendorprofits-form").find("select[name=orderStatus]").val()
    search.push "commissionStart=#{$(".vendorprofits-form").find("input[name=commissionStart]").val()}" if !_.isEmpty $(".vendorprofits-form").find("input[name=commissionStart]").val()
    search.push "commissionEnd=#{$(".vendorprofits-form").find("input[name=commissionEnd]").val()}" if !_.isEmpty $(".vendorprofits-form").find("input[name=commissionEnd]").val()
    search.push "periodType=#{$(".vendorprofits-form").find("select[name=periodType]").val()}" if !_.isEmpty $(".vendorprofits-form").find("select[name=periodType]").val()
    search.push "orderNo=#{$(".vendorprofits-form").find("input[name=orderNo]").val()}" if !_.isEmpty $(".vendorprofits-form").find("input[name=orderNo]").val()
    search.push "commissionPayStatus=#{$(".vendorprofits-form").find("select[name=commissionPayStatus]").val()}" if !_.isEmpty $(".vendorprofits-form").find("select[name=commissionPayStatus]").val()
    search.push "commissionPayDateStart=#{$(".vendorprofits-form").find("input[name=commissionPayDateStart]").val()}" if !_.isEmpty $(".vendorprofits-form").find("input[name=commissionPayDateStart]").val()
    search.push "commissionPayDateEnd=#{$(".vendorprofits-form").find("input[name=commissionPayDateEnd]").val()}" if !_.isEmpty $(".vendorprofits-form").find("input[name=commissionPayDateEnd]").val()
    search.push "vendorCode=#{$(".vendorprofits-form").find("input[name=vendorCode]").val()}" if !_.isEmpty $(".vendorprofits-form").find("input[name=vendorCode]").val()

    window.location.href =  "/api/export/ordercommission?#{search.join("&")}"

module.exports = VendorProfits
