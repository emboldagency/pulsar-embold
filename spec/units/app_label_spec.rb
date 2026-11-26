require 'spec_helper'

RSpec.describe Pulsar::AppLabel do
  it 'leaves a regular application name alone' do
    expect(described_class.for('blog', 'PULSAR_APP_NAME' => 'haventest')).to eq('blog')
  end

  it 'names the site for a magic run' do
    expect(described_class.for('magic', 'PULSAR_APP_NAME' => 'haventest')).to eq('haventest using magic')
  end

  it 'falls back to the Coder workspace name' do
    expect(described_class.for('magic', 'CODER_WORKSPACE_NAME' => 'haventest')).to eq('haventest using magic')
  end

  it 'prefers PULSAR_APP_NAME over the Coder workspace name' do
    env = { 'PULSAR_APP_NAME' => 'haventest', 'CODER_WORKSPACE_NAME' => 'workspace' }
    expect(described_class.for('magic', env)).to eq('haventest using magic')
  end

  it 'says magic when no site name is set' do
    expect(described_class.for('magic', {})).to eq('magic')
    expect(described_class.for('magic', 'PULSAR_APP_NAME' => '  ')).to eq('magic')
  end
end
