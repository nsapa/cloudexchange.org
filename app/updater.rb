#!/usr/bin/env ruby

require '/usr/home/cloudexchange/cloudexchange.org/app/exchange'

exchange = Exchange.new
exchange.update_prices
