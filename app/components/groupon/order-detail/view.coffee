logisticsTemplates = Handlebars.templates["groupon/order-detail/templates/logistics"]
vominfoTemplates = Handlebars.templates["groupon/order-detail/templates/vominfo"]

class OrderDetail
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    @showLogisticsInfo()

  showLogisticsInfo:->
    logisticsInfoList = $(".logistics-info").data "logisticsinfo"
    vomInfoList = $(".js-show-vominfo").data "vominfo"
    if logisticsInfoList
      $(".js-show-logistics tbody").append(logisticsTemplates(logisticsInfoList: logisticsInfoList))
    if vomInfoList
      $(".js-show-vominfo tbody").append(vominfoTemplates(vomInfoList: vomInfoList))

module.exports = OrderDetail

