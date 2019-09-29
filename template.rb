# Rails 6 application template
# Usage: rails new [app_name] -m https://raw.githubusercontent.com/thewillgabriel/starting-block/master/template.rb -d postgresql

RAILS_VERSION = ">= 6.0.0"

def confirm_rails_version
  required_version = Gem::Requirement.new(RAILS_VERSION)
  current_version = Gem::Version.new(Rails::VERSION::STRING)
  return if required_version.satisfied_by?(current_version)

  puts "Please install Rails #{RAILS_VERSION} to use this template. Aborting."
  exit 1
end

def build_template!
  confirm_rails_version

  gemfile_categories
  add_gems
  run 'bundle install'

  after_bundle do
    setup_gems
  end
end

def add_gems
  # Call add methods here
  add_devise
  add_dotenv
  add_foreman
end

def setup_gems
  # Call setup gem methods here
  setup_devise
  setup_dotenv
  setup_foreman
end

def gemfile_categories
  append_to_file 'Gemfile' do
    <<~RUBY
      # APIs

      # Frontend

      # Tools

    RUBY
  end
end

def add_devise
  insert_into_file 'Gemfile', "gem 'devise'\n", after: /# Tools\n/
end

def setup_devise
  rails_command 'g devise:install'
  rails_command 'g devise:views'
  rails_command 'g devise User'
  environment 'config.action_mailer.default_url_options =
    {host: "localhost", port: ENV["PORT"]}', env: 'development'
end

def add_dotenv
  gem_group :development, :test do
    gem 'dotenv-rails'
  end
end

def setup_dotenv
  run 'touch .env'
  append_to_file '.env', 'PORT=3000'
  append_to_file '.gitignore', ".env\n"
end

def add_foreman
  gem_group :development do
    gem 'foreman'
  end
end

def setup_foreman
  run 'touch Procfile.dev && mkdir ./tmp/pids'
  append_to_file 'Procfile.dev' do
    <<~RUBY
      web: bundle exec puma -p $PORT -C config/puma.rb
      webpacker: ./bin/webpack-dev-server
    RUBY
  end
end

def add_faker
  insert_into_file 'Gemfile', "gem 'faker'\n", after: /# Tools\n/
end

# This will launch the template build process
build_template!
