require 'spec_helper'
require 'environment'

RSpec.describe Environment do
  subject(:env) { described_class.new }

  it 'sets and retrieves values' do
    env.set(:key, :value)
    expect(env.get(:key)).to eq(:value)
  end

  it 'raises an error if the key is not set' do
    expect { env.get(:key) }.to raise_error(MissingValue)
  end

  context 'with a parent' do
    let(:parent) { described_class.new }
    subject(:env) { described_class.new(parent: parent) }

    it 'returns keys from the parent' do
      parent.set(:key, :value)
      expect(env.get(:key)).to eq(:value)
    end

    it 'allows new assignments' do
      env.set(:key, :value)
      expect(env.get(:key)).to eq(:value)
    end

    it 'allows overriding the parent' do
      parent.set(:key, :value)
      env.set(:key, :new_value)
      expect(env.get(:key)).to eq(:new_value)
    end

    it 'does not pollute the parent env' do
      env.set(:key, :value)
      expect(env.get(:key)).to eq(:value)
      expect { parent.get(:key) }.to raise_error(MissingValue)
    end

    it 'raises an error if the key is not set' do
      expect { env.get(:key) }.to raise_error(MissingValue)
    end
  end
end
