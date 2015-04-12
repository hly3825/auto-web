Pagination = require "pokeball/components/pagination"
Modal = require "pokeball/components/modal"
applyPayTemplate = Handlebars.templates["buzv/pay-detail-now/templates/apply"]

class PayDetailNow
  constructor: ($) ->
    @batchButton = $(".js-batch-freeze")
    @$exportButton = $(".js-paydetail-exports")
    @$applyButton = $(".js-apply-pay")
    @bindEvents()

  bindEvents: ->
    new Pagination(".paydetailnow-pagination").total($(".paydetailnow-pagination").data("total")).show(20)
    $("table").on "click", ".js-status", @putawayOrsoldout
    @batchButton.on "click",  @putawayOrsoldoutBatch
    @$applyButton.on "click", @showApplyModal
    @$exportButton.on "click", @export

  showApplyModal: ->
    applyPayModal = new Modal(applyPayTemplate())
    applyPayModal.show()
    $(".modalApply .form").on "submit" ,PayDetailNow::toApplyPay

  toApplyPay: (evt)->
    evt.preventDefault()
    projectNo = $(".modalApply .form input[name=projectNo]").val()
    $.ajax
      url:"/api/pay/applyPay"
      type:"POST"
      data: {projectNo}
      success:  ->
        new Modal
          "icon": "success"
          "title": "成功"
          "content": "受理成功，申请审核中"
        .show ->
          window.location.reload()

  export: ->
    window.location.reload()

module.exports = PayDetailNow
