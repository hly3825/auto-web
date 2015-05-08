###
  优惠券管理组件
  author by terminus.io
###
Modal = require "pokeball/components/modal"
Pagination = require "pokeball/components/pagination"
class Users
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
    $(document).on "confirm:enable", @enable
    $(document).on "confirm:stop", @stop
    $(document).on "confirm:reset", @reset
    $(document).on "confirm:firstnotpass", @firstnotpassAlbum
    $(document).on "confirm:finalpass", @finalpassAlbum
    $(document).on "confirm:finalnotpass", @finalnotpassAlbum
    $(document).on "confirm:syn", @synAlbum

    $(document).on "keyup", @jsActivityOne, @activityOneKeyup
    $(document).on "keyup", @jsActivityTwo, @activityTwoKeyup
    $(document).on "click", @jsSelectImage, @selectImage

  enable: (evt, data)->
    $.ajax
      url: "/api/user/#{data}/enable"
      type: "PUT"
      success: ->
        window.location.reload()

  stop: (evt, data)->
    $.ajax
      url: "/api/user/#{data}/stop"
      type: "PUT"
      success: ->
        window.location.reload()

  reset: (evt, data)->
    $.ajax
      url: "/api/user/#{data}/reset"
      type: "PUT"
      success: ->
        new Modal
          "icon": "success"
          "title": "成功"
          "content": "密码重置成功"
        .show()

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



module.exports = Users
