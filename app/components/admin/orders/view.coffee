Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
itemsImportTemplate = Handlebars.templates["admin/items/templates/import"]

class AdminOrders
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

  putawayOrsoldout: ->
    id = $(@).data "id"
    AdminItems::parseData(id)

  putawayOrsoldoutBatch: ->
    array = $("table input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个商品"
      .show()
    else
      ids = _.map(array, (i)->
          $(i).val()
        ).join(",")
      AdminItems::parseData(ids)

  parseData: (ids)->
    $.ajax
     url: "/api/item/dealShelves"
     type: "POST"
     data: {ids:ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "上下架成功"
        "content": "商品上下架成功"
      .show ->
        window.location.href = "/admin/items"

module.exports = AdminOrders
