Modal = require "pokeball/components/modal"
Pagination = require "pokeball/components/pagination"
itemsTemplate = Handlebars.templates["buzv/vendors/templates/items"]

class Buzvvendors
  constructor: ($) ->
    @$addItemsButton = $(".js-add-items")
    @$batchaddItemsButton = $(".js-batch-add-items")
    @selectAll = $(".js-select-all")
    @$showItemsButton = $(".js-show-items")
    @$deleteButton = $(".js-delete-vendor")
    @$submitButton = $(".js-batch-submit")
    @bindEvents()

  bindEvents: ->
    new Pagination(".vendors-pagination").total($(".vendors-pagination").data("total")).show(20)
    @$addItemsButton.on "click", @vendorItems
    @$batchaddItemsButton.on "click", @batchVendorItems
    @selectAll.on "change", @toggleAllCheckbox
    @$showItemsButton.on "click", @showItems
    @$deleteButton.on "click", @deleteBatch
    @$submitButton.on "click", @submitVendor
    $("table").on "click", ".js-link-qrcode", @openQrCode

  submitVendor: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个商户"
      .show()
    else
      statusArray = _.reject(array, (i)->
          status = $(i).data("status")
          status is "" or status is 0 or status is -1
        )
      if statusArray.length > 0
        new Modal
          "icon": "error"
          "title": "审核错误"
          "content": "请不要选择审核中或者审核过的数据"
        .show()
      else
        ids = _.map(array, (i)->
            $(i).val()
          ).join(",")
        Buzvvendors::submitData(ids)

  submitData: (ids)->
    $.ajax
     url: "/api/vendor/submitbatch"
     type: "POST"
     data: {vendorIds:ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "提交成功"
        "content": "商户提交成功"
      .show ->
        window.location.href = "/buzv/vendors"

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  deleteBatch: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个商户"
      .show()
    else
      statusArray = _.reject(array, (i)->
          status = $(i).data("status")
          status is "" or status is 0 or status is -1
        )
      if statusArray.length > 0
        new Modal
          "icon": "error"
          "title": "删除错误"
          "content": "请不要选择审核中或者审核过的数据"
        .show()
      else
        ids = _.map(array, (i)->
            $(i).val()
          ).join(",")
        Buzvvendors::parseData(ids)

  parseData: (ids)->
    $.ajax
     url: "/api/vendor/delete"
     type: "POST"
     data: {merchantIds:ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "删除成功"
        "content": "商户删除成功"
      .show ->
        window.location.href = "/buzv/vendors"

  batchVendorItems: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个商户"
      .show()
    else
      ids = _.map(array, (i)->
          $(i).val()
        ).join(",")
      Buzvvendors::showItemsModal(ids, array.length, null)

  vendorItems: ->
    id = $(@).data "id"
    Buzvvendors::showItemsModal(id, 1, null)

  showItemsModal: (venderIds, num, type)->
    if num is 1
      url = "/api/vendor/#{venderIds}/items"
    else if num is -1
      url = "/api/vendor/#{venderIds}/chooseditems"
    else
      url = "/api/vendor/items"
    $.ajax
      url: url
      type: "GET"
      success: (data)->
        itemsModal = new Modal(itemsTemplate({data, venderIds, type}))
        itemsModal.show()
        $(".vendorsItem .js-link-click").on "click", Buzvvendors::openImage
        $(".js-vendor-items").change ->
          $(".vendorsItem .js-batch-checkbox").prop('checked', $(@).prop("checked"))
        $(".js-vendoritems-add").on "click", {"modal": itemsModal}, Buzvvendors::chooseItems

  openImage: (evt)->
    evt.preventDefault()
    window.open $(@).attr "href"

  chooseItems: (evt)->
    array = $(".vendorsItem table tbody input[type=checkbox]:checked")
    vendorIds = $(".vendorsItem").data "id"
    modal = evt.data.modal
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个商品"
      .show()
    else
      itemIds = _.map(array, (i)->
          $(i).val()
        ).join(",")
      $.ajax
        url: "/api/vendor/create/items"
        type: "POST"
        data: {vendorIds, itemIds}
        success: (data)->
          modal.close()
          new Modal
            "icon": "success"
            "title": "成功"
            "content": "添加成功"
          .show()

  showItems: ->
    id = $(@).data "id"
    Buzvvendors::showItemsModal(id, -1, "show")

  openQrCode: ->
    href = $(@).data("link")
    window.open href

module.exports = Buzvvendors
