module  JuanPelota
module  Middlewares
class   Logging
  # rubocop:disable Lint/RescueException, Metrics/AbcSize
  def call(worker, job, _queue)
    start = Time.now

    logger.info(
      'status'   => 'start',
      'jid'      => job['jid'],
      'bid'      => job['bid'],
      'run_time' => nil,
      'class'    => worker.class.to_s,
      'args'     => filtered_arguments(job['args']),
    )

    yield

    logger.info(
      'status'   => 'done',
      'jid'      => job['jid'],
      'bid'      => job['bid'],
      'run_time' => elapsed(start),
      'class'    => worker.class.to_s,
      'args'     => filtered_arguments(job['args']),
    )
  rescue Exception
    logger.info(
      'status'   => 'fail',
      'jid'      => job['jid'],
      'bid'      => job['bid'],
      'run_time' => elapsed(start),
      'class'    => worker.class.to_s,
      'args'     => filtered_arguments(job['args']),
    )

    raise
  end
  # rubocop:enable Lint/RescueException, Metrics/AbcSize

  def elapsed(start)
    (Time.now - start).to_f.round(3)
  end

  def logger
    Sidekiq.logger
  end

  def filtered_arguments(args)
    return unless args

    @filtered_arguments ||=
      args.each_with_object({}) do | (key, value), filtered_hash|
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
