Modal = require "pokeball/components/modal"
itemTemplate = Handlebars.templates["album/create_album/templates/item"]
addItemTemplate = Handlebars.templates["album/create_album/templates/add_item"]
class CreateAlbum
  constructor: ($) ->
    @bindEvents()
    @init()
  bindEvents: ->
    $("input[name=file][data-condition]").on "click", @fileUpload
    $("input[name=file][data-excel]").on "click", @excelUpload
    $(document).on "click", "input[name=file][data-idc]", @idcUpload
    $(".album-form").validator()
    $(".album-form").on "submit", @formSubmit
    $(document).on "click", ".js-go-up", @up
    $(document).on "click", ".js-go-down", @down
    $(document).on "click", ".js-go-delete", @delete
    $(document).on "click", ".js-add-item", @addItem

  init: ->
    if $("input[name='id']").length is 1
      $table = $("table.item-table")
      data = $table.data "json"
      _.each data, (i, index)->
        $("table.item-table tbody").append $(addItemTemplate({data:i}))

  up: ->
    $tr = $(@).closest("tr")
    $prev_tr = $tr.prev()
    $trs = $(@).closest("tr")
    index = $trs.index $tr
    if index isnt 1
      $tr.insertBefore $prev_tr

  down: ->
    $tr = $(@).closest("tr")
    $next_tr = $tr.next()
    $trs = $(@).closest("tr")
    index = $trs.index $tr
    if index isnt $trs.length
      $tr.insertAfter $next_tr

  delete: (evt)->
    $(@).closest("tr").remove()

  addItem: ->
    if $("table.item-table tbody tr").length is 20
      new Modal
        "icon": "info"
        "title": "无法添加"
        "content": "商品已达到最大数量20"
      .show()
      return
    $("table.item-table tbody").append $(addItemTemplate())

  fileUpload: ->
    _this = @
    $infoInput = $(_this).parent().siblings(".info-input")
    $imgshow = $(_this).parent().siblings(".img")
    $btncircle = $(_this).parent().closest(".btn-primary")
    picInfo = $(_this).data "condition"
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/files/upload"
      type: "POST"
      dataType: "json"
      formData: picInfo
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

  excelUpload: ->
    _this = @
    $btncircle = $(_this).parent().closest(".btn-success")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/items/excel/import"
      type: "POST"
      dataType: "json"
      success: (data)=>
        $("table.item-table tbody").children().remove()
        $("table.item-table tbody").append itemTemplate({data})
      complete: =>
        $btncircle.spin(false)

  idcUpload: ->
    _this = @
    $infoInput = $(_this).parent().siblings(".info-input")
    $imgshow = $(_this).parent().siblings(".img")
    $btncircle = $(_this).parent().closest(".btn-primary")
    $(@).fileupload
      "change": => $btncircle.spin("medium")
      url: "/api/idc/upload/img"
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

  formSubmit: (evt)=>
    evt.preventDefault()
    if !@checkData()
      return false
    data = @organizeData()
    type = "POST"
    if $("input[name=id]").length is 1
      data.id = $("input[name=id]").val()
      type = "PUT"
    $("body").spin("large")
    $.ajax
      url: "/api/albums/album"
      type: type
      contentType: "application/json"
      data: JSON.stringify(data)
      success: (data)->
        window.location.href = "/album/album-manage"

  checkData: ->
    debugger
    result = false;
    if $(":checkbox:checked").length > 3
      new Modal
            "icon": "error"
            "title": "最多选择三个标签"
            "content": "最多选择三个标签"
          .show()
      return result

    if $("table.item-table tbody tr").length is 0
      new Modal
            "icon": "error"
            "title": "请添加至少一个商品"
            "content": "请添加至少一个商品"
          .show()
      return result

    _.each $(".album-form table.item-table tbody tr"), (item)->
      taobaoId = $(item).find("input[name=taobaoId]").val()
      if _.isEmpty taobaoId
        return result
      mainImage = $(item).find("input[name=mainImage]").val()
      if _.isEmpty mainImage
        return result
      recommend =  $(item).find("input[name=recommend]").val()
      if _.isEmpty recommend
        return result
      if recommend.length <8 or recommend.length >20
        new Modal
          "icon": "error"
          "title": "错误"
          "content": "专辑推荐8-20字"
        .show()
        return result
      return result

    result = true

  organizeData: ->
    album = $(".album-form").serializeObject()
    if album.tag.length > 1
      album.tag = album.tag.join ","
    items = _.map $(".album-form table.item-table tbody tr"), (item, index)->
      id = $(item).data "id"
      taobaoId = $(item).find("input[name=taobaoId]").val()
      mainImage = $(item).find("input[name=mainImage]").val()
      recommend =  $(item).find("input[name=recommend]").val()
      {id, taobaoId, mainImage, recommend, index}

    {album, items}

module.exports = CreateAlbum
