Modal = require "pokeball/components/modal"
bankListTemplate = Handlebars.templates["admin/add-agent/templates/datalist"]

class AdminAddAgent
  constructor: ($) ->
    @$vendorForm = $(".js-add-agent")
    @$organizationValidDate = $("input[name=organizationValidDate]")
    @$businessLicenceValidDate = $("input[name=businessLicenceValidDate]")
    @$tempSaveButton = $(".js-temp-save")
    @$provinceSelect = $(".province-select")
    @$citySelect = $(".city-select")
    @usernameCheck = $("input[name=userName]")
    @$submitAgent = $(".js-submit-save")
    @bindEvents()
    @renderProvince()
    @renderCity()
    @renderRegion()

  bindEvents: ->
    @$vendorForm.validator
      isErrorOnParent: true
      errorCallback: (unvalidFields)->
        AdminAddAgent::locationError()
    @$vendorForm.on "submit", @submitAdd
    $("input[name=file]").on "click", @fileUpload
    @$tempSaveButton.on "click", @tempSave
    @$organizationValidDate.datepicker()
    @$businessLicenceValidDate.datepicker()
    @$provinceSelect.on "change", @renderCity
    @$citySelect.on "change", @renderRegion
    @usernameCheck.on "change", @checkUsername
    @$submitAgent.on "click", @agentSubmit
    $("input[name=bankName]").on "input propertychange", @bankSuggest
    $(document).on "click", ".js-bank-list",@setBankCode
    $(document).on "click", @hideBankList

  organizeAgent: ->
    {
      id: $(".js-add-agent").data "id"
      zipCode: $("input[name=zipCode]").val()
      vendorName: $("input[name=vendorName]").val()
      phone: $("input[name=phone]").val()
      legalPerson: $("input[name=legalPerson]").val()
      fax: $("input[name=fax]").val()
      provinceId: $("select[name=provinceId]").val()
      cityId: $("select[name=cityId]").val()
      regionId: $("select[name=regionId]").val()
      stree: $("input[name=stree]").val()
      legalMobile: $("input[name=legalMobile]").val()
      nature: $("select[name=nature]").val()
      email: $("input[name=email]").val()
      taxCode: $("input[name=taxCode]").val()
      accountHolderName: $("input[name=accountHolderName]").val()
      bankAccountNum: $("input[name=bankAccountNum]").val()
      bankName: $("input[name=bankName]").val()
      bankBranchCode: $("input[name=bankBranchCode]").val()
      verdorType: $("select[name=verdorType]").val()
    }

  organizeAgentPaperwork: ->
    {
      businessLicenceCode: $("input[name=businessLicenceCode]").val()
      businessLicenceValidDate: $("input[name=businessLicenceValidDate]").val()
      businessLicence: $("input[name=businessLicence]").val()
      taxCertificateCode: $("input[name=taxCertificateCode]").val()
      taxCertificate: $("input[name=taxCertificate]").val()
      accountPermit: $("input[name=accountPermit]").val()
      organization: $("input[name=organization]").val()
      organizationValidDate: $("input[name=organizationValidDate]").val()
      organizationCode: $("input[name=organizationCode]").val()
      corporateIdentityCode: $("input[name=corporateIdentityCode]").val()
      corporateIdentity: $("input[name=corporateIdentity]").val()
      corporateIdentityB: $("input[name=corporateIdentityB]").val()
      contractImage1: $("input[name=contractImage1]").val()
      contractImage2: $("input[name=contractImage2]").val()
    }

  agentSubmit: ->
    $(".js-add-agent").data "type", "submit"
    $(".js-add-agent").submit()

  submitAdd: (evt)->
    evt.preventDefault()
    vendor = AdminAddAgent::organizeAgent()
    vendorPaperwork = AdminAddAgent::organizeAgentPaperwork()
    userName = $("input[name=userName]").val()
    encryptedPassword = $("input[name=encryptedPassword]").val()
    whichButton = $(@).data("type") is "submit"
    addAgent = "/api/agent/add"
    submitAgent = "/api/agent/submit"
    url = if whichButton then submitAgent else addAgent
    $.ajax
      url: url
      type: "POST"
      data: {vendorDto: JSON.stringify({vendor, vendorPaperwork, userName, encryptedPassword})}
      success: (data)->
        if url is addAgent
          AdminAddAgent::changeAgentSuccess(1)
        else if url is submitAgent
          AdminAddAgent::changeAgentSuccess(2)

  changeAgentSuccess: (method) ->
    if method is 1 or method is 2
      if method is 1
        title = "保存代理商信息成功"
        content = "代理商信息已经保存成功"
      else if method is 2
        title = "提交审核成功"
        content = "代理商已经提交审核成功"
      new Modal
        "icon": "success"
        "title": title
        "content": content
      .show ->
          window.location.href = "/admin/agents"

  fileUpload: ->
    _this = @
    $infoInput = $(_this).parent().siblings(".info-input")
    $imgshow = $(_this).parent().siblings(".img")
    $btncircle = $(_this).parent().closest(".btn-primary")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/files/upload"
      type: "POST"
      dataType: "json"
      success: (data)=>
        $infoInput.val(data.url).change()
        $imgshow.attr "src", data.url
      submit: (e, data)=>
        unless /(\.|\/)(gif|jpe?g|png)$/.test(data.originalFiles[0].name)
          new Modal
            "icon": "error"
            "title": "上传失败"
            "content": "请选择正确格式图片"
          .show()
          e.preventDefault()
      complete: =>
        $btncircle.spin(false)
        $imgshow.parent().removeClass(" error empty")

  renderProvince: ->
    $.ajax
      url: "/api/address/province"
      type: "GET"
      success: (data)->
        $provinceSelect = $("select[name=provinceId]").empty();
        $provinceSelect.append("""<option value="">请选择省份</option>""")
        _.each data, (item)->
          $provinceSelect.append("""<option value="#{item.id}">#{item.name}</option>""")
        provinceId = $provinceSelect.data("id")
        if provinceId isnt ""
          $provinceSelect.find("option[value=#{provinceId}]").prop "selected", true

  renderCity: (evt)->
    if evt
      provinceId = $("select[name=provinceId]").val()
      $regionSelect = $("select[name=regionId]").empty();
      $regionSelect.append("""<option value="">请选择区/县..</option>""")
    else
      provinceId = $("select[name=provinceId]").data "id"
    if provinceId isnt ""
      $.ajax
        url: "/api/address/#{provinceId}/city"
        type: "GET"
        success: (data)->
          $citySelect = $("select[name=cityId]").empty();
          $citySelect.append("""<option value="">请选择市..</option>""")
          _.each data, (item)->
            $citySelect.append("""<option value="#{item.id}">#{item.name}</option>""")
          cityId = $citySelect.data("id")
          if cityId isnt ""
            $citySelect.find("option[value=#{cityId}]").prop "selected", true

  renderRegion: (evt)->
    if evt
      cityId = $("select[name=cityId]").val()
    else
      cityId = $("select[name=cityId]").data "id"
    if cityId isnt ""
      $.ajax
        url: "/api/address/#{cityId}/area"
        type: "GET"
        success: (data)->
          $regionSelect = $("select[name=regionId]").empty();
          $regionSelect.append("""<option value="">请选择区/县..</option>""")
          _.each data, (item)->
            $regionSelect.append("""<option value="#{item.id}">#{item.name}</option>""")
          regionId = $regionSelect.data("id")
          if regionId isnt ""
            $regionSelect.find("option[value=#{regionId}]").prop "selected", true

  checkUsername: ->
    name = $("input[name=userName]")
    $.ajax
      url: "/"
      type: "POST"
      data:{name:name.val()}
      error: (data) ->
        name.focus().siblings(".note-error").show()
      success: (data) ->
        name.siblings(".note-error").hide()

  locationError: ->
    emptyPlaces = $(".note-error-empty")
    firstEmpty = AdminAddAgent::getFirstError(emptyPlaces)
    if firstEmpty
      $("body").animate({scrollTop: firstEmpty.offsetTop})
    else
      errorPlaces = $(".note-error")
      firstError = AdminAddAgent::getFirstError(errorPlaces)
      if firstError
        $("body").animate({scrollTop: firstError.offsetTop})

  getFirstError: (places) ->
    first = _.find(places, (i)->
      if i.offsetTop isnt 0
        i
    )

  #提示银行名
  bankSuggest: ->
    $banklList = $("#bank-list")
    $banklList.empty()
    bankName = $("input[name=bankName]").val()
    $("input[name=bankBranchCode]").val("")
    inputLocationTop = @.offsetTop + 28
    inputLocationLeft = @.offsetLeft
    $.ajax
      url: "/api/mdm/bank/search"
      type: "POST"
      data: {bankName}
      success: (data) ->
        $("#bank-list").remove()
        $("body").append(bankListTemplate(inputLocationTop:inputLocationTop, inputLocationLeft:inputLocationLeft, bankListData:data.data))

  #设置银行码
  setBankCode: ->
    $bankCode = $("input[name=bankBranchCode]")
    $bankName = $("input[name=bankName]")
    thisbankName = $(@).data "bankname"
    thisbankCode = $(@).data "bankcode"
    $("#bank-list").remove()
    if thisbankName && thisbankCode
      $bankName.val(thisbankName)
      $bankCode.val(thisbankCode)
      $bankName.parent().removeClass "error empty"
      $bankCode.parent().removeClass "error empty"
    else
      $("#bank-list").remove()
      $bankName.parent().addClass "error empty"
      $bankCode.parent().addClass "error empty"

  hideBankList: ->
    $("#bank-list").remove()

module.exports = AdminAddAgent
