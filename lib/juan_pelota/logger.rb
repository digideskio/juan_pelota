require 'juan_pelota/version'
require 'juan_pelota'
require 'json'

module  JuanPelota
class   Logger < Sidekiq::Logging::Pretty
  def call(severity, time, program_name, message)
    tid = Thread.current.object_id.to_s(36)

    {
      '@timestamp' => time.utc.iso8601,
      '@fields'    => {
        pid:          ::Process.pid,
        tid:          "TID-#{Thread.current.object_id.to_s(36)}",
        context:      "#{context}",
        program_name: program_name,
        worker:       "#{context}".split(' ')[0],
      },
      '@type'      => 'sidekiq',
      '@status'    => nil,
      '@severity'  => severity,
      '@run_time'  => nil,
      '@message'   => "#{time.utc.iso8601} " \
                      "#{::Process.pid} " \
                      "TID-#{tid}#{context} " \
                      "#{severity}: " \
                      "#{message}",
    }.merge(process_message(severity, time, program_name, message)).to_json + "\n"
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def process_message(severity, time, _program_name, message)
    return { '@status' => 'exception' } if message.is_a?(Exception)

    if message.is_a? Hash
      tid = Thread.current.object_id.to_s(36)

      if message['retry']
        status = 'retry'
        msg = "#{message['class']} failed, retrying with args #{message['args']}."
      else
        status = 'dead'
        msg = "#{message['class']} failed with args #{message['args']}, not retrying."
      end
      return {
        '@status'  => status,
        '@message' => "#{time.utc.iso8601} " \
                      "#{::Process.pid} " \
                      "TID-#{tid}" \
                      "#{context} " \
                      "#{severity}: " \
                      "#{msg}",
      }
    end

    result = message.split(' ')
    status = result[0].match(/^(start|done|fail):?$/) || []

    {
      '@status'   => status[1],                                   # start or done
      '@run_time' => status[1] && result[1] && result[1].to_f   # run time in seconds
    }
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
end
