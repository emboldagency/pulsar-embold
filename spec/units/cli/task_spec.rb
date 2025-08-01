require 'spec_helper'

RSpec.describe Pulsar::CLI do
  subject { Pulsar::Task }

  let(:described_instance) { described_class.new }
  let(:fail_text) { /Failed to execute task deploy:check for blog on production./ }

  context '#task' do
    let(:result) { spy }
    let(:repo)   { './conf_repo' }

    before do
      allow($stdout).to receive(:puts)
      allow(Pulsar::Task).to receive(:call).and_return(result)
    end

    context 'when using --conf-repo' do
      before do
        allow(described_instance)
          .to receive(:options).and_return(conf_repo: repo)
        described_instance.task('blog', 'production', 'deploy:check')
      end

      specify do
        expect(Pulsar::Task).to have_received(:call)
          .with(repository: repo, application: 'blog', environment: 'production', task: 'deploy:check')
      end

      context 'success' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        let(:success) { "Executed task deploy:check for blog on production!" }
        let(:result) { spy(success?: true) }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(/#{success}/).to_stdout
        end
      end

      context 'failure' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        let(:result) { spy(success?: false) }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(fail_text).to_stdout
        end
      end
    end

    context 'when using configuration file' do
      let(:options) { {} }

      before do
        allow(described_instance).to receive(:options).and_return(options)
        described_instance.task('blog', 'production', 'deploy:check')
      end

      around do |example|
        old_const = Pulsar::PULSAR_CONF
        Pulsar.send(:remove_const, 'PULSAR_CONF')
        Pulsar::PULSAR_CONF = RSpec.configuration.pulsar_dotenv_conf_path
        example.run
        Pulsar.send(:remove_const, 'PULSAR_CONF')
        Pulsar::PULSAR_CONF = old_const
      end

      specify do
        expect(Pulsar::Task).to have_received(:call)
          .with(repository: repo, application: 'blog', environment: 'production', task: 'deploy:check')
      end

      context 'success' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        let(:success) { "Executed task deploy:check for blog on production!" }
        let(:result) { spy(success?: true) }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(/#{success}/).to_stdout
        end

        context 'when file is unaccessible' do
          let(:options) { { conf_repo: repo } }

          around do |example|
            system("chmod 000 #{RSpec.configuration.pulsar_dotenv_conf_path}")
            example.run
            system("chmod 644 #{RSpec.configuration.pulsar_dotenv_conf_path}")
          end

          it do
            expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(/#{success}/).to_stdout
          end
        end
      end

      context 'failure' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        let(:result) { spy(success?: false) }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(fail_text).to_stdout
        end
      end
    end

    context 'when using PULSAR_CONF_REPO' do
      before do
        allow(described_instance).to receive(:options).and_return({})
        ENV['PULSAR_CONF_REPO'] = repo
        described_instance.task('blog', 'production', 'deploy:check')
      end

      specify do
        expect(Pulsar::Task).to have_received(:call)
          .with(repository: repo, application: 'blog', environment: 'production', task: 'deploy:check')
      end

      context 'success' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        let(:success) { "Executed task deploy:check for blog on production!" }
        let(:result) { spy(success?: true) }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(/#{success}/).to_stdout
        end
      end

      context 'failure' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        let(:result) { spy(success?: false) }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to output(fail_text).to_stdout
        end
      end
    end

    context 'when no configuration repo is passed' do
      context 'failure' do
        subject { -> { described_instance.task('blog', 'production', 'deploy:check') } }

        it do
          expect { described_instance.task('blog', 'production', 'deploy:check') }.to raise_error(Thor::RequiredArgumentMissingError)
        end
      end
    end
  end
end
