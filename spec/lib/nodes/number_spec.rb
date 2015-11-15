require 'spec_helper'
require 'environment'
require 'nodes/number'

RSpec.describe Number do
  let(:digits) { '1234' }
  let(:number) { described_class.new(digits) }

  describe '#eval' do
    let(:env) { Environment.new }
    subject(:result) { number.eval(env) }

    it { is_expected.to eq(1234) }
  end

  describe '#type' do
    let(:context) { Environment.new }
    subject(:type) { number.type(context) }

    it { is_expected.to be_a(NumberType) }
  end
end
