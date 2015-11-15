require 'spec_helper'
require 'environment'
require 'types/number_type'
require 'nodes/assign'

RSpec.describe Assign do
  let(:assign) { described_class.new(target, value) }

  describe '#initialize' do
    let(:target) { 'name ' }
    let(:value) { nil }

    it 'strips any trailing space from the target' do
      expect(assign.target).to eq('name')
    end
  end

  describe '#eval' do
    let(:target) { 'name' }
    let(:value) { double(:expression, eval: :value) }
    let(:env) { Environment.new }

    subject(:result) { assign.eval(env) }

    it { is_expected.to eq(:value) }

    it 'updates the environment' do
      assign.eval(env)
      expect(env.get(target)).to eq(:value)
    end
  end

  describe '#type' do
    let(:target) { 'name' }
    let(:value) { double(:expression, type: NumberType.new) }
    let(:context) { Environment.new }

    subject(:result) { assign.type(context) }

    it { is_expected.to be_a(NumberType) }

    it 'updates the context' do
      assign.type(context)
      expect(context.get(target)).to be_a(NumberType)
    end
  end
end
