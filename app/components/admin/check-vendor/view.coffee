Pagination = require "pokeball/components/pagination"

class AdminCheckVendor
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @bindEvents()

  bindEvents: ->
    new Pagination(".checkvendor-pagination").total($(".checkvendor-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox
    $("table").on "click", ".js-link-qrcode", @openQrCode

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  openQrCode: ->
    href = $(@).data("link")
    window.open href

module.exports = AdminCheckVendor
