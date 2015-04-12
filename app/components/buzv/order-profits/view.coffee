Pagination = require "pokeball/components/pagination"
class BuzvOrderProfits
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @$startAtInput = $("#payDateStart")
    @$endAtInput = $("#payDateEnd")
    @$exportButton = $(".js-export")
    @bindEvents()

  bindEvents: ->
    @$startAtInput.datepicker
      onSelect: (selectedDate)->
        $("#payDateEnd").data("pikaday").setMinDate(selectedDate)
    @$endAtInput.datepicker
      onSelect: (selectedDate)->
        $("#payDateStart").data("pikaday").setMaxDate(selectedDate)
    new Pagination(".orderprofits-pagination").total($(".orderprofits-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox
    @$exportButton.on "click", @export

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  export: ->
    search = []
    search.push "orderStatus=#{$(".buzv-orderprofits-form").find("select[name=orderStatus]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("select[name=orderStatus]").val()
    search.push "commissionStart=#{$(".buzv-orderprofits-form").find("input[name=commissionStart]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("input[name=commissionStart]").val()
    search.push "commissionEnd=#{$(".buzv-orderprofits-form").find("input[name=commissionEnd]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("input[name=commissionEnd]").val()
    search.push "periodType=#{$(".buzv-orderprofits-form").find("select[name=periodType]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("select[name=periodType]").val()
    search.push "orderNo=#{$(".buzv-orderprofits-form").find("input[name=orderNo]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("input[name=orderNo]").val()
    search.push "commissionPayStatus=#{$(".buzv-orderprofits-form").find("select[name=commissionPayStatus]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("select[name=commissionPayStatus]").val()
    search.push "commissionPayDateStart=#{$(".buzv-orderprofits-form").find("input[name=commissionPayDateStart]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("input[name=commissionPayDateStart]").val()
    search.push "commissionPayDateEnd=#{$(".buzv-orderprofits-form").find("input[name=commissionPayDateEnd]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("input[name=commissionPayDateEnd]").val()
    search.push "vendorCode=#{$(".buzv-orderprofits-form").find("input[name=vendorCode]").val()}" if !_.isEmpty $(".buzv-orderprofits-form").find("input[name=vendorCode]").val()

    window.location.href =  "/api/export/ordercommission?#{search.join("&")}"

module.exports = BuzvOrderProfits
