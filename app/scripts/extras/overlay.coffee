$.fn.overlay = (options) ->
  defaults =
    opacity: 0.6
    backgroundColor: "#333"

  @each ->
    $this = $(this)
    minHeight = if $this.hasClass("btn-primary") then 0 else window.screen.height
    minWidth = if $this.hasClass("btn-primary") then 0 else window.screen.width
    # return if element has overlay
    if id = $this.data("overlay")
      # return if options is false and remove overlay
      $("##{id}").remove()
      $this.removeData("overlay")
    if options isnt false
      # set uniqueId to element
      id = _.uniqueId("overlay-")
      $this.data("overlay", id)
      options = $.extend defaults, options

      # append overlay to body
      $("<div>").css
        "top": $this.offset().top + "px"
        "left": $this.offset().left + "px"
        "width": $this.outerWidth() + "px"
        "height": $this.outerHeight() + "px"
        "min-height": minHeight + "px"
        "min-width": minWidth + "px"
        "z-index": "998"
        "opacity": options.opacity
        "position": "absolute"
        "filter": "progid:DXImageTransform.Microsoft.Alpha(opacity=#{options.opacity * 100})"
        "background-color": options.backgroundColor
      .attr
        "allowTransparency": "true"
        "id": id
        "class": "overlay-iframe"
        "scrolling": "no"
        "frameBorder": "0"
      .appendTo("body")
