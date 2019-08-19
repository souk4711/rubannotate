# frozen_string_literal: true

%w[
  db:migrate
  db:migrate:down
  db:migrate:reset
  db:migrate:redo
  db:migrate:up
  db:rollback
].each do |task|
  Rake::Task[task].enhance do
    Rake::Task['rubannotate:load_config'].invoke
    Rubannotate.annotator.config.logging_level = ::Logger::FATAL
    Rubannotate.annotator.annotate
  end
end
