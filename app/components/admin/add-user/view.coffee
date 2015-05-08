Modal = require "pokeball/components/modal"
class AddUser
  constructor: ($) ->
    @bindEvents()
    @init()

  bindEvents: ->
    $(".user-form").validator()
    $(".user-form").on "submit", @formSubmit
  init: ->
    @renderCompany()

  renderCompany: ->
    $.ajax
      url: "/api/company"
      type: "GET"
      success: (data)->
        $companySelect = $("select[name=companyId]").empty();
        $companySelect.append("""<option value="">请选择公司</option>""")
        _.each data, (item)->
          $companySelect.append("""<option value="#{item.id}">#{item.companyName}</option>""")
        companyId = $companySelect.data("id")
        if companyId isnt ""
          $companySelect.find("option[value=#{companyId}]").prop "selected", true

  formSubmit: (evt)=>
    evt.preventDefault()
    data = @organizeData()
    type = "POST"
    if $("input[name=id]").length is 1
      data.id = $("input[name=id]").val()
      type = "PUT"
    $("body").spin("large")
    $.ajax
      url: "/api/user/"
      type: type
      contentType: "application/json"
      data: JSON.stringify(data)
      success: (data)->
        window.location.href = "/admin/users"

  organizeData: ->
    user = $(".user-form").serializeObject()
    user


module.exports = AddUser
