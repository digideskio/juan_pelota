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
      'args'     => job['args'],
    )

    yield

    logger.info(
      'status'   => 'done',
      'jid'      => job['jid'],
      'bid'      => job['bid'],
      'run_time' => elapsed(start),
      'class'    => worker.class.to_s,
      'args'     => job['args'],
    )
  rescue Exception
    logger.info(
      'status'   => 'fail',
      'jid'      => job['jid'],
      'bid'      => job['bid'],
      'run_time' => elapsed(start),
      'class'    => worker.class.to_s,
      'args'     => job['args'],
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
end
end
end
