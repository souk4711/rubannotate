# frozen_string_literal: true

require 'logger'
require 'pathname'
require 'active_record'
require 'rubannotate/railtie' if defined?(::Rails)

module Rubannotate
  autoload :VERSION, 'rubannotate/version'
  autoload :Annotator, 'rubannotate/annotator'
  autoload :Config, 'rubannotate/config'
  autoload :SchemaDumper, 'rubannotate/schema_dumper'
  autoload :Writer, 'rubannotate/writer'

  class << self
    def annotator
      @annotator ||= Annotator.new
    end

    def configure
      yield annotator.config
    end
  end
end
