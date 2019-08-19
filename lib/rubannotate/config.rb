# frozen_string_literal: true

module Rubannotate
  class Config
    attr_writer :logging_level

    def models_path
      @models_path ||= ['app/models']
    end

    def models_path=(models_path)
      @models_path = Array(models_path)
    end

    def logging_level
      @logging_level ||= ::Logger::INFO
    end
  end
end
