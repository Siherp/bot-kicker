require 'slack-ruby-client'
require 'dotenv'
Dotenv.load

Slack.configure do |config|
  config.token = ENV['TOKEN']
end

client = Slack::RealTime::Client.new

client.on :message do |data|
  kick_user(client, data) if data['channel'] == ENV['JSONTESTING'] && data['subtype'] == 'group_join' && data['user'] == ENV['PHIL']
end

def countdown(client)
  client.web_client.chat_postMessage({channel: ENV['JSONTESTING'], text: 'Kicking him in: '})
  (1..3).to_a.reverse.each do |num|
    client.web_client.chat_postMessage({channel: ENV['JSONTESTING'], text: num.to_s })
    sleep(1)
  end
end

def kick_user(client, data)
  client.web_client.chat_postMessage({channel: ENV['JSONTESTING'], text: "I don't think <@#{data['user']}> wants to do pushups anymore."})
  countdown(client)
  client.web_client.groups_kick({channel: data['channel'], user: data['user']})
end

client.start!
