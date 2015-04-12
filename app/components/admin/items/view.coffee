Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
itemsImportTemplate = Handlebars.templates["admin/items/templates/import"]
rulesTemplate = Handlebars.templates["admin/items/templates/rules"]

class AdminItems
  constructor: ($) ->
    @batchButton = $(".js-batch-status")
    @selectAll = $(".js-select-all")
    @importButton = $(".js-batch-import")
    @rulesButton = $(".js-batch-rules")
    @bindEvents()

  bindEvents: ->
    new Pagination(".items-pagination").total($(".items-pagination").data("total")).show(20)
    $("table").on "click", ".js-link-click", @openImage
    $("table").on "click", ".js-status", @putawayOrsoldout
    @batchButton.on "click",  @putawayOrsoldoutBatch
    @selectAll.on "change", @toggleAllCheckbox
    @importButton.on "click", @importBatchItems
    @rulesButton.on "click", @showRules

  openImage: (evt)->
    evt.preventDefault()
    window.open $(@).attr "href"

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  putawayOrsoldout: ->
    id = $(@).data "id"
    AdminItems::parseData(id)

  putawayOrsoldoutBatch: ->
    array = $("table tbody input[type=checkbox]:checked")
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

  importBatchItems: ->
    itemImportModal = new Modal(itemsImportTemplate())
    itemImportModal.show()
    $("#modalItems form").validator
      isErrorOnParent: true
    $("#modalItems .form").on "submit", {"modal":itemImportModal}, AdminItems::submitBatchItems

  submitBatchItems: (evt)->
    evt.preventDefault()
    data = $("#modalItems form").serializeObject()
    itemImportModal = evt.data.modal
    $.ajax
     url: "/api/item/import"
     type: "POST"
     data: {itemCodes:data.itemCodes}
     success: (data)->
      itemImportModal.close()
      new Modal
        "icon": "success"
        "title": "批量导入商品成功"
        "content": "商品批量导入成功"
      .show ->
        window.location.href = "/admin/items"

  showRules: ->
    array = $("table tbody input[type=checkbox]:checked")
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
      if array.length >1
        AdminItems::showRulesModal(ids)
      else
        ruleId = $(array[0]).data "ruleid"
        AdminItems::showRulesModal(ids, ruleId)
  showRulesModal: (itemId, ruleId)->
    $.ajax
      url: "/api/rules/search"
      type: "GET"
      success: (data)->
        rulesModal = new Modal(rulesTemplate({data, ruleId, itemId}))
        rulesModal.show()
        $(".js-single-checkbox").on "click", AdminItems::chooseOneRule
        $(".js-vendoritems-add").on "click", {"modal": rulesModal}, AdminItems::chooseRule

  chooseOneRule: ->
    $("input[class=js-single-checkbox]").not(@).prop "checked", false

  chooseRule: (evt)->
    array = $(".profitsItems table tbody input[type=checkbox]:checked")
    itemIds = $(".profitsItems").data "itemid"
    modal = evt.data.modal
    if array.length>1
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "只能​选择一个规则"
      .show()
    else
      ruleId = _.map(array, (i)->
          $(i).val()
        ).join(",")
      $.ajax
        url: "/api/items/rule/create"
        type: "POST"
        data: {ruleId, itemIds}
        success: (data)->
          modal.close()
          new Modal
            "icon": "success"
            "title": "成功"
            "content": "添加成功"
          .show ->
            window.location.reload()

module.exports = AdminItems
