

# pulsar-embold (Embold Fork)

**This is an actively maintained fork of the original [Pulsar](https://github.com/nebulab/pulsar) project by Matteo Latini and Nebulab. The original project is abandoned; Embold maintains this fork for internal and community use.**

**This gem is published as `pulsar-embold` on GitHub Packages.**

The easy [Capistrano][cap-gem] deploy and configuration manager.

Pulsar allows you to run Capistrano tasks via a separate repository where all
your deploy configurations are stored. Once you have your own repository, you
can gradually add configurations and recipes so that you never have to duplicate
code again.

The way Pulsar works means that you can deploy without actually having the
application on your local machine (and neither have all your application
dependencies installed). This lets you integrate Pulsar with nearly any deploy
strategy you can think of.

Some of the benefits of using Pulsar:
* No Capistrano configurations in the application code
* No need to have the application locally to deploy
* Every recipe can be shared between all applications
* Can easily be integrated with other tools
* Write the least possible code to deploy

*DISCLAIMER*: Understanding Capistrano is strongly suggested before using
Pulsar.

## Capistrano support

This version of Pulsar (version `>= 1.0.0`) only supports Capistrano v3. If
you're looking for Capistrano v2 support you can use Pulsar version `0.3.5` but,
take care, that version is not maintained anymore.


## Installation

The recommended way to install this fork is from GitHub Packages:

### Add the GitHub Packages source to your Gemfile:

```ruby
source "https://rubygems.org"
source "https://rubygems.pkg.github.com/emboldagency" do
  gem "pulsar-embold", "~> 1.0"
end
```

Or install directly with:

```sh
gem install pulsar-embold --source "https://rubygems.pkg.github.com/emboldagency"
```

You may need to authenticate with a GitHub personal access token that has `read:packages` scope. See [GitHub Docs](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-rubygems-registry) for details.

This will install the `pulsar` command which will be used for everything, from running Capistrano to listing your configurations.

---

The first thing you'll need to do is to create your own configuration repo:

```bash
$ pulsar install ~/Desktop/pulsar-conf
```

This will create a basic starting point for building your configuration
repository. As soon as you're done configuring you should consider transforming
this folder to a git repository.

You can have a look at how your repository should look like by browsing the
[Pulsar Conf Demo][pulsar-conf-demo].

**NOTE**: Pulsar only supports git.

## Configuration

This is an example repository configuration layout:

```bash
pulsar-conf/
  |── Gemfile
  ├── Gemfile.lock
  ├── apps
  │   ├── Capfile
  │   ├── deploy.rb
  │   └── my_application
  │       ├── Capfile
  │       ├── deploy.rb
  │       ├── production.rb
  │       └── staging.rb
  └── recipes
      ├── generic
      │   ├── maintenance_mode.rake
      │   ├── notify.rake
      │   └── utils.rake
      ├── rails
      │   ├── passenger.rake
      │   ├── repair_permissions.rake
      │   ├── symlink_configs.rake
      │   ├── unicorn.rake
      │   └── whenever.rake
      └── spree_1
          └── symlink_assets.rake
```

Pulsar uses these files to build Capistrano configurations on the fly, depending
on how you invoke the `pulsar` command. Since Pulsar it's basically a Capistrano
wrapper, the content of these files is plain old Capistrano syntax.

### _apps_ directory

This directory contains your application configurations. You'll have one
directory per application.

* `Capfile` is the generic Capfile shared by all applications
* `deploy.rb` has configurations that are shared by all applications
* `my_application/Capfile` is the Capfile that will be used for this particular
application
* `my_application/deploy.rb` includes configuration shared by every stage of the
application
* `my_application/staging.rb` and `my_application/production.rb` files include
stage configurations

### _recipes_ directory

This directory contains your recipes. You can create any number of directories
to organize your recipes. In Capistrano v3 fashion, all the files are plain old
rake tasks (make sure to name them with the `.rake` extension).

The recipes contained in this folder are **always included** in each stage for
each application.

---

Another way to include your recipes is by using the `Gemfile`. Many gems already
include custom recipes for Capistrano so you just need to require those. An
example with [Whenever][whenever]:

```ruby
#
# Inside Gemfile
#
gem 'whenever'

#
# Inside some Capfile (either generic or application specific)
#
require 'whenever/capistrano'

#
# Inside some .rb configuration file (either generic or application specific)
#
set :whenever_command, "bundle exec whenever"
```

### Loading the repository

Once the repository is ready, you'll need to tell Pulsar where it is. The
repository location can be specified either as a full git path or a GitHub
repository path (*i.e.* `gh-user/pulsar-conf`).

Since Pulsar requires the repository for everything, there are multiple ways to
store this information so that you don't have to type it every time. You can
also use local repository, which is useful while developing your deployment.

You have three possibilities:

* `-c` command line option
* `PULSAR_CONF_REPO` environment variable
* `~/.pulsar/config` configuration file

The fastest way is probably the `.pulsar/config` file inside your home
directory:

```bash
#
# Inside ~/.pulsar/config
#
PULSAR_CONF_REPO="gh-user/pulsar-conf"

#
# Also supported
#
# PULSAR_CONF_REPO="git://github.com/gh-user/pulsar-conf.git"
```

Pulsar will read this file and set the environment variables properly.

---

If you don't want to add another file to your home directory you can export the
variables yourself:

```bash
#
# Inside ~/.bash_profile or ~/.zshrc
#
export PULSAR_CONF_REPO="gh-user/pulsar-conf"
```

## Usage

After the repository is ready, running Pulsar is straightforward. You can either
list your applications or build a configuration and run Capistrano on it.

### Deploy

Running the `deploy` command really means running Capistrano on a certain
configuration.

To deploy `my_application` to `production`:

```bash
$ pulsar deploy my_application production
```

The above command will fetch the Pulsar configuration repository, run
`bundle install`, combine the generic `Capfile` and `deploy.rb` files with the
`my_application` specific ones and add specific `production.rb` stage
configuration. At last it will run `cap deploy` on it.

### Listing applications

Pulsar can fetch your configuration repository and list the application and
stages you can run deploys on:

```bash
$ pulsar list
```

This will fetch the Pulsar configuration repository and list everything that's
inside, like this:

```
my_application: production, staging
awesome_startup: dev, production, staging
```

### Execute arbitrary Capistrano tasks

You can launch any Capistrano task via task command. You can also pass arguments in Rake style (i.e. via square brackets after task name)

```
$ pulsar task my_application staging mycustom:task[argumen1,argument2]
```

or via environment variables.

```
$ TASK_ARG1=arg1 TASK_ARG2=arg2 pulsar task my_application staging mycustom:task
```

## Integrations

Pulsar is easy to integrate, you just need access to the configurations
repository and the ability to run a command.

Right now there are no integrations for Pulsar v1 but there are some built for
the old v0.3 version that can be used as an example.

### Chat Bots

- https://gist.github.com/mtylty/5324075: a [hubot][hubot] script that runs
Pulsar via the command line
- [hubot-pulsar][hubot-pulsar]: a [hubot][hubot] plugin for integrating via
[Pulsar REST API][pulsar-rest-api]
- [lita-pulsar][lita-pulsar]: a [Lita][lita] plugin for integrating via the
command line


### Pulsar REST API service

[Pulsar REST API][pulsar-rest-api] is a service to provide a REST API for
executing pulsar jobs.

Here is a [real-life example][pulsar-rest-api-blogpost] of how you can integrate
and simplify your Pulsar workflow.

## About

[![Nebulab][nebulab-logo]][nebulab]


---

## About this fork

This fork is maintained by [Embold](https://embold.com) ([emboldagency](https://github.com/emboldagency)).

The original Pulsar project was created and maintained by Matteo Latini and Nebulab. As the original project is no longer maintained, Embold has adopted and updated this codebase for modern use. All new issues, PRs, and maintenance are handled by the Embold team.

Original author: Matteo Latini ([Nebulab](http://nebulab.it/))

---

[license]: MIT-LICENSE
[cap-gem]: https://rubygems.org/gems/capistrano
[emboldagency]: https://embold.com
[nebulab]: http://nebulab.it/
[nebulab-logo]: http://nebulab.it/assets/images/public/logo.svg
[contact-us]: http://nebulab.it/contact-us/
[pulsar-conf-demo]: http://github.com/nebulab/pulsar-conf-demo
[whenever]: https://github.com/javan/whenever
[hubot]: https://hubot.github.com
[hubot-pulsar]: https://github.com/cargomedia/hubot-pulsar
[pulsar-rest-api]: https://github.com/cargomedia/pulsar-rest-api
[pulsar-rest-api-blogpost]: http://www.cargomedia.ch/2015/06/23/pulsar-rest-api.html
[lita]: https://www.lita.io
[lita-pulsar]: http://github.com/nebulab/lita-pulsar
