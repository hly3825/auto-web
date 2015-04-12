Handlebars.registerHelper 'pp', (json, options) ->
  JSON.stringify(json)

Handlebars.registerHelper 'add', (a,b, options) ->
  a + b

Handlebars.registerHelper "formatPrice", (price, type, options) ->
  return if not price?
  if type is 1
    formatedPrice = (price / 100)
    roundedPrice = parseInt(price / 100)
  else
    formatedPrice = (price / 100).toFixed(2)
    roundedPrice = parseInt(price / 100).toFixed(2)
  if `formatedPrice == roundedPrice` then roundedPrice else formatedPrice

Handlebars.registerHelper "formatDate", (date, type, options) ->
  return unless date
  switch type
    when "gmt" then moment(date).format("EEE MMM dd HH:mm:ss Z yyyy")
    when "day" then moment(date).format("YYYY-MM-DD")
    when "minute" then moment(date).format("YYYY-MM-DD HH:mm")
    else moment(date).format("YYYY-MM-DD HH:mm:ss")

Handlebars.registerHelper "lt", (a, b, options) ->
  if a < b
    options.fn(this)
  else
    options.inverse(this)

Handlebars.registerHelper "gt", (a, b, options) ->
  if a > b
    options.fn(this)
  else
    options.inverse(this)

Handlebars.registerHelper 'of', (a, b, options) ->
  values = if _.isArray b then b else b.split(",")
  if _.contains(values, a.toString()) or _.contains values, a
    options.fn(this)
  else
    options.inverse(this)

Handlebars.registerHelper 'length', (a, options) ->
  length = a.length

Handlebars.registerHelper "isArray", (a, options) ->
  if _.isArray a
    options.fn(this)
  else
    options.inverse(this)

Handlebars.registerHelper "between", (a, b, c, options) ->
  if a >= b and a <= c
    options.fn(this)
  else
    options.inverse(this)

Handlebars.registerHelper "multiple", (a, b, c, options) ->
  a * b / c

Handlebars.registerHelper "contain", (a, b, options) ->
  return options.inverse @ if a is undefined or b is undefined
  array = if _.isArray a then a else a.toString().split(",")
  if _.contains a, b then options.fn @ else options.inverse @

Handlebars.registerHelper "match", (a, b, options) ->
  return options.inverse @ if a is undefined or b is undefined
  if new RegExp(a).exec(b) is null then options.inverse @ else options.fn @

Handlebars.registerHelper "imgFormat", (picUrl, type, options) ->
  upaiyun = {
    "small": "!100x100",
    "big": "!245x245"
  }
  haier = {
    "small": "_80x80",
    "big": "_245x245"
  }
  return unless picUrl
  if picUrl
    if picUrl.indexOf("upaiyun")
      picUrl+upaiyun[type]
    else if picUrl.indexOf("27.223.70.101")
      picSplit = picUrl.split(".")
      picSuffix = picSplit[picSplit.length-1]
      picUrl+haier[type]+".#{picSuffix}"
