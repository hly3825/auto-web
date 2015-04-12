require "pokeball"
require "extras/ajax"
require "extras/handlebars"
require "extras/cookie"
require "extras/overlay"

module.exports = ->
  Holder.addTheme("error", {background:"#ce193b", foreground: "white"});
  Holder.addTheme("warning", {background:"#fdab39", foreground: "white"});
  Holder.addTheme("success", {background:"#729755", foreground: "white"});
  Holder.addTheme("info", {background:"#303b86", foreground: "white"});
  require("pokeball/helpers/component").initialize()
