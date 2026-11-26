module Pulsar
  # How an application is named in Pulsar's output. Magic Template runs pass the app "magic" and
  # name the real site in the environment, so they read "haventest using magic".
  module AppLabel
    MAGIC = 'magic'.freeze
    # Where the Magic Template looks up the site name, in the same order
    NAME_VARIABLES = %w[PULSAR_APP_NAME CODER_WORKSPACE_NAME].freeze

    module_function

    def for(application, env = ENV)
      return application unless application.to_s == MAGIC

      name = NAME_VARIABLES.map { |var| env[var].to_s.strip }.find { |value| !value.empty? }
      name && name != MAGIC ? "#{name} using #{MAGIC}" : application
    end
  end
end
