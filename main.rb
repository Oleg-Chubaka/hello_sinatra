require 'sinatra'
require 'json'
require 'csv'

get '/' do
  haml :hello
end

get '/calc.html' do
  haml :calc
end

post '/calc.html' do
  @expression = params[:expression] || ''
  @result = calc(@expression)
  haml :calc
end


helpers do
  def calc(expression)
    res_exp = expression.dup
    toggle = true
    while toggle
      exp = res_exp.scan(/\(?\s?\d+\.?\d*\s?[\+\-\*\/]\s?\d*\.?\d+\s?\)?/)[0]
      if exp.nil?
        toggle = false
      else
        nums = exp.scan(/\d+\.?\d*/).map(&:to_f)
        znak = exp.scan(/[\+\-\*\/]/)[0]
        res = ''
        if znak == '+'
          res = (nums[0]+nums[1]).to_s
        elsif znak == '-'
          res = (nums[0]-nums[1]).to_s
        elsif znak == '*'
          res = (nums[0]*nums[1]).to_s
        elsif znak == '/'
          res = (nums[0]/nums[1]).to_s
        end
        res_exp.gsub!(exp, res)
      end
    end
    if res_exp[-1] == '0' && res_exp[-2] == '.'
      res_exp[-2..-1] = ''
    end
    res_exp
  end
end