Modal = require "pokeball/components/modal"
bankListTemplate = Handlebars.templates["buzv/add-vendor/templates/datalist"]

class BuzvAddvendor
  constructor: ($) ->
    @$vendorForm = $(".js-add-vendor")
    @$organizationValidDate = $("input[name=organizationValidDate]")
    @$businessLicenceValidDate = $("input[name=businessLicenceValidDate]")
    @$provinceSelect = $(".province-select")
    @$citySelect = $(".city-select")
    @$agentSelect = $(".link-agent-select")
    @usernameCheck = $("input[name=userName]")
    @$submitVendor = $(".js-submit-save")
    @bindEvents()
    @renderProvince()

  bindEvents: ->
    @$vendorForm.validator
      isErrorOnParent: true
      errorCallback: (unvalidFields)->
        BuzvAddvendor::locationError()
    @$vendorForm.on "submit", @submitAdd
    $("input[name=file]").on "click", @fileUpload
    @$organizationValidDate.datepicker()
    @$businessLicenceValidDate.datepicker()
    @$provinceSelect.on "change", @renderCity
    @$citySelect.on "change", @renderRegion
    @$agentSelect.on "change", @linkAgent
    @usernameCheck.on "change", @checkUsername
    @$submitVendor.on "click", @vendorSubmit
    $("input[name=bankName]").on "input propertychange", @bankSuggest
    $(document).on "click", ".js-bank-list",@setBankCode
    $(document).on "click", @hideBankList
    @linkAgent()
    @agentSuggest()

  organizeVendor: ->
    {
      id: $(".js-add-vendor").data "id"
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
      vendorType: $("select[name=vendorType]").val()
    }

  organizeVendorPaperwork: ->
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

  tempSave: ->
    vendor = BuzvAddvendor::organizeVendor()
    vendorPaperwork = BuzvAddvendor::organizeVendorPaperwork()
    userName = $("input[name=userName]").val()
    encryptedPassword = $("input[name=encryptedPassword]").val()
    agentId = $("input[name=agentId]").val()
    $.ajax
     url: "/api/vendor/tempsave"
     type: "POST"
     data: {vendorDto: JSON.stringify({vendor, vendorPaperwork, userName, encryptedPassword, agentId})}
     success: (data)->
      new Modal
        "icon": "success"
        "title": "暂存成功"
        "content": "商户已经暂存成功"
      .show ->
        window.location.href = "/buzv/vendors"

  vendorSubmit: ->
    $(".js-add-vendor").data "type", "submit"
    $(".js-add-vendor").submit()

  submitAdd: (evt)->
    evt.preventDefault()
    vendor = BuzvAddvendor::organizeVendor()
    vendorPaperwork = BuzvAddvendor::organizeVendorPaperwork()
    userName = $("input[name=userName]").val()
    encryptedPassword = $("input[name=encryptedPassword]").val()
    agentId = ""
    whichButton = $(@).data("type") is "submit"
    addVendor = "/api/vendor/add"
    submitVendor = "/api/vendor/submit"
    hasAgent = "1"
    if vendor.vendorType is hasAgent
      agentId = $("input[name=agentId]").val()
    url = if whichButton then submitVendor else addVendor
    $.ajax
     url: url
     type: "POST"
     data: {vendorDto: JSON.stringify({vendor, vendorPaperwork, userName, encryptedPassword, agentId})}
     success: (data)->
      if url is addVendor
        BuzvAddvendor::changeVendorSuccess(1)
      else if url is submitVendor
        BuzvAddvendor::changeVendorSuccess(2)

  changeVendorSuccess: (method) ->
    if method is 1 or method is 2
      if method is 1
        title = "保存商户信息成功"
        content = "商户信息已经保存成功"
      else if method is 2
        title = "提交审核成功"
        content = "商户已经提交审核成功"
      new Modal
          "icon": "success"
          "title": title
          "content": content
      .show ->
          window.location.href = "/buzv/vendors"

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
    $provinceSelect = $("select[name=provinceId]")
    $provinceSelect.empty().append("""<option value="">请选择省份..</option>""")
    $.ajax
      url: "/api/address/province"
      type: "GET"
      success: (data) ->
        _.each data, (item) =>
          $provinceSelect.append("""<option value="#{item.id}">#{item.name}</option>""")
      complete: ->
        BuzvAddvendor::renderCity()

  renderCity: ->
    $citySelect = $("select[name=cityId]")
    $citySelect.empty().append("""<option value="">请选择市..</option>""")
    provinceId = $("select[name=provinceId]").val()
    if provinceId
      $.ajax
        url: "/api/address/#{provinceId}/city"
        type: "GET"
        success: (data) ->
          _.each data, (item) =>
            $citySelect.append("""<option value="#{item.id}">#{item.name}</option>""")
        complete: ->
          BuzvAddvendor::renderRegion()
    else
      $("select[name=cityId]").empty().append("""<option value="">请选择市..</option>""")

  renderRegion: ->
    $regionSelect = $("select[name=regionId]")
    $regionSelect.empty().append("""<option value="">请选择区/县..</option>""")
    cityId = $("select[name=cityId]").val()
    if cityId
      $.ajax
        url: "/api/address/#{cityId}/area"
        type: "GET"
        success: (data) ->
          _.each data, (item) =>
            $regionSelect.append("""<option value="#{item.id}">#{item.name}</option>""")


  linkAgent: ->
    agentId = $(".link-agent").data("agentid")
    vendorType = $("select[name=vendorType]").val()
    hasAgent = "1"
    if vendorType is hasAgent
      $(".js-agent").show()
      $(".js-agent input").attr "required", true
    else
      $("input[name=agentId]").val("")
      $("input[name=agentName]").val("")
      $(".js-agent").hide()
      $(".js-agent input").attr "required", false
      $(".js-agent div").removeClass "error empty"

  locationError: ->
    emptyPlaces = $(".note-error-empty")
    firstEmpty = BuzvAddvendor::getFirstError(emptyPlaces)
    if firstEmpty
      $("body").animate({scrollTop: firstEmpty.offsetTop})
    else
      errorPlaces = $(".note-error")
      firstError = BuzvAddvendor::getFirstError(errorPlaces)
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

  #提示代理商
  agentSuggest: ->
    $("input[name=agentName]").suggest
      margin: {left: 0}
      url: "/api/mdm/agent/search?agentName="
      dataFormat: (data) ->
        array = []
        _.each data.data, (d) ->
          array.push d.name
        array
      callback: (text)->
        data = $("input[name=agentName]").data("source")
        _.each data.data, (d)->
          if text is d.name
            $("input[name=agentId]").val(d.id)

module.exports = BuzvAddvendor
