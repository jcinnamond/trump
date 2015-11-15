require 'spec_helper'
require 'parser'

RSpec.describe TrumpParser do
  let(:parser) { described_class.new }
  subject(:output) { parser.parse(src) }

  context 'with a number' do
    let(:src) { '6' }

    it { is_expected.to eq([{ number: '6' }]) }
  end

  context 'with a variable' do
    let(:src) { 'a' }

    it { is_expected.to eq([{ variable: 'a' }]) }
  end

  context 'with an assignment' do
    let(:src) { 'a = 6' }

    it { is_expected.to eq([{ assign: { target: 'a ', value: { number: '6' } } }]) }
  end

  context 'with a function definition' do
    let(:src) { 'fn(x, y) { x }' }
    subject(:function) { output.first[:function] }

    it 'matches the params' do
      params = function[:params]
      expect(params).to eq([{ param: 'x' }, { param: 'y' }])
    end

    it 'matches the body' do
      body = function[:body]
      expect(body).to eq([{ variable: 'x ' }])
    end
  end

  context 'with a function call' do
    let(:src) { 'a(b, c)' }
    subject(:call) { output.first[:call] }

    it 'matches the target' do
      target = call[:target]
      expect(target).to eq('a')
    end

    it 'matches the args' do
      args = call[:args]
      expect(args).to eq([
                           { arg: { variable: 'b' } },
                           { arg: { variable: 'c' } }
                         ])
    end
  end

  context 'with Maybe' do
    let(:src) { 'Maybe a' }

    it { is_expected.to eq([{ maybe: { variable: 'a' } }]) }
  end

  context 'with a full program' do
    let(:src) { "a = 10\nid = fn(x) { x }\nid(a)\n" }

    it 'matches each part of the program' do
      expect(output).to eq([
        { assign: { target: 'a ', value: { number: "10" } } },
        { assign: {
            target: 'id ',
            value: {
              function: {
                params: { param: 'x' },
                body: [{ variable: 'x ' }]
              }
            }
          }
        },
        { call: { target: 'id', args: { arg: { variable: 'a' } } } }
      ])
    end
  end
end
