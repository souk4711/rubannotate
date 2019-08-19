# frozen_string_literal: true

RSpec.describe Rubannotate::SchemaDumper do
  before do
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'test.db')
  end

  after do
    FileUtils.rm('test.db') if File.exist?('test.db')
  end

  let(:db) { SQLite3::Database.new('test.db') }
  let(:connection) { ActiveRecord::Base.connection }

  describe '#dump' do
    it 'dumps columns' do
      db.execute_batch <<~SQL
        create table users(id integer primary key autoincrement);
      SQL

      io = StringIO.new
      described_class.new('users', connection).dump(io)
      expect(io.tap(&:rewind).read).to eq <<~CONTENT
        # == Schema Information
        #
        # Table name: users
        #
        #  id  :integer  primary key
        #
      CONTENT
    end

    it 'dumps columns, index' do
      db.execute_batch <<~SQL
        create table users(id integer primary key);
        create unique index users_id on users(id);
      SQL

      io = StringIO.new
      described_class.new('users', connection).dump(io)
      expect(io.tap(&:rewind).read).to eq <<~CONTENT
        # == Schema Information
        #
        # Table name: users
        #
        #  id  :integer  primary key
        #
        # Indexes
        #
        #  users_id  (id) UNIQUE
        #
      CONTENT
    end

    it 'dumps columns, foreign key' do
      db.execute_batch <<~SQL
        create table users(id integer primary key);
        create table articles(author_id integer, foreign key (author_id) references users(id));
      SQL

      io = StringIO.new
      described_class.new('articles', connection).dump(io)
      expect(io.tap(&:rewind).read).to eq <<~CONTENT
        # == Schema Information
        #
        # Table name: articles
        #
        #  author_id  :integer
        #
        # Foreign Keys
        #
        #  (author_id => users.id)
        #
      CONTENT
    end

    it 'dumps columns, index, foreign key' do
      db.execute_batch <<~SQL
        create table users(id integer primary key);
        create table articles(author_id integer, foreign key (author_id) references users(id));
        create unique index articles_author_id on articles(author_id);
      SQL

      io = StringIO.new
      described_class.new('articles', connection).dump(io)
      expect(io.tap(&:rewind).read).to eq <<~CONTENT
        # == Schema Information
        #
        # Table name: articles
        #
        #  author_id  :integer
        #
        # Indexes
        #
        #  articles_author_id  (author_id) UNIQUE
        #
        # Foreign Keys
        #
        #  (author_id => users.id)
        #
      CONTENT
    end
  end
end
