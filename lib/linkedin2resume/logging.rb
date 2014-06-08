require 'log4r'

# Public: Logging module to mixin with classes.
#
#
module Logging

  def log
    @log ||= Logging.logger_for(self.class.name)
  end

  # Use a hash class-ivar to cache a unique Logger per class:
  @loggers = {}

  class << self
    include Log4r

    def logger_for(classname)
      @loggers[classname] ||= configure_logger_for(classname)
    end

    def configure_logger_for(classname)
      logger = Logger.new classname.to_s.gsub(/[^a-zA-Z0-9]/, '.').downcase.gsub(/\.+/, '.')

      # Log to file or stdout?
      if (ENV['LOG_OUTPUT_FILENAME'] && !ENV['LOG_OUTPUT_FILENAME'].empty?)
        puts ENV['LOG_OUTPUT_FILENAME']
        logger.outputters << Log4r::FileOutputter.new('linkedin2resumelog', :filename => ENV['LOG_OUTPUT_FILENAME'])
      elsif
        logger.outputters << Log4r::StdoutOutputter.new('linkedin2resumelog')
      end
      logger
    end
  end
end