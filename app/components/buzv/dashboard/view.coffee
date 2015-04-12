class BuzvDashboard
  constructor: ($) ->
    @$plot = $("#js-order-plot")
    @$numplot = $("#js-vendor-plot")
    @$sellplot = $("#js-sell-plot")
    @bindEvents()
    @loadPlotData()
  bindEvents: ->


  loadPlotData: ->
    $.ajax
      url: "/api/summary/commission"
      type: "GET"
      success: (data)->
        orderAmt = _.map(_.pluck(data, "orderAmt"), (item)->
          parseFloat(new Number(item/100).toFixed(2))
        )
        orderCount = _.pluck data, "orderCount"
        commissionAll =  _.map(_.pluck(data, "commissionAll"), (item)->
          parseFloat(new Number(item/100).toFixed(2))
        )
        commissionPay = _.map( _.pluck(data, "commissionPay"), (item)->
          parseFloat(new Number(item/100).toFixed(2))
        )
        dateArray = _.map(_.pluck(data, "calcDate"), (item)->
          new moment(item).format("MM-DD");
        )
        $("#js-order-plot").data "points", [commissionAll,commissionPay]
        $("#js-order-plot").data "date", dateArray
        $("#js-vendor-plot").data "points", [orderCount]
        $("#js-vendor-plot").data "date", dateArray
        $("#js-sell-plot").data "points", [orderAmt]
        $("#js-sell-plot").data "date", dateArray
        BuzvDashboard::renderCharts()
        BuzvDashboard::renderCharts2()
        BuzvDashboard::renderCharts3()

  renderCharts: (nameSeries)->
    if nameSeries is undefined
      nameSeries = []
      nameSeries[0] = "应付佣金"
      nameSeries[1] = "实付佣金"
    $("#js-order-plot").highcharts
      chart:
        type: "area"

      title:
        text: null

      xAxis:
        categories: $("#js-order-plot").data "date"

      yAxis:
        enabled: false
        title:
          text: null


      plotOptions:
        area:
          marker:
            enabled: false
            symbol: "circle"
            radius: 2
            states:
              hover:
                enabled: true


      series: [
        {
          name: nameSeries[0]
          data: $("#js-order-plot").data("points")[0]
          }, {
          name: nameSeries[1]
          data: $("#js-order-plot").data("points")[1]
        }
      ]

      credits:
        enabled: false

  renderCharts2: (nameSeries)->
    if nameSeries is undefined
      nameSeries = []
      nameSeries[0] = "订单量"
      nameSeries[1] = "数据2"
    $("#js-vendor-plot").highcharts
      chart:
        type: "area"

      title:
        text: null

      xAxis:
        categories: $("#js-vendor-plot").data "date"

      yAxis:
        enabled: false
        title:
          text: null

      tooltip:
        pointFormat: "{point.y:,.0f}"
        dateTimeLabelFormats:
          day: '%Y-%m-%d'

      plotOptions:
        area:
          marker:
            enabled: false
            symbol: "circle"
            radius: 2
            states:
              hover:
                enabled: true

      series: [
        {
          name: nameSeries[0]
          data: $("#js-vendor-plot").data("points")[0]
        }
      ]

      credits:
        enabled: false

  renderCharts3: (nameSeries)->
    if nameSeries is undefined
      nameSeries = []
      nameSeries[0] = "销售额"
      nameSeries[1] = "实付佣金"
    $("#js-sell-plot").highcharts
      chart:
        type: "area"

      title:
        text: null

      xAxis:
        categories: $("#js-sell-plot").data "date"

      yAxis:
        enabled: false
        title:
          text: null

      tooltip:
        pointFormat: "{point.y:,.0f}"
        dateTimeLabelFormats:
          day: '%Y-%m-%d'

      plotOptions:
        area:
          marker:
            enabled: false
            symbol: "circle"
            radius: 2
            states:
              hover:
                enabled: true

      series: [
        {
          name: nameSeries[0]
          data: $("#js-sell-plot").data("points")[0]
          }
      ]

      credits:
        enabled: false


module.exports = BuzvDashboard
