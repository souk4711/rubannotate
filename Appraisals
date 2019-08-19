# frozen_string_literal: true

%w[5.1.6 5.2.3 6.0.0].each do |version|
  appraise "rails-#{version.split('.').first(2).join('.')}" do
    gem 'pg'
    gem 'rails', version

    if Gem::Version.new(version) < Gem::Version.new('5.2')
      gem 'sqlite3', '~> 1.3.13'
    else
      gem 'sqlite3'
    end
  end
end
