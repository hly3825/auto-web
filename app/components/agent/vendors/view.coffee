Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
Buzvvendors = require "buzv/vendors/view"
itemsTemplate = Handlebars.templates["buzv/vendors/templates/items"]

class AgentVendors
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @$showItemsButton = $(".js-show-items")
    @bindEvents()

  bindEvents: ->
    new Pagination(".checkvendor-pagination").total($(".checkvendor-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox
    @$showItemsButton.on "click", @showItems
    $("table").on "click", ".js-link-qrcode", @openQrCode

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  showItems: ->
    id = $(@).data "id"
    Buzvvendors::showItemsModal(id, -1, "show")

  openQrCode: ->
    href = $(@).data("link")
    window.open href

module.exports = AgentVendors
