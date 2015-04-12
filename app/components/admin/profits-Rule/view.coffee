Modal = require "pokeball/components/modal"
Pagination = require "pokeball/components/pagination"
itemsTemplate = Handlebars.templates["admin/profits-Rule/templates/items"]

class AdminProfitsRule
  constructor: ($) ->
    @$additemsButtons = $(".js-batch-add-items")
    @$showitemsButton = $(".js-search-items")
    @$freezeButton = $(".js-batch-freeze")
    @bindEvents()

  bindEvents: ->
    new Pagination(".profitsrule-pagination").total($(".profitsrule-pagination").data("total")).show(20)
    @$additemsButtons.on "click", @additems
    @$showitemsButton.on "click", @showItems
    @$freezeButton.on "click", @freezeBatch

  freezeBatch: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个规则"
      .show()
    else
      ids = _.map(array, (i)->
          $(i).val()
        ).join(",")
      AdminProfitsRule::parseData(ids)

  parseData: (ids)->
    $.ajax
     url: "/api/rule/disable"
     type: "POST"
     data: {ruleIds:ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "停用/启用成功"
        "content": "规则停用/启用成功"
      .show ->
        window.location.href = "/admin/profitsRule"

  additems: ->
    AdminProfitsRule::showItemsModal $(@).data("id"), "add"

  showItems: ->
    AdminProfitsRule::showItemsModal $(@).data("id"), "show"

  showItemsModal: (ruleId, type)->
    if type is "add"
      url = "/api/rule/#{ruleId}/chooseitems"
    else
      url = "/api/rule/#{ruleId}/items"
    $.ajax
      url: url
      type: "GET"
      success: (data)->
        itemsModal = new Modal(itemsTemplate({data, ruleId, type}))
        itemsModal.show()
        $(".profitsRuleItem .js-link-click").on "click", AdminProfitsRule::openImage
        $(".js-vendor-items").change ->
          $(".profitsRuleItem .js-batch-checkbox").prop('checked', $(@).prop("checked"))
        $(".js-vendoritems-add").on "click", {"modal": itemsModal}, AdminProfitsRule::chooseItems

  openImage: (evt)->
    evt.preventDefault()
    window.open $(@).attr "href"

  chooseItems: (evt)->
    array = $(".profitsRuleItem table tbody input[type=checkbox]:checked")
    ruleId = $(".profitsRuleItem").data "id"
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
        data: {ruleId, itemIds}
        success: (data)->
          modal.close()
          new Modal
            "icon": "success"
            "title": "成功"
            "content": "添加成功"
          .show()

module.exports = AdminProfitsRule
