require 'socket'
require 'json'
require 'pry'
require_relative '../config/router'
require_relative '../lib/all'

system('clear')

# Initialize a TCPServer object that will listen
# on localhost:3001 for incoming connections.
server = TCPServer.new('localhost', 3001)
puts "The server is running and awaiting requests at http://localhost:3001/"

request_count = 0
loop do
  request = ""

  # Wait until a client connects, then return a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects. (In fact, TCPSocket is a subclass of IO.)
  socket = server.accept

  request += socket.gets

  if request.split(/ /)[1] == "/favicon.ico" #Just skip favicon requests
    socket.close
    next
  end

  request_count += 1

  if request.split(/ /).first == "GET"
    while "\r\n" != (line = socket.gets) do
      request += line
    end
  else
    until (line = socket.gets) =~ /--\r\n/ do
      request += line # Read the first line of the request (the Request-Line)
    end
  end


  request_headers, *request_body = request.split("------WebKitFormBoundary")

  parsed_request_body = Parser.new.parse_request_body(request_body)

  @request = Parser.new.parse(request_headers.split("\r\n").first)
  @request[:params].merge!(Hash[parsed_request_body])

  request_headers.split("\r\n").drop(1).each do |header|
    key, val = header.split(":")
    @request.store(key.strip.to_sym, val.strip)
  end


  puts "#{'=' * 10}[ Request #{request_count} ]#{'='*10}"
  puts @request # Log the request to the console for debugging
  puts "#{'=' * 10}[ Request #{request_count} ]#{'='*10}"
  puts

  response = Router.new(@request).route

  if response.nil?
    puts "*" * 20
    puts "RESPONSE WAS NIL!"
    puts "*" * 20
    socket.print "HTTP/1.1 500 SERVER ERROR\r\n"
    socket.close
    next
  end


  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 #{response[:status]}\r\n" +
               "Content-Type: #{response[:as]}\r\n" +
               "Content-Length: #{response[:body].bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body, which is just "Hello World!\n"
  socket.print response[:body]

  socket.close # Close the socket, terminating the connection
  # If we don't close the socket, the response is never fully processed
  # and the web page appears to never load.
end
