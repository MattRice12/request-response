require_relative '../lib/all'

class User
  attr_accessor :first_name, :last_name, :age
  def initialize(first_name, last_name, age)
    @first_name = first_name
    @last_name = last_name
    @age = age
  end
end

class Parser
  def parse_params(uri_fragments, query_param_string)
    params = {}
    params[:resource]  = uri_fragments[3]
    params[:id]        = uri_fragments[4]
    params[:action]    = uri_fragments[5]
    if query_param_string
      param_pairs = query_param_string.split('&')
      param_k_v   = param_pairs.map { |param_pair| param_pair.split('=') }
      param_k_v.each do |k, v|
        params.store(k.to_sym, v)
      end
    end
    params
  end

  # You shouldn't need to touch anything in these methods.
  def parse(raw_request)
    pieces = raw_request.split(' ')
    method = pieces[0]
    uri    = pieces[1]
    http_v = pieces[2]
    route, query_param_string = uri.split('?')
    uri_fragments = route.split('/')
    protocol = uri_fragments[0][0..-2]
    full_url = uri_fragments[2]
    subdomain, domain_name, tld = full_url.split('.')
    params = parse_params(uri_fragments, query_param_string)
    return {
      method: method,
      uri: uri,
      http_version: http_v,
      protocol: protocol,
      subdomain: subdomain,
      domain_name: domain_name,
      tld: tld,
      full_url: full_url,
      params: params
    }
  end
end

class Server
  system('clear')
  loop do
    print "Supply a valid HTTP Request URL (h for help, q to quit) > "
    raw_request = gets.chomp

    case raw_request
    when 'q' then puts "Goodbye!"; exit
    when 'h'
      puts "A valid HTTP Request looks like:"
      puts "\t'GET http://localhost:3000/students HTTP/1.1'"
      puts "Read more at : http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html"
    else
      if raw_request.nil? || raw_request.length.zero?
        raise "NO INPUT GIVEN"
      else
        users = [
          User.new("Bob", "Bobson", "69"),
          User.new("Tom", "Thompson", "17"),
          User.new("Jon", "Johnson", "33"),
          User.new("Sam", "Sampson", "239"),
          User.new("Aaron", "Ankles", "42"),
          User.new("Beardy", "Moustache", "22"),
          User.new("Carly", "Confetti", "16"),
          User.new("David", "Divad", "40"),
          User.new("Eric", "Elephant", "99"),
          User.new("Facey", "McFace", "39"),
          User.new("Gary", "Gorillahands", "1"),
          User.new("Happy", "McSad", "21"),
          User.new("Ingrid", "Icebutt", "55"),
          User.new("Julie", "Jorleandriclandermanduh", "61"),
          User.new("Kandi", "Krush", "18"),
          User.new("Lemon", "Party", "69"),
          User.new("Matthew", "Matthews", "0"),
          User.new("Nathaniel", "Leinahtan", "14"),
          User.new("Oprah", "Losefrey", "49"),
          User.new("Pepper", "Roni", "10101")
        ]
        @request = Parser.new.parse(raw_request)
        @params  = @request[:params]
      # Use the @request and @params ivars to full the request and return an appropriate response

      # YOUR CODE GOES BELOW HERE

      begin
        response = @request
# GET http://localhost:3000/users HTTP/1.1
# GET http://localhost:3000/users/1 HTTP/1.1
# GET http://localhost:3000/users/9999999 HTTP/1.1
# GET http://localhost:3000/users?first_name=s
# GET http://localhost:3000/users?limit=10&offset=10

        if response[:params][:resource] == "users"
          if (response[:params][:id].to_i) > users.count
            puts
            puts "404 NOT FOUND"
          elsif response[:params][:id]
            res_body = users[response[:params][:id].to_i - 1]
            puts
            puts "#{res_body.first_name} #{res_body.last_name}, age: #{res_body.age}"

          # elsif response[:params][:first_name]
          #   users.each do |first_name|
          #     first_name.each do |first_letter|
          #       first_letter = user

          else
            puts
            users.each.with_index do |user, index|
              puts "#{index + 1} - #{user.first_name} #{user.last_name}, age: #{user.age}"
            end
          end
        end

      rescue StandardError => error
        raise "500 Server Error"
        puts
        puts error.inspect
      end
      puts
      puts @request.inspect
      puts
      # YOUR CODE GOES ABOVE HERE  ^
      end
    end
  end
end
