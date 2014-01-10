require 'cinch'
require_relative 'lib/cinch/plugins/stock_info'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.freenode.net"
    c.nick     = "rstocksbot_test"
    c.channels = ["#rStocks","#rStocksTest"]
    c.plugins.plugins = [
      Cinch::Plugins::StockInfo
    ]

  end

end

bot.start
