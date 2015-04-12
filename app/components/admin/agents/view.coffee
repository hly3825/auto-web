Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"

class AdminAgents
  constructor: ($) ->
    @selectAll = $(".js-select-all")
    @deleteButton = $(".js-delete-agent")
    @bindEvents()

  bindEvents: ->
    new Pagination(".agents-pagination").total($(".agents-pagination").data("total")).show(20)
    @selectAll.on "change", @toggleAllCheckbox
    @deleteButton.on "click", @deleteBatch

  deleteBatch: ->
    array = $("table tbody input[type=checkbox]:checked")
    if array.length is 0
      new Modal
        "icon": "error"
        "title": "错误"
        "content": "请至少选择一个代理商"
      .show()
    else
      statusArray = _.reject(array, (i)->
          status = $(i).data("status")
          status is 0 or status is "" or status is -1
        )
      if statusArray.length > 0
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "请不要选择审核中或者审核通过的代理商"
        .show()
      else
        ids = _.map(array, (i)->
            $(i).val()
          ).join(",")
        AdminAgents::parseData(ids)

  parseData: (ids)->
    $.ajax
     url: "/api/agent/delete"
     type: "POST"
     data: {agentIds:ids}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "删除成功"
        "content": "代理商删除成功"
      .show ->
        window.location.href = "/admin/agents"
     error: (data) ->
      new Modal
          "icon": "error"
          "title": "错误"
          "content": "请选择状态为“已保存”或者审核不通过的代理商进行删除"
      .show()

  toggleAllCheckbox: ->
    $(".js-batch-checkbox").prop('checked', $(@).prop("checked"))

module.exports = AdminAgents
