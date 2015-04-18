Modal = require "pokeball/components/modal"
$.ajaxSetup
  cache: false
  error: (jqXHR, textStatus, errorThrown) ->
    $("body").spin(false)
    if jqXHR.status is 401
      window.location.href = "/login"
    else
      new Modal
        "icon": "error"
        "content": jqXHR.responseText || "未知故障"
      .show()
