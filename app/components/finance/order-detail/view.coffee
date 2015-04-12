logisticsTemplates = Handlebars.templates["groupon/order-detail/templates/logistics"]

class OrderDetail
  constructor: ($) ->
    @bindEvents()

  bindEvents: ->
    @showLogisticsInfo()

  showLogisticsInfo:->
    logisticsInfoList = $(".logistics-info").data "logisticsinfo"
    if logisticsInfoList
      $(".js-show-logistics tbody").append(logisticsTemplates(logisticsInfoList: logisticsInfoList))

module.exports = OrderDetail

