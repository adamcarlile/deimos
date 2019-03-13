require 'spec_helper'

RSpec.describe 'Deimos::Metrics::Manager' do
  let(:registry) { Prometheus::Client::Registry.new }
  let(:metrics)  { Deimos::Metrics::Manager.new(registry: registry) }

  context "Simple collector" do
    let(:event) { 'test.event.name' }
    let(:type)  { :counter }
    let(:label) { 'A simple test event' }
    let(:increment) { 10 }

    before do
      metrics.subscribe(event, type: type, label: label) do |event, collector|
        collector.increment
      end
      10.times { metrics.instrument(event, {}) }
    end

    it { expect(metrics.subscriptions.first).to be_instance_of ActiveSupport::Notifications::Fanout::Subscribers::Timed }
    context "Collector" do
      subject { metrics.collectors[event] }

      it { expect(subject).to be_instance_of Prometheus::Client::Counter }
      it { expect(subject.values[{}]).to eql increment.to_f }
    end
  end

end