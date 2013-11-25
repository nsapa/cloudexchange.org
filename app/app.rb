require 'rubygems'
require 'sinatra'
require 'erb'
require '/usr/home/cloudexchange/cloudexchange.org/app/exchange'

REGIONS = ['us-east-1', 'us-west-1', 'us-west-2', 'eu-west-1', 'sa-east-1', 'ap-northeast-1', 'ap-southeast-1', 'ap-southeast-2']
SYSTEMS = ['linux', 'windows']
INSTANCES = ['t1.micro', 'm1.small', 'm1.large', 'm1.xlarge', 'c1.medium', 'c1.xlarge', 'm2.xlarge', 'm2.2xlarge', 'm2.4xlarge']

get '/' do
  @which = 'eu-west-1.linux.t1.micro'
  erb :chart
end

get '/charts/:which.html' do
  @which = params[:which]
  erb :chart
end

get '/check' do
  'ok'
end

helpers do

  def short_region(name)
    case name
      when 'us-east-1' then 'us-e1'
      when 'us-west-1' then 'us-w1'
      when 'us-west-2' then 'us-w2'
      when 'eu-west-1' then 'eu-w1'
      when 'ap-southeast-1' then 'ap-s1'
      when 'ap-southeast-2' then 'ap-s2'
      when 'ap-northeast-1' then 'ap-n1'
      when 'sa-east-1' then 'sa-e1'
    end
  end

  def short_instance(name)
    case name
      when 't1.micro' then 't1.m'
      when 'm1.small' then 'm1.s'
      when 'm1.large' then 'm1.l'
      when 'm1.xlarge' then 'm1.xl'
      when 'c1.medium' then 'c1.m'
      when 'c1.xlarge' then 'c1.xl'
      when 'm2.xlarge' then 'm2.xl'
      when 'm2.2xlarge' then 'm2.2xl'
      when 'm2.4xlarge' then 'm2.4xl'
    end
  end

  def display(which)
    (['ec2'] + which.split('.', 3)).join(' | ')
  end

  def percent(which)
    if exchange.spot_price(which) !=0 and exchange.regular_price(which) !=0
	(exchange.spot_price(which) / exchange.regular_price(which) * 100).round
    else
	0
    end
  end

  def spot_price(which)
    '%.3f' % exchange.spot_price(which)
  end

  def exchange
    @exchange ||= Exchange.new
  end

end



