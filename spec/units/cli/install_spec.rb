require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { Pulsar::Install }

  let(:described_instance) { described_class.new }

  context '#install' do
    let(:result) { spy }

    before do
      allow(Pulsar::Install).to receive(:call).and_return(result)
    end

    context 'calls Pulsar::Install with ./pulsar-conf by default' do
      before { described_instance.install }

      it { expect(Pulsar::Install).to have_received(:call).with(directory: './pulsar-conf') }
    end

    context 'calls Pulsar::Install with an argument' do
      before { described_instance.install('./a-dir') }

      it { expect(Pulsar::Install).to have_received(:call).with(directory: './a-dir') }
    end

    context 'success' do
      subject { -> { described_instance.install } }

      let(:result) { spy(success?: true) }

      it do
        expect { subject }.to output(/Successfully created intial repo!/).to_stdout
      end
    end

    context 'failure' do
      subject { -> { described_instance.install } }

      let(:result) { spy(success?: false) }

      it do
        expect { subject }.to output(/Failed to create intial repo./).to_stdout
      end
    end

    context 'when an error is reported' do
      subject { -> { described_instance.install } }
      before do
        allow(described_instance).to receive(:options).and_return(conf_repo: repo)
        described_instance.list
      end

      let(:repo) { RSpec.configuration.pulsar_conf_path }

      context 'as a string' do
        let(:result) { spy(success?: false, error: "A stub sets this error") }

        it do
          expect { subject }.to output(/A stub sets this error/).to_stdout
        end
      end

      context 'as an exception object' do
        let(:result) { spy(success?: false, error: RuntimeError.new("A stub sets this error")) }

        it do
          expect { subject }.to output(/A stub sets this error/).to_stdout
        end
      end
    end
  end
end
