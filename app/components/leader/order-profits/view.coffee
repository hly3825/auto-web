Pagination = require "pokeball/components/pagination"
class LeaderOrderProfits
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
    search.push "orderStatus=#{$(".leader-orderprofits-form").find("select[name=orderStatus]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("select[name=orderStatus]").val()
    search.push "commissionStart=#{$(".leader-orderprofits-form").find("input[name=commissionStart]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("input[name=commissionStart]").val()
    search.push "commissionEnd=#{$(".leader-orderprofits-form").find("input[name=commissionEnd]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("input[name=commissionEnd]").val()
    search.push "periodType=#{$(".leader-orderprofits-form").find("select[name=periodType]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("select[name=periodType]").val()
    search.push "orderNo=#{$(".leader-orderprofits-form").find("input[name=orderNo]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("input[name=orderNo]").val()
    search.push "commissionPayStatus=#{$(".leader-orderprofits-form").find("select[name=commissionPayStatus]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("select[name=commissionPayStatus]").val()
    search.push "commissionPayDateStart=#{$(".leader-orderprofits-form").find("input[name=commissionPayDateStart]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("input[name=commissionPayDateStart]").val()
    search.push "commissionPayDateEnd=#{$(".leader-orderprofits-form").find("input[name=commissionPayDateEnd]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("input[name=commissionPayDateEnd]").val()
    search.push "vendorCode=#{$(".leader-orderprofits-form").find("input[name=vendorCode]").val()}" if !_.isEmpty $(".leader-orderprofits-form").find("input[name=vendorCode]").val()

    window.location.href =  "/api/export/ordercommission?#{search.join("&")}"

module.exports = LeaderOrderProfits
