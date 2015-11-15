require 'spec_helper'
require 'transform'

RSpec.describe TrumpTransform do
  let(:transform) { described_class.new }
  let(:output) { transform.apply(tree) }

  context 'with a number' do
    let(:tree) do
      tree = [
        :number => '6'
      ]
    end
    subject(:number) { output.first }


    it 'returns a Number' do
      expect(number).to be_a(Number)
      expect(number.value).to eq(6)
    end
  end

  context 'with a variable' do
    let(:tree) do
      tree = [
        :variable => 'a'
      ]
    end
    subject(:variable) { output.first }


    it 'returns a Variable' do
      expect(variable).to be_a(Variable)
      expect(variable.identifier).to eq('a')
    end
  end

  context 'with an assignment' do
    let(:tree) do
      tree = [
        {
          :assign => {
            :target => "a ",
            :value => { :number=>"6" }
          }
        }
      ]
    end
    subject(:assign) { output.first }

    it 'returns an Assign' do
      expect(assign).to be_a(Assign)

      expect(assign.target).to eq('a')

      expect(assign.value).to be_a(Number)
      expect(assign.value.value).to eq(6)
    end
  end

  context 'with a function declaration' do
    let(:tree) do
      tree = [
        {
          :function => {
            :params => [{ :param => 'x ' }, { :param => 'y' }],
            :body => [{ :variable => 'x' }]
          }
        }
      ]
    end
    subject(:function) { output.first }

    it 'returns a Function' do
      expect(function).to be_a(Function)

      expect(function.params).to eq(['x', 'y'])

      expect(function.body.first).to be_a(Variable)
      expect(function.body.first.identifier).to eq('x')
    end
  end
end
