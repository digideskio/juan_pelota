module  JuanPelota
module  Middlewares
class   Logging
  # rubocop:disable Lint/RescueException, Metrics/AbcSize, Metrics/MethodLength
  def call(worker, job, _queue)
    start = Time.now

    unless config.filtered_workers.include? worker.class.name
      logger.info(
        'status'   => 'start',
        'jid'      => job['jid'],
        'bid'      => job['bid'],
        'run_time' => nil,
        'class'    => worker.class.to_s,
        'args'     => filtered_arguments(job['args']),
      )
    end

    yield

    unless config.filtered_workers.include? worker.class.name
      logger.info(
        'status'   => 'done',
        'jid'      => job['jid'],
        'bid'      => job['bid'],
        'run_time' => elapsed(start),
        'class'    => worker.class.to_s,
        'args'     => filtered_arguments(job['args']),
      )
    end
  rescue Exception
    message = {
      'error_class'     => e.class.name,
      'error_message'   => e.message,
      'error_backtrace' => e.backtrace.first(10),
    }

    logger.info(
      'status'   => 'fail',
      'jid'      => job['jid'],
      'bid'      => job['bid'],
      'run_time' => elapsed(start),
      'class'    => worker.class.to_s,
      'message'  => message,
      'args'     => filtered_arguments(job['args']),
    )

    raise
  end
  # rubocop:enable Lint/RescueException, Metrics/AbcSize, Metrics/MethodLength

  def elapsed(start)
    (Time.now - start).to_f.round(3)
  end

  def logger
    Sidekiq.logger
  end

  def filtered_arguments(args)
    return if args.nil? || args.empty?

    @filtered_arguments ||=
      args.first.each_with_object({}) do |(key, value), filtered_hash|
        filtered_hash[key] = value unless config.filtered_arguments.include? key
      end
  end

  private

  def config
    Configuration.instance
  end
end
end
end
