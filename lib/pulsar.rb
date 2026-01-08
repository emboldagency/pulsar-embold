require 'pulsar/version'

module Pulsar
  # Silence noisy warnings from Bundler/RubyGems
  # This must run before requiring bundler to have effect
  $VERBOSE = nil

  require 'bundler'
  require 'thor'
  require 'rake'
  require 'dotenv'
  require 'interactor'
  require 'fileutils'

  require 'pulsar/context_error'
  require 'pulsar/validator'
  require 'pulsar/interactors/cleanup'
  require 'pulsar/interactors/create_run_dirs'
  require 'pulsar/interactors/add_applications'
  require 'pulsar/interactors/clone_repository'
  require 'pulsar/interactors/copy_initial_repository'
  require 'pulsar/interactors/identify_repository_type'
  require 'pulsar/interactors/identify_repository_location'
  require 'pulsar/interactors/create_capfile'
  require 'pulsar/interactors/create_deploy_file'
  require 'pulsar/interactors/copy_environment_file'
  require 'pulsar/interactors/run_bundle_install'
  require 'pulsar/interactors/run_capistrano'

  require 'pulsar/organizers/list'
  require 'pulsar/organizers/install'
  require 'pulsar/organizers/task'

  require 'pulsar/constants'
  require 'pulsar/cli'

  # Silence Rake output
  # Default to non-verbose; allow override via ENV `PULSAR_VERBOSE`
  Rake::FileUtilsExt.verbose_flag = (
    ENV['PULSAR_VERBOSE'] == '1' || ENV['PULSAR_VERBOSE']&.downcase == 'true'
  )
end
