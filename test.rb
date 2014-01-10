require 'cinch/test'
require 'net/http'
require_relative 'lib/cinch/plugins/stock_info'

include Cinch::Test

tests = {
  '!info INTC' => ['test: PHOT: Last trade: 0.219, Ask-Bid: N/A - N/A, Day range: 0.18 - 0.253, Year range: 0.01 - 0.47']
}

module Net
  class HTTP
    def get_response(uri)
      case uri.to_s
      when "http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.quotes+where+symbol+%3D+%22INTC%22&env=http%3A%2F%2Fdatatables.org%2Falltables.env&format=json"
        '{"query":{"count":1,"created":"2014-01-10T23:35:00Z","lang":"en-US","results":{"quote":{"symbol":"INTC","Ask":"25.57","AverageDailyVolume":"31083500","Bid":"25.53","AskRealtime":"25.57","BidRealtime":"25.53","BookValue":"11.151","Change_PercentChange":"+0.22 - +0.87%","Change":"+0.22","Commission":null,"ChangeRealtime":"+0.22","AfterHoursChangeRealtime":"N/A - N/A","DividendShare":"0.90","LastTradeDate":"1/10/2014","TradeDate":null,"EarningsShare":"1.849","ErrorIndicationreturnedforsymbolchangedinvalid":null,"EPSEstimateCurrentYear":"1.90","EPSEstimateNextYear":"1.89","EPSEstimateNextQuarter":"0.42","DaysLow":"25.50","DaysHigh":"25.85","YearLow":"20.10","YearHigh":"26.04","HoldingsGainPercent":"- - -","AnnualizedGain":null,"HoldingsGain":null,"HoldingsGainPercentRealtime":"N/A - N/A","HoldingsGainRealtime":null,"MoreInfo":"cn","OrderBookRealtime":null,"MarketCapitalization":"126.9B","MarketCapRealtime":null,"EBITDA":"20.102B","ChangeFromYearLow":"+5.43","PercentChangeFromYearLow":"+27.01%","LastTradeRealtimeWithTime":"N/A - <b>25.53</b>","ChangePercentRealtime":"N/A - +0.87%","ChangeFromYearHigh":"-0.51","PercebtChangeFromYearHigh":"-1.96%","LastTradeWithTime":"Jan 10 - <b>25.53</b>","LastTradePriceOnly":"25.53","HighLimit":null,"LowLimit":null,"DaysRange":"25.50 - 25.85","DaysRangeRealtime":"N/A - N/A","FiftydayMovingAverage":"24.8158","TwoHundreddayMovingAverage":"23.7063","ChangeFromTwoHundreddayMovingAverage":"+1.8237","PercentChangeFromTwoHundreddayMovingAverage":"+7.69%","ChangeFromFiftydayMovingAverage":"+0.7142","PercentChangeFromFiftydayMovingAverage":"+2.88%","Name":"Intel Corporation","Notes":null,"Open":"25.51","PreviousClose":"25.31","PricePaid":null,"ChangeinPercent":"+0.87%","PriceSales":"2.40","PriceBook":"2.27","ExDividendDate":"Nov  5","PERatio":"13.69","DividendPayDate":"Dec  1","PERatioRealtime":null,"PEGRatio":"2.66","PriceEPSEstimateCurrentYear":"13.32","PriceEPSEstimateNextYear":"13.39","Symbol":"INTC","SharesOwned":null,"ShortRatio":"7.10","LastTradeTime":"4:00pm","TickerTrend":"&nbsp;===-==&nbsp;","OneyrTargetPrice":"24.50","Volume":"30611268","HoldingsValue":null,"HoldingsValueRealtime":null,"YearRange":"20.10 - 26.04","DaysValueChange":"- - +0.87%","DaysValueChangeRealtime":"N/A - N/A","StockExchange":"NasdaqNM","DividendYield":"3.56","PercentChange":"+0.87%"}}}}'
      else
        'uri not mocked'
      end
    end
  end
end



bot = make_bot(Cinch::Plugins::StockInfo)

ok = true
tests.each do |input, outputs|
  begin
    message = make_message(bot, input)
    replies = get_replies(message)
    if replies != outputs
      ok = false
      raise input + ' failed! Expected ' + outputs + ' but got ' + replies
    end
  rescue
  end
end
unless ok
  puts 'OK'
end

