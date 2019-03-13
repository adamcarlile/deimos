require 'spec_helper'
require 'deimos/endpoints/status'

RSpec.describe 'Deimos::Endpoints::Status' do
  let(:status) { Deimos::Status::Manager.new }
  let(:app)    { Deimos::Endpoints::Status.new(status: status) }
  
  
  context "Successful test" do
    before do
      status.add(:test) { true } 
      get '/'
    end

    it { expect(last_response.status).to eql(200) }
  end

  context "Unsucessful test" do
    before do
      status.add(:test) { false }
      get '/'
    end

    it { expect(last_response.status).to eql(500)  }
  end

end