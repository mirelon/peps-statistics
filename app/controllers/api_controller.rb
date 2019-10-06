class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
    headers['Access-Control-Allow-Headers'] = 'Content-Type'
  end

  def options_add_performance
    puts 'options'
    head(:ok) if request.request_method == 'OPTIONS'
  end

  def add_performance
    responses = []
    params.each do |key, value|
      next unless key.is_a? String and value.is_a? String
      key_parts = key.split('_')
      value_parts = value.split('_')
      puts key_parts.inspect
      puts value_parts.inspect
      if key_parts.size == 5 and value_parts.size == 2
        subtest = Subtest.where(pismeno: key_parts[0]).first!
        pocet_mesiacov = key_parts[1].to_i
        meno = key_parts[2]
        priezvisko = key_parts[3]
        sex = key_parts[4]
        body = value_parts[0].to_i
        datum = Date.parse(value_parts[1])
        begin
          client = Client.where(meno: meno, priezvisko: priezvisko, sex: sex).first_or_create!
          session = client.sessions.where(datum: datum, months: pocet_mesiacov).first_or_create!
          session.performances.where(subtest: subtest).first_or_create!(body: body)
          puts "#{client.display_name} - #{subtest.pismeno} - #{body}"
        rescue ArgumentError => e
          responses << "#{key}: #{value} - #{e}"
        end
      end
    end
    render json: responses
  end

  def download_performances
    render json: (Performance.all.map do |performance|
      client = performance.client
      key = [performance.subtest.pismeno, performance.session.months, client.meno, client.priezvisko, client.sex].join('_')
      value = [performance.body.to_i, performance.datum.strftime('%y%m%d')].join('_')
      [key, value]
    end.to_h)
  end

end
