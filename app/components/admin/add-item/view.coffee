Modal = require "pokeball/components/modal"
firstitemsAttrTemplate = Handlebars.templates["admin/add-item/templates/first-item-attr"]
seconditemsAttrTemplate = Handlebars.templates["admin/add-item/templates/second-item-attr"]
thirditemsAttrTemplate = Handlebars.templates["admin/add-item/templates/third-item-attr"]

class AdminAddItem
  constructor: ($) ->
    @$itemform = $(".js-item-update")
    @$itemDetailDiv = $(".item-detail")
    @bindEvents()
    @loadItemDetail()

  that = this
  bindEvents: ->
    that = this
    @$itemform.validator
      isErrorOnParent: true
      errorCallback: (unvalidFields)->
        that.locationError()
    @$itemform.on "submit", @submitUpdate
    $("input[name=file].js-item-img").on "click", @fileUpload
    $("select[name=type]").on "change", @changeType
    $(document).on "change", ".js-changenext-attr", @changeAttribute

  loadItemDetail: ->
    $("#wysihtml5-editor").val(@$itemDetailDiv.data "detail")

  organizeItem: ->
    price = parseFloat($("input[name=price]").val()) * 100.00
    originPrice = parseFloat($("input[name=originPrice]").val()) * 100.00
    {
      type: $("select[name=type]").val()
      price: price
      itemCode: $("input[name=itemCode]").val()
      itemName: $("input[name=itemName]").val()
      buyLimit: $("input[name=buyLimit]").val()
      mainImage: $("input[name=mainImage]").val()
      originPrice: originPrice
    }

  organizeItemDetail: ->
    {
      image1: $("input[name=image1]").val()
      image2: $("input[name=image2]").val()
      image3: $("input[name=image3]").val()
      image4: $("input[name=image4]").val()
      freightSize: $("input[name=freightSize]").val()
      freightWeight: $("input[name=freightWeight]").val()
      packingList: $("#wysihtml5-editor").val()
    }

  submitUpdate: (evt)->
    evt.preventDefault()
    item = that.organizeItem()
    itemDetail = that.organizeItemDetail()
    firstAndSecondChoosed = that.checkFirstAndSecondLevelChoosed()
    itemAttributeMap = that.organizeItemAttr() if firstAndSecondChoosed
    if firstAndSecondChoosed and !_.isEmpty(itemAttributeMap)
      $.ajax
        url: "/api/item/create"
        type: "POST"
        data: {itemDto: JSON.stringify({item, itemDetail, itemAttributeMap})}
        success: (data)->
          new Modal
            "icon": "success"
            "title": "添加商品"
            "content": "添加商品成功"
          .show ->
            window.location.href = "/admin/items?itemCode=#{$("input[name=itemCode]").val()}"

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
        $imgshow.parent().removeClass("error empty")

  locationError: ->
    emptyPlaces = $(".note-error-empty")
    firstEmpty = that.getFirstError(emptyPlaces)
    if firstEmpty
      $("body").animate({scrollTop: firstEmpty.offsetTop})
    else
      errorPlaces = $(".note-error")
      firstError = that.getFirstError(errorPlaces)
      if firstError
        $("body").animate({scrollTop: firstError.offsetTop})

  getFirstError: (places) ->
    first = _.find(places, (i)->
      if i.offsetTop isnt 0
        i
    )

  changeType: ->
    typeMatchMap = {
      "1": 641,
      "2": 628,
      "3": 629,
      "4": 720,
      "5": 719,
      "6": 630,
      "7": 642
    }
    typeValue = typeMatchMap[$("select[name=type]").val()]
    if !typeValue
      that.deleteAttribute(0)
    else
      that.getAndShowAttrByCategoryId(typeValue, 0)

  getAndShowAttrByCategoryId: (parentId, deleteLevel)->
    $.ajax
      url: "/api/item/searchattr/byParentId"
      type: "POST"
      data:{parentId:parentId}
      success: (data)->
        dataLength = data.length
        that.deleteAttribute(deleteLevel)
        if dataLength > 0
          that.addAttribute(data, 1, "")
        else if dataLength is 0
          that.secondLevelToGetAndShowAttrByCategoryId(parentId, deleteLevel)

  secondLevelToGetAndShowAttrByCategoryId: (categoryId, deleteLevel) ->
    $.ajax
      url: "/api/item/searchattr/byCategoryId"
      type: "POST"
      data:{categoryId:categoryId}
      success: (data)->
        dataLength = data.length
        if dataLength > 0
          that.addAttribute(data, 2, "")

  thirdLevelToGetAndShowAttrByCategoryId: (categoryId, deleteLevel, attributeKey) ->
    $.ajax
      url: "/api/item/searchattr/byCategoryIdAndKey"
      type: "POST"
      data:{categoryId:categoryId, attributeKey:attributeKey}
      success: (data)->
        dataLength = data.length
        if dataLength > 0
          that.addAttribute(data, 3, attributeKey)

  addAttribute: (itemData, attrLevel, attributeKey)->
    if attrLevel is 1
      $(".item-attribute").append(firstitemsAttrTemplate(itemData:itemData))
    else if attrLevel is 2
      $(".item-attribute").append(seconditemsAttrTemplate(itemData:itemData))
    else if attrLevel is 3
      $(".item-attribute").append(thirditemsAttrTemplate(attributeKey:attributeKey,itemData:itemData))

  deleteAttribute: (deleteLevel) ->
    $(".single-attribute").eq(deleteLevel).nextAll().remove()
    if deleteLevel is 0
      $(".single-attribute").eq(deleteLevel).remove()

  changeAttribute: ->
    categoryId = $(@).data "categoryid"
    deleteLevel = $(@).parent().parent().parent().prevAll().length + 1
    if $(@).hasClass("firstLevel")
      $(@).parent().parent().parent().nextAll().remove()
      that.getAndShowAttrByCategoryId(categoryId, deleteLevel)
    else if $(@).hasClass("seconeLevel")
      attributeKey = $(@).val()
      secondLevelChoosed = that.checkSecondLevelChoosed(@, attributeKey)
      that.thirdLevelToGetAndShowAttrByCategoryId(categoryId, deleteLevel, attributeKey) if secondLevelChoosed

  checkSecondLevelChoosed: (_this, attributeKey)->
    if _this and _this.checked is false
      for i in $(".third-label-level")
        if $(i).data("attrkey") is attributeKey
          $(i).parent().remove()
      false
    else
      true

  organizeItemAttr: ->
    thirdLevelChoosed = true
    ItemAttr = {}
    firstLevelName = ""
    firstForgetKey = ""
    _.each $(".firstLevel-block"), (firstItem)->
      firstLevelAttr = $(firstItem).find("input[type=radio]:checked")
      if firstLevelAttr.length > 0
        firstLevelName = "#{firstLevelName}#{firstLevelAttr.data("name")} "
    ItemAttr["一级属性"] = firstLevelName
    _.each $(".thirdLevel-block"), (item)->
      labelAttributeKey = $(item).parent().children(".third-label-level").data("attrkey")
      thirdLevelAttr = $(item).find("input[type=radio]:checked")
      firstForgetKey = labelAttributeKey if !firstForgetKey and thirdLevelAttr.length is 0
      attributeKey = thirdLevelAttr.data("attrkey")
      attributeName = thirdLevelAttr.data("attrname")
      if thirdLevelAttr.length is 0
        thirdLevelChoosed = false
      else
        ItemAttr[attributeKey] = attributeName
    if firstForgetKey
      new Modal
        "icon": "error"
        "title": "信息不完整"
        "content": "请选择#{firstForgetKey}"
      .show()
    ItemAttr = if thirdLevelChoosed then ItemAttr else {}

  checkFirstAndSecondLevelChoosed: ->
    status = true
    _.each $(".firstLevel-block"), (firstItem)->
      firstLevelAttr = $(firstItem).find("input[type=radio]:checked")
      if firstLevelAttr.length is 0
        new Modal
          "icon": "error"
          "title": "信息不完整"
          "content": "请选择一级属性"
        .show()
        status = false
    _.each $(".secondLevel-block"), (secondItem)->
      secondLevelAttr = $(secondItem).find("input[type=checkbox]:checked")
      if secondLevelAttr.length is 0
        new Modal
          "icon": "error"
          "title": "信息不完整"
          "content": "请选择二级属性"
        .show()
        status = false
    if status
      if $(".firstLevel-block").length is 0 or $(".secondLevel-block").length is 0
        status = false
    status

module.exports = AdminAddItem
