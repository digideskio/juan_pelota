require 'spec_helper'

module    JuanPelota
describe  Logger do
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
      '@message'   => {
        'args'     => 'my_args',
        'class'    => 'my_worker',
        'run_time' => 100,
        'message'  => 'my message',
        'status'   => 'my_status',
      },
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
