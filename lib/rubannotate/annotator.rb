# frozen_string_literal: true

module Rubannotate
  class Annotator
    attr_reader :config

    def initialize
      @config = Config.new
      @logger = ::Logger.new(STDOUT, formatter: proc { |_, _, _, msg| "#{msg}\n" })
    end

    def annotate(class_names = nil)
      load_environments
      load_config

      class_names = Array(class_names)
      classes = class_names.empty? ? load_default_classes : class_names.map(&:constantize)

      paths = models_path
      connection = ::ActiveRecord::Base.connection

      info '== Starting annotate '.ljust(79, '=')
      classes.each do |c|
        table_name = c.table_name
        next unless table_name
        next unless connection.table_exists?(table_name)

        paths.each do |path|
          filepath = path.join(c.name.underscore + '.rb')
          next unless filepath.exist?

          info "   -> Processing #{filepath.sub(app_path.to_s + File::SEPARATOR, '')}"

          io = StringIO.new
          SchemaDumper.new(table_name, connection).dump(io)

          str = io.tap(&:rewind).read
          Writer.new(filepath).write(str)
        end
      end
    end

    def cleanup
      load_environments
      load_config

      models_path.each do |path|
        path.glob('**/*.rb').each do |filepath|
          Writer.new(filepath).cleanup
        end
      end
    end

    private

    def load_environments
      require 'rails'
      require app_path.join('config', 'environment.rb')
    end

    def load_config
      @logger.level = @config.logging_level
    end

    def load_default_classes
      models_path.each do |path|
        Dir.glob('**/*rb', base: path).each do |f|
          require_dependency(path.join(f))
        end
      end

      ::ActiveRecord::Base.descendants
    end

    def app_path
      ::Pathname.pwd
    end

    def models_path
      config.models_path.map do |path|
        app_path.join(path)
      end
    end

    def info(message)
      @logger.info message
    end
  end
end
