# frozen_string_literal: true

namespace :rubannotate do
  task :load_config do
  end

  desc 'Add schema information to model files'
  task :annotate do
    Rake::Task['rubannotate:load_config'].invoke
    Rubannotate.annotator.annotate
  end

  desc 'Remove schema information from model files'
  task :cleanup do
    Rake::Task['rubannotate:load_config'].invoke
    Rubannotate.annotator.cleanup
  end
end
