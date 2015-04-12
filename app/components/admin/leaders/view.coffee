Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
itemsImportTemplate = Handlebars.templates["admin/items/templates/import"]

class AdminLeaders
  constructor: ($) ->
    @batchButton = $(".js-batch-freeze")
    @selectAll = $(".js-select-all")
    @bindEvents()

  bindEvents: ->
    new Pagination(".leaders-pagination").total($(".leaders-pagination").data("total")).show(20)
    $("table").on "click", ".js-freeze", @freezeOrStart
    @batchButton.on "click",  @freezeOrStartBatch
    @selectAll.on "change", @toggleAllCheckbox

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

  freezeOrStart: ->
    id = $(@).data "id"
    AdminLeaders::parseData(id)

  freezeOrStartBatch: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个总部"
      .show()
    else
      ids = _.map(array, (i)->
          $(i).val()
        ).join(",")
      AdminLeaders::parseData(ids)

  parseData: (ids)->
    $.ajax
     url: "/api/leader/frozen"
     type: "POST"
     data: {"leaderIds":ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "操作成功"
        "content": "操作成功"
      .show ->
        window.location.href = "/admin/leaders"

module.exports = AdminLeaders
