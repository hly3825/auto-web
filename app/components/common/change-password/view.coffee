Modal = require "pokeball/components/modal"
class ChangePassword
  constructor: ->
    $(".update-pasword-form").validator
      isErrorOnParent: true
    @confirmPassInput = $("#confirm-password")
    @passwordInput = $("#new-password")
    @bindEvent()
  that = this
  bindEvent: ->
    that = this
    @confirmPassInput.on "keyup", @confirmPassword
    @passwordInput.on "keyup", @passwordConfirm
    $(".update-pasword-form").on "submit", @submitNewPassword

  confirmPassword: ->
    password = that.passwordInput.val()
    confirmPassword = $(@).val()
    closestGroup = $(@).closest(".control-group")
    closestGroup.find(".note-error").hide()
    closestGroup.find(".note").show()
    if password isnt confirmPassword
      $(@).siblings(".note").hide()
      $(@).siblings(".note-error").show()
      $("button[type=submit]").attr("disabled", true)
    else
      $(@).siblings(".note").hide()
      $("button[type=submit]").removeAttr("disabled")

  passwordConfirm: ->
    if that.confirmPassInput.val() isnt ""
      password = $(@).val()
      confirmPassword = that.confirmPassInput.val()
      closestGroup = that.confirmPassInput.closest(".control-group")
      closestGroup.find(".note-error").hide()
      closestGroup.find(".note").show()
      if password isnt confirmPassword
        closestGroup.find(".note").hide()
        closestGroup.find(".note-error").show()
        $("button[type=submit]").attr("disabled", true)
      else
        closestGroup.find(".note").hide()
        $("button[type=submit]").removeAttr("disabled")

  submitNewPassword: ->
    $("body").spin("large")
    $.ajax
      url: "/api/user/change_password"
      type: "POST"
      data: $(@).serialize()
      success: (data)=>
        new Modal
          "icon": "success"
          "title": "修改密码成功！"
          "content": "修改密码成功！"
        .show()
        $(@).find("input").val("")
      error: (data) ->
        new Modal
          "icon": "error"
          "title": "修改密码失败"
          "content": data.responseText
        .show()
      complete: ->
        $("body").spin(false)

module.exports = ChangePassword
