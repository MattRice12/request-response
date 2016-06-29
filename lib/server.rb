require_relative '../lib/user'

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
# GET http://localhost:3000/users?limit=10&offset=10

        if response[:params][:resource] == "users" #404 error if users requested is > users listed
          if (response[:params][:id].to_i) > users.count
            puts
            puts "404 NOT FOUND"

          elsif response[:params][:id] #selects user at position stated in :id
            res_body = users[response[:params][:id].to_i - 1]
            puts
            puts "#{res_body.first_name} #{res_body.last_name}, age: #{res_body.age}"

          elsif response[:params][:limit] #selects everyone but after users stated by :limit
            after_ten = response[:params][:limit].to_i
              users[after_ten..-1].select.with_index do |user, index|
                puts "#{index + after_ten + 1} - #{user.first_name} #{user.last_name}, age: #{user.age}"
              end
          else # lists all users
            puts
            users.each.with_index do |user, index|
              puts "#{index + 1} - #{user.first_name} #{user.last_name}, age: #{user.age}"
            end
          end
        end

      rescue StandardError => error #500 error when something breaks
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
