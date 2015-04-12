class Login
  constructor: ($) ->
    @$userLoginForm = $(".form-login")
    @loginName = $("#login-name")
    @loginPassword = $("#login-passwd")
    @bindEvents()

  that = this
  bindEvents: ->
    that = this
    @$userLoginForm.on "submit", @loginFormSubmit
    @renderNick()

  loginFormSubmit: (evt)->
    evt.preventDefault()
    remember = $(".js-remember-username").is(":checked")
    loginFormMessage = $(@).serialize()+"&remember="+remember
    $.ajax
      url: "/api/user/login"
      type: "POST"
      data: loginFormMessage
      success: (data)->
        if data is ""
          href = "/"
        else
          href = data
        window.location.href = href

  renderNick: ->
      if $.cookie('nick')
        $("#login-name").val($.cookie('nick'))

module.exports = Login
