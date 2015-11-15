require 'spec_helper'
require 'environment'
require 'types/number_type'
require 'nodes/variable'

RSpec.describe Variable do
  let(:variable) { described_class.new(identifier) }

  describe '#initialize' do
    let(:identifier) { 'name ' }

    it 'strips any trailing space from the identifier' do
      expect(variable.identifier).to eq('name')
    end
  end

  describe '#eval' do
    let(:identifier) { 'name' }
    let(:env) { Environment.new }
    subject(:result) { variable.eval(env) }

    before do
      env.set(identifier, :value)
    end

    it { is_expected.to eq(:value) }
  end

  describe '#type' do
    let(:identifier) { 'name' }
    let(:context) { Environment.new }
    subject(:type) { variable.type(context) }

    before do
      context.set(identifier, NumberType.new)
    end

    it { is_expected.to be_a(NumberType) }
  end
end
