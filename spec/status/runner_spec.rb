require 'spec_helper'

RSpec.describe 'Deimos::Status::Runner' do
  let(:checks) { {} }
  let(:runner) { Deimos::Status::Runner.new(checks) }
  
  context "With all checks that return truthy" do
    before do
      checks[:check_one] = ->() { true }
      checks[:check_two] = ->() { true }
    end

    it { expect(runner.status).to eql(:ok) }

    context "runner#body" do
      subject { JSON.parse(runner.body, symbolize_names: true) }

      it { expect(subject[:check_one]).to eql(true) }
      it { expect(subject[:check_two]).to eql(true) }
    end
  end

  context "With a check that is falsey" do
    before do
      checks[:check_one] = ->() { false }
      checks[:check_two] = ->() { true }
    end

    it { expect(runner.status).to eql(:internal_server_error) }
    
    context "runner#body" do
      subject { JSON.parse(runner.body, symbolize_names: true) }

      it { expect(subject[:check_one]).to eql(false) }
      it { expect(subject[:check_two]).to eql(true) }
    end
  end

end