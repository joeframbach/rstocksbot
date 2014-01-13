require 'json'
require 'net/http'
require 'uri'

class Cinch::StockInfo
  include Cinch::Plugin

  match(/info (\S+)/, method: :info)

  class Yahoo
    def self.get_uri(symbol)
      uri = URI('http://query.yahooapis.com/v1/public/yql')
      params = {
        :q => 'select * from yahoo.finance.quotes where symbol = "' + symbol + '"',
        :env => 'http://datatables.org/alltables.env',
        :format => 'json'
      }
      uri.query = URI.encode_www_form(params)
      uri
    end

    def self.get(symbol)

      reply = nil

      begin
        uri = self.get_uri(symbol)
 
        res = Net::HTTP.get_response(uri)
        if res.is_a?(Net::HTTPSuccess)
          q = JSON.parse(res.body)
        end
      rescue
      end

      ['query','results','quote'].inject(q) { |ret, key| ret[key] || {} } || nil
    end

  end

  def info(m, symbol)
    quote = Yahoo.get(symbol)
    if quote.nil?
      m.reply(m.user.nick + ": Yahoo didn't respond. Trying again.")
      quote = Yahoo.get(symbol)
      if quote.nil?
        m.reply(m.user.nick + ": Yahoo didn't respond again. Sorry")
      end
    end
    unless quote.nil?
      q = lambda { |key| quote[key] || "N/A" }
      m.reply(m.user.nick + ": " \
        + symbol + ': ' \
        + 'Last trade: ' + q.call('LastTradePriceOnly') \
        + ', Ask-Bid: ' + q.call('Ask') + ' - ' + q.call('Bid') \
        + ', Day range: ' + q.call('DaysRange') \
        + ', Year range: ' + q.call('YearRange')
      )
    end
  end
end

