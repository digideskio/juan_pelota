require 'spec_helper'

module    JuanPelota
describe  Logger do

  before(:each) do
    Configuration.instance.filtered_workers = 'my_filtered_worker'
  end

  it 'takes message as a hash and logs what we want', :time_mock do
    json = JuanPelota::Logger.new.call('high',
                                       Time.now.utc,
                                       'our tests',
                                       'args'     => 'my_args',
                                       'class'    => 'my_worker',
                                       'run_time' => 100,
                                       'message'  => 'my message',
                                       'status'   => 'my_status')

    json_data = JSON.parse(json)

    expect(json_data).to include(
      '@type'      => 'sidekiq',
      '@timestamp' => '2012-07-26T18:00:00Z',
      '@status'    => 'my_status',
      '@severity'  => 'high',
      '@run_time'  => 100,
      '@message'   => 'my message',
      '@fields'    => include(
        'pid'          => be_a(Integer),
        'tid'          => match(/[a-z0-9]+/),
        'context'      => nil,
        'program_name' => 'our tests',
        'worker'       => 'my_worker',
        'arguments'    => 'my_args',
      ),
    )
  end

  it 'take message as a string and picks up if its a worker that is being queued',
     :time_mock do

    json = JuanPelota::Logger.new.call('high',
                                       Time.now.utc,
                                       'our tests',
                                       'queueing MyWorkerClass')

    json_data = JSON.parse(json)

    expect(json_data).to include(
      '@status'  => 'queueing',
      '@message' => 'queueing MyWorkerClass',
      '@fields'  => include(
        'worker'       => 'MyWorkerClass',
      ),
    )
  end

  # rubocop:disable Metrics/LineLength
  it 'take message as a string and can detect if its a backtrace',
     :time_mock do

    backtrace = <<-HEREDOC
/Users/hhd418/Projects/goodscout/good_products/app/workers/good_products/workers/process_item.rb:50:in `perform'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/processor.rb:75:in `execute_job'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/processor.rb:52:in `block (2 levels) in process'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:127:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/plugins/sidekiq.rb:11:in `block in call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/trace.rb:62:in `instrument'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/trace.rb:18:in `instrument'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/plugins/sidekiq.rb:10:in `call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-unique-jobs-3.0.14/lib/sidekiq_unique_jobs/middleware/server/unique_jobs.rb:16:in `call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/server/active_record.rb:6:in `call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/server/retry_jobs.rb:74:in `call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-failures-0.4.4/lib/sidekiq/failures/middleware.rb:9:in `call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-skylight-0.0.4/lib/sidekiq/skylight/server_middleware.rb:8:in `block in call'
/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/skylight-0.6.0/lib/skylight/core.rb:70:in `trace'
    HEREDOC

    json = JuanPelota::Logger.new.call('high',
                                       Time.now.utc,
                                       'our tests',
                                       backtrace)

    json_data = JSON.parse(json)

    expect(json_data).to include(
      '@status'  => 'dead',
      '@message' => [
        "/Users/hhd418/Projects/goodscout/good_products/app/workers/good_products/workers/process_item.rb:50:in `perform'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/processor.rb:75:in `execute_job'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/processor.rb:52:in `block (2 levels) in process'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:127:in `block in invoke'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/plugins/sidekiq.rb:11:in `block in call'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/trace.rb:62:in `instrument'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/trace.rb:18:in `instrument'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/honeybadger-2.0.11/lib/honeybadger/plugins/sidekiq.rb:10:in `call'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-3.4.1/lib/sidekiq/middleware/chain.rb:129:in `block in invoke'",
        "/usr/local/var/rbenv/versions/2.2.2/lib/ruby/gems/2.2.0/gems/sidekiq-unique-jobs-3.0.14/lib/sidekiq_unique_jobs/middleware/server/unique_jobs.rb:16:in `call'",
      ],
    )
  end
  # rubocop:enable Metrics/LineLength

  it 'set the status to dead and returns a nil worker if it gets a string without ' \
     '"queueing" in the message',
     :time_mock do

    json = JuanPelota::Logger.new.call('high',
                                       Time.now.utc,
                                       'our tests',
                                       'My Message')

    json_data = JSON.parse(json)

    expect(json_data).to include(
      '@status'  => 'dead',
      '@message' => 'My Message',
      '@fields'  => include(
        'worker'       => nil,
      ),
    )
  end

  it 'set the status to "Exception" if the message is one', :time_mock do
    json = JuanPelota::Logger.new.call('high',
                                       Time.now.utc,
                                       'our tests',
                                       Exception.new)

    json_data = JSON.parse(json)

    expect(json_data).to include(
      '@status' => 'exception',
    )
  end

  it 'sets the status to retry if retry is passed in as key to the message', :time_mock do
    json = JuanPelota::Logger.new.call('high',
                                       Time.now.utc,
                                       'our tests',
                                       'retry' => true)

    json_data = JSON.parse(json)

    expect(json_data).to include(
      '@status' => 'retry',
    )
  end
end
end
