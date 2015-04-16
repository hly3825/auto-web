###
  优惠券管理组件
  author by terminus.io
###
Modal = require "pokeball/components/modal"
Pagination = require "pokeball/components/pagination"
class Album
  constructor: ($)->
    @$jsCouponNew = $(".js-coupon-new")
    @couponForm = ".coupon-form"
    @$jsCouponEdit = $(".js-edit-coupon")
    @jsActivityOne = ".activity-one"
    @jsActivityTwo = ".activity-two"
    @jsSelectImage = ".js-select-image"
    @bindEvent()

  bindEvent: ->
    new Pagination(".album-pagination").total($(".album-pagination").data("total")).show()
    @$jsCouponNew.on "click", @newCoupon
    @$jsCouponEdit.on "click", @editCoupon
    $(document).on "confirm:release", @releaseAlbum
    $(document).on "confirm:delete", @deleteAlbum
    $(document).on "confirm:firstpass", @firstpassAlbum
    $(document).on "confirm:firstnotpass", @firstnotpassAlbum
    $(document).on "confirm:finalpass", @finalpassAlbum
    $(document).on "confirm:finalnotpass", @finalnotpassAlbum
    $(document).on "confirm:syn", @synAlbum

    $(document).on "keyup", @jsActivityOne, @activityOneKeyup
    $(document).on "keyup", @jsActivityTwo, @activityTwoKeyup
    $(document).on "click", @jsSelectImage, @selectImage

  ###
    新建优惠券
  ###
  newCoupon: (evt)=>
    couponModal = new Modal couponTemplate()
    couponModal.show()
    @initForm()

  selectImage: ->
    new Modal
      toggle: "image-selector"
    .show (image_url)->
      $("input[name='picture']").val image_url

  ###
    修改优惠券
  ###
  editCoupon: (evt)=>
    couponModal = new Modal couponTemplate({data: $(evt.currentTarget).closest("tr").data("coupon")})
    couponModal.show()
    @initForm()

  initForm: =>
    $(".coupon-form .js-coupon-type").on "change", @changeCouponType
    $(".datepicker").datepicker({yearRange: [2014, 2215]})
    $(".coupon-form").validator()
    $(".coupon-form").on "submit", @couponFormSubmit

  changeCouponType: (evt)=>
    switch $(evt.currentTarget).val()
      when "2"
        $(".coupon-form .js-item-list,.js-shop-list").addClass("hide")
        $(".coupon-form input[name=itemId],input[name=sellerId]").removeAttr "required"
        $(".coupon-form .limit-count-condition").removeClass("hide")
        $(".coupon-form .per-money-label").removeClass("hide")
      when "1"
        $(".coupon-form .js-item-list").addClass("hide")
        $(".coupon-form input[name=itemId]").removeAttr "required"
        $(".coupon-form .js-shop-list").removeClass("hide")
        $(".coupon-form input[name=sellerId]").attr "required", "required"
        $(".coupon-form .limit-count-condition").removeClass("hide")
        $(".coupon-form .per-money-label").removeClass("hide")
      when "3"
        $(".coupon-form .js-item-list").removeClass("hide")
        $(".coupon-form input[name=itemId]").attr "required", "required"
        $(".coupon-form .js-shop-list").addClass("hide")
        $(".coupon-form input[name=sellerId]").removeAttr "required"
        $(".coupon-form .limit-count-condition").addClass("hide")
        $(".coupon-form .per-money-label").addClass("hide")
    $(".coupon-form").off().validator()
    $(".coupon-form").on "submit", @couponFormSubmit

  ###
    优惠券表单提交
  ###
  couponFormSubmit: (evt)=>
    evt.preventDefault()
    type = if $("input[name=id]").length is 1 then "PUT" else "POST"
    data = @organizeCoupon()
    $.ajax
      url: "/api/admin/coupon"
      type: type
      data: JSON.stringify(data)
      contentType: "application/json"
      success: (data)->
        window.location.reload()

  ###
    组装优惠券表单数据
  ###
  organizeCoupon: ->
    couponObject = $(".coupon-form").serializeObject()
    couponObject.discount *= 100
    couponObject.baseMoney *= 100
    couponObject.perMoney *= 100 if couponObject.perMoney
    data =
      if $("input[name=id]").length is 1
        couponObject
      else
        {sellerIds: couponObject.sellerIds, itemIds: couponObject.itemIds, couponDefinition: couponObject}


  releaseAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/release"
      type: "PUT"
      success: ->
        window.location.reload()

  deleteAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/delete"
      type: "DELETE"
      success: ->
        window.location.reload()

  firstpassAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/true/firstcheck"
      type: "PUT"
      success: ->
        window.location.reload()

  firstnotpassAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/false/firstcheck"
      type: "PUT"
      success: ->
        window.location.reload()

  finalpassAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/true/finalcheck"
      type: "PUT"
      success: ->
        window.location.reload()

  finalnotpassAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/false/finalcheck"
      type: "PUT"
      success: ->
        window.location.reload()
  synAlbum: (evt, data)->
    $.ajax
      url: "/api/albums/#{data}/synchronous"
      type: "PUT"
      success: ->
        window.location.reload()
  #互斥券定义1
  activityOneKeyup: ->
    isTrue = _.some($(".activity-one"), (input)-> if $(input).val() then true else false)
    if !isTrue
      $(".activity-two").val("").prop "disabled", false
    else
      $(".activity-two").val("").prop "disabled", true

  #互斥券定义2
  activityTwoKeyup: ->
    if $(@).val() is ""
      $(".activity-one").val("").prop "disabled", false
    else
      $(".activity-one").val("").prop "disabled", true


module.exports = Album
