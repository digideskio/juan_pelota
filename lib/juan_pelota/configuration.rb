require 'singleton'

module  JuanPelota
  def self.configure
    if block_given?
      yield Configuration.instance
    else
      return Configuration.instance
    end
  end

  class Configuration
    include Singleton

    attr_accessor :filtered_arguments,
                  :filtered_workers

    def filtered_arguments
      @filtered_arguments || []
    end

    def filtered_workers
      @filtered_workers || []
    end
  end
end
