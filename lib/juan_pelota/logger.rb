require 'juan_pelota/version'
require 'juan_pelota'
require 'json'

module  JuanPelota
class   Logger < Sidekiq::Logging::Pretty
  IGNORABLE_STATUSES = %w{start done queueing}

  attr_accessor :severity,
                :timestamp,
                :program_name,
                :raw_message

  # rubocop:disable Metrics/AbcSize
  def call(severity, time, program_name, incoming_message)
    self.severity     = severity
    self.timestamp    = time.utc.iso8601
    self.program_name = program_name
    self.raw_message  = incoming_message

    return if config.filtered_workers.include?(worker_name.to_s) &&
              IGNORABLE_STATUSES.include?(status)

    {
      '@type'      => 'sidekiq',
      '@timestamp' => timestamp,
      '@status'    => status,
      '@severity'  => severity.downcase,
      '@run_time'  => run_time,
      '@message'   => message,
      '@fields'    => {
        pid:          self.class.pid,
        tid:          self.class.tid,
        context:      context,
        program_name: program_name,
        worker:       worker_name,
        arguments:    arguments,
      },
    }.to_json + "\n"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def raw_message
    if @raw_message.is_a? Hash
      @raw_message
    elsif @raw_message.respond_to?(:match) &&
          @raw_message.match(/^queueing/)
      {
        'status'  => 'queueing',
        'message' => @raw_message,
        'class'   => @raw_message.split(' ')[1],
      }
    else
      {
        'message' => @raw_message,
      }
    end
  end

  def status
    return 'exception' if message.is_a? Exception

    if raw_message['retry']
      'retry'
    elsif raw_message['status']
      raw_message['status']
    else
      'dead'
    end
  end

  def message
    raw_message['message']
  end

  def arguments
    raw_message['args']
  end

  def run_time
    raw_message['run_time']
  end

  def worker_name
    raw_message['class']
  end

  def self.pid
    ::Process.pid
  end

  def self.tid
    ::Thread.current.object_id.to_s(36)
  end

  def config
    Configuration.instance
  end
end
end
