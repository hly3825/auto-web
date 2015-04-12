Modal = require "pokeball/components/modal"

class AdminAddRule
  constructor: ($) ->
    @$ruleForm = $(".js-add-rule")
    @bindEvents()

  bindEvents: ->
    @$ruleForm.validator
      isErrorOnParent: true
    @$ruleForm.on "submit", @submitAdd

  organizeRule: ->
    {
      id: $(".js-add-rule").data "id"
      type: $("select[name=type]").val()
      name: $("input[name=name]").val()
      vendorCommission: $("input[name=vendorCommission]").val()
    }

  submitAdd: (evt)->
    evt.preventDefault()
    rule = AdminAddRule::organizeRule()
    if rule.id is ""
      url = "/api/rule/create"
    else
      url = "/api/rule/update"
    $.ajax
     url: url
     type: "POST"
     data: {commissionRule: JSON.stringify(rule)}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "保存成功"
        "content": "规则保存成功"
      .show ->
        window.location.href = "/admin/profitsRule"

module.exports = AdminAddRule
