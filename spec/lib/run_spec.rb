require 'spec_helper'
require 'run'

RSpec.describe 'nodes' do
  let(:src) { "a = 6\na" }
  subject(:output) { nodes(src) }

  it 'returns the nodes' do
    expect(output.size).to eq(2)
    expect(output.first).to be_an(Assign)
    expect(output.last).to be_a(Variable)
  end
end

RSpec.describe 'interpret' do
  let(:src) { "a = 6\na" }
  subject(:output) { interpret(src) }

  it { is_expected.to eq([6, 6]) }
end

RSpec.describe 'type_check' do
  let(:src) { "a = 6\na" }
  subject(:types) { type_check(src) }

  it 'returns two NumberTypes' do
    expect(types.map(&:class)).to eq([NumberType, NumberType])
  end
end
