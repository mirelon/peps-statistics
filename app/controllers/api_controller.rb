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
      key_parts = key.split('_', -1)
      value_parts = value.split('_', -1)
      puts key_parts.inspect
      puts value_parts.inspect
      if (key_parts.size == 6 or key_parts.size == 5) and value_parts.size == 2
        subtest = Subtest.where(pismeno: key_parts[0]).first!
        pocet_mesiacov = key_parts[1].to_i
        meno = key_parts[2]
        priezvisko = key_parts[3]
        sex = key_parts[4]
        l2nazov = key_parts[5] || ''
        body = value_parts[0].to_i
        datum = Date.parse(value_parts[1])
        begin
          l2 = L2.where(nazov: l2nazov).first_or_create!
          client = Client.where(meno: meno, priezvisko: priezvisko, sex: sex, l2: l2).first_or_create!
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
      key = [performance.subtest.pismeno, performance.session.months, client.meno, client.priezvisko, client.sex, client.l2&.nazov].join('_')
      value = [performance.body.to_i, performance.session.datum.strftime('%y%m%d')].join('_')
      [key, value]
    end.to_h)
  end

  def download_l2s
    render json: { l2s: L2.all.map(&:nazov).join(',') }
  end

end
