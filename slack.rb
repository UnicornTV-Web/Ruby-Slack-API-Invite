require 'json'
require 'csv'
require 'uri'
require 'open-uri'
require 'colorize'

CSV.foreach("contacts.csv") do |row|
  # Give our row indexes pretty names
  email = row[1]
  first_name = row[2]
  last_name = row[3]
  invitation = row[4]

  # Get the channel ID from https://slack.com/api/channels.list?token=<YOUR_TOKEN>
  channels = ''

  # Get the auth token from: https://api.slack.com/web
  token = ''

  # Guard clause if we've already invited the user
  next if (invitation && invitation == "yes") || ($. == 1)

  # Construct the API request URL
  # This is not documented by Slack, and may not work forever
  # As it is an unofficial API endpoint, use at your own risk!
  url = "https://slack.com/api/users.admin.invite"
  url += "?channels=#{channels}"
  url += "&set_active=true"
  url += "&_attempts=1"
  url += "&token=#{token}"
  url += "&email=#{URI::escape(email)}"
  url += "&first_name=#{URI::escape(first_name)}"
  url += "&last_name=#{URI::escape(last_name)}"

  # Make the request and capture the response
  response = JSON.parse(open(url).read)

  if response['ok']
    puts "invitation sent to: #{first_name} #{last_name}".colorize(:green)
  else
    puts "invitation failed to send to #{first_name} #{last_name}".colorize(:red)
    puts response.inspect.colorize(:yellow)
  end
end