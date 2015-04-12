class bannerControl
  constructor: ($)->
    @carousels = $(".carousel")
    @bindEvents()
    @getMinHeight()
  bindEvents: ->
    @carousels.carousel()

  getMinHeight: =>
    @carousels.css("min-height", $(window).height())
    @carousels.height($(window).height())

module.exports = bannerControl
