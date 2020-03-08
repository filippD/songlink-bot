require_relative 'bot/client'
require_relative 'bot/app'

namespace :bot do
  PIDFILE = 'tmp/bot.pid'.freeze

  task :start do
    Process.daemon(true, true)
    File.open(PIDFILE, 'w') { |f| f << Process.pid }
    Signal.trap('TERM') { abort }
    client = Client.new
    app = App.new(client.api)
    client.listen { |input| app.call(input) }
  end

  task :kill do
    system("kill `cat #{PIDFILE}`")
  end
  
  task :restart do
    Rake::Task['bot:kill'].execute
    Rake::Task['bot:start'].execute
  end
end
