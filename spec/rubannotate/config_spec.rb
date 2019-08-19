# frozen_string_literal: true

RSpec.describe Rubannotate::Config do
  subject(:config) { described_class.new }

  describe '#models_path' do
    it 'has a default value' do
      expect(config.models_path).to eq(['app/models'])
    end

    it 'is a kind of Array' do
      config.models_path = 'app/custom_models'
      expect(config.models_path).to eq(['app/custom_models'])
    end
  end

  describe '#logging_level' do
    it 'has a default value' do
      expect(config.logging_level).to eq(::Logger::INFO)
    end
  end
end
