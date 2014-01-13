require 'cinch'
require_relative 'lib/cinch/plugins/stock_info'
require_relative 'lib/cinch/plugins/fifo'

bot = Cinch::Bot.new do
  configure do |c|
    c.server   = "irc.freenode.net"
    c.nick     = "rstocksbot_test"
    c.channels = ["#rStocksTest"]
    c.plugins.plugins = [
      Cinch::StockInfo,
      Cinch::Fifo
    ]

    c.plugins.options[Cinch::Fifo] = {
      :path => "cinch-fifo",
      :mode => 0666
    }

  end

end

bot.start

