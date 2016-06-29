require_relative '../lib/all'

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
    @request = parse(raw_request)
    @params  = @request[:params]
    # Use the @request and @params ivars to full the request and return an appropriate response

    # YOUR CODE GOES BELOW HERE


    def get_user(all_users, id)
      all_users[id.to_i - 1]
    end

    if raw_request.nil? || raw_request.length.zero?
      raise "NO INPUT GIVEN"
    end

    users = [
      { :first_name=>"Bob", :last_name=>"Bobson", :age=>"69" },
      { :first_name=>"Tom", :last_name=>"Thompson", :age=>"17" },
      { :first_name=>"Jon", :last_name=>"Johnson", :age=>"33" }
    ]

# GET http://localhost:3000/users/1 HTTP/1.1
    begin
      response = parse(raw_request)


      if response[:params][:resource] == "users"
        if response[:params][:id]
          res_body = users[response[:params][:id].to_i] #:id needs to be an integer. It is a string.
          puts
          puts "#{res_body[:first_name]} #{res_body[:last_name]}, age: #{res_body[:age]}"
        else
          puts
          users.each.with_index do |user, index|
            puts "#{index + 1} - #{user[:first_name]} #{user[:last_name]}, age: #{user[:age]}"
          end
        end
      else
        puts
        puts "ERROR: USER NOT FOUND"
      end
    end

    puts
    puts @request.inspect
    puts
    # YOUR CODE GOES ABOVE HERE  ^
  end
end
