require 'spec_helper'

RSpec.describe 'Deimos::Status::Manager' do
  let(:status) { Deimos::Status::Manager.new }
  
  context "Setup" do
    let(:check_name) { :database }
    let(:check)      { true }
    before do
      status.add(check_name) { check }
    end

    it { expect(status.checks[check_name]).to be_truthy }
    it { expect(status.checks[check_name].call).to eql(true) }

    context "Runner" do
      
      subject { status.run! }

      it { expect(subject.status).to eql(:ok) }
    end  
  end


end