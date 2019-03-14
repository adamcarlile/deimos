require 'deimos/endpoints/status'
require 'deimos/endpoints/metrics'

RSpec.describe Deimos do
  
  it "has a version number" do
    expect(Deimos::VERSION).not_to be nil
  end

  context "#application" do
    let(:app) { Deimos.application }

    context "get /status" do
      before { get('/status') }
      it { expect(last_response).to be_ok }
    end

    context "get /status/-/" do
      before { get('/status/-/') }
      it { expect(last_response).to be_ok }
    end

    context "get /metrics" do
      before { get('/metrics') }
      it { expect(last_response).to be_ok }
    end

    context "get /metrics/-/" do
      before { get('/metrics/-/') }
      it { expect(last_response).to be_ok }
    end
  end

end
