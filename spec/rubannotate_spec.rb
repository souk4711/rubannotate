# frozen_string_literal: true

RSpec.describe Rubannotate do
  def rspec_path
    Pathname.new(__dir__)
  end

  def dummy_copy_file(file)
    src = rspec_path.join('fixtures/dummy', file)
    dest = rspec_path.join('dummy', file)
    FileUtils.cp(src, dest)
  end

  def dummy_delete_file(file)
    FileUtils.rm_f(rspec_path.join('dummy', file))
  end

  def dummy_read_file(file)
    File.read(rspec_path.join('dummy', file))
  end

  def dummy_system(commandline)
    Dir.chdir(rspec_path.join('dummy')) do
      `#{commandline}`
    end
  end

  describe 'integration with rails' do
    before do
      dummy_copy_file('app/models/application_record.rb')
      dummy_copy_file('db/schema.rb')
      dummy_system('rake db:drop')
      dummy_system('rake db:create')
    end

    after do
      rspec_path.join('dummy/app/models').glob('*.rb').each { |f| FileUtils.rm(f) }
      rspec_path.join('dummy/db').glob('**/*.rb').each { |f| FileUtils.rm(f) }
    end

    describe 'rake db:migrate' do
      it 'create user' do
        dummy_copy_file('app/models/user.rb')
        dummy_copy_file('db/migrate/20190817090137_create_users.rb')
        dummy_system('rake db:migrate')

        expect(dummy_read_file('app/models/user.rb')).to eq <<~CONTENT
          # == Schema Information
          #
          # Table name: users
          #
          #  id                           :integer(8)  not null, primary key
          #  name(ユーザー)               :string
          #  password_digest(パスワード)  :string
          #  email(連絡用メールアドレス)  :string
          #
          # Indexes
          #
          #  index_users_on_email       (email) UNIQUE
          #  index_users_on_lower_name  lower((name)::text) UNIQUE
          #

          class User < ApplicationRecord
          end
        CONTENT
      end

      it 'create user, update user' do
        dummy_copy_file('app/models/user.rb')
        dummy_copy_file('db/migrate/20190817090137_create_users.rb')
        dummy_system('rake db:migrate')

        dummy_copy_file('db/migrate/20190817091821_add_avatar_to_user.rb')
        dummy_system('rake db:migrate')

        expect(dummy_read_file('app/models/user.rb')).to eq <<~CONTENT
          # == Schema Information
          #
          # Table name: users
          #
          #  id                           :integer(8)  not null, primary key
          #  name(ユーザー)               :string
          #  password_digest(パスワード)  :string
          #  email(連絡用メールアドレス)  :string
          #  avatar(アバター)             :string
          #
          # Indexes
          #
          #  index_users_on_email       (email) UNIQUE
          #  index_users_on_lower_name  lower((name)::text) UNIQUE
          #

          class User < ApplicationRecord
          end
        CONTENT
      end

      it 'create user, create article' do
        dummy_copy_file('app/models/user.rb')
        dummy_copy_file('db/migrate/20190817090137_create_users.rb')
        dummy_system('rake db:migrate')

        dummy_copy_file('app/models/article.rb')
        dummy_copy_file('db/migrate/20190817092050_create_articles.rb')
        dummy_system('rake db:migrate')

        expect(dummy_read_file('app/models/user.rb')).to eq <<~CONTENT
          # == Schema Information
          #
          # Table name: users
          #
          #  id                           :integer(8)  not null, primary key
          #  name(ユーザー)               :string
          #  password_digest(パスワード)  :string
          #  email(連絡用メールアドレス)  :string
          #
          # Indexes
          #
          #  index_users_on_email       (email) UNIQUE
          #  index_users_on_lower_name  lower((name)::text) UNIQUE
          #

          class User < ApplicationRecord
          end
        CONTENT

        expect(dummy_read_file('app/models/article.rb')).to eq <<~CONTENT
          # frozen_string_literal: true

          # == Schema Information
          #
          # Table name: articles
          #
          #  id                   :integer(8)  not null, primary key
          #  author_id(作成者)    :integer(8)
          #  content(コンテンツ)  :text
          #
          # Indexes
          #
          #  index_articles_on_author_id  (author_id)
          #
          # Foreign Keys
          #
          #  fk_rails_...  (author_id => users.id)
          #

          class Article < ApplicationRecord
            belongs_to :author, class_name: 'User'
          end
        CONTENT
      end
    end

    describe 'rake db:rollback' do
      it 'create user, update user, revert update user' do
        dummy_copy_file('app/models/user.rb')
        dummy_copy_file('db/migrate/20190817090137_create_users.rb')
        dummy_system('rake db:migrate')

        dummy_copy_file('db/migrate/20190817091821_add_avatar_to_user.rb')
        dummy_system('rake db:migrate')

        dummy_system('rake db:rollback')

        expect(dummy_read_file('app/models/user.rb')).to eq <<~CONTENT
          # == Schema Information
          #
          # Table name: users
          #
          #  id                           :integer(8)  not null, primary key
          #  name(ユーザー)               :string
          #  password_digest(パスワード)  :string
          #  email(連絡用メールアドレス)  :string
          #
          # Indexes
          #
          #  index_users_on_email       (email) UNIQUE
          #  index_users_on_lower_name  lower((name)::text) UNIQUE
          #

          class User < ApplicationRecord
          end
        CONTENT
      end
    end
  end
end
