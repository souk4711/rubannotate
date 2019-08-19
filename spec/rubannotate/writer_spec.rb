# frozen_string_literal: true

RSpec.describe Rubannotate::Writer do
  def file_content
    <<~CONTENT
      class User
      end
    CONTENT
  end

  def schema_information_content
    <<~CONTENT
      # == Schema Information
      #
      # Table name: users
      #
      #  id  :integer  not null, primary key
      #
    CONTENT
  end

  def schema_information_content_2
    <<~CONTENT
      # == Schema Information
      #
      # Table name: users
      #
      #  id               :integer  not null, primary key
      #  name             :string   not null
      #  password_digest  :string
      #
      # Indexes
      #
      #  index_users_on_name  (name) UNIQUE
      #
    CONTENT
  end

  let(:tempfile) { Tempfile.new }
  let(:writer) { described_class.new(tempfile.path) }

  context 'when unannotated' do
    before do
      tempfile.write(file_content)
      tempfile.flush
    end

    after do
      tempfile.unlink
    end

    it '#write: add schema information to model files' do
      writer.write(schema_information_content)
      expect(File.read(tempfile.path)).to eq([schema_information_content, file_content].join("\n"))
    end

    it '#cleanup: do nothing' do
      writer.cleanup
      expect(File.read(tempfile.path)).to eq(file_content)
    end
  end

  context 'when annotated' do
    before do
      tempfile.write([schema_information_content, file_content].join("\n"))
      tempfile.flush
    end

    after do
      tempfile.unlink
    end

    it '#write: update schema information to model files' do
      writer.write(schema_information_content_2)
      expect(File.read(tempfile.path)).to eq([schema_information_content_2, file_content].join("\n"))
    end

    it '#cleanup: remove schema information from model files' do
      writer.cleanup
      expect(File.read(tempfile.path)).to eq(file_content)
    end
  end
end
