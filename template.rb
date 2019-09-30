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

  setup_webpack
  add_packs
  setup_packs
end

def add_gems
  add_devise
  add_dotenv
  add_foreman
  add_faker
end

def setup_gems
  setup_devise
  setup_dotenv
  setup_foreman
end

def add_packs
  add_bootstrap
end

def setup_packs
  setup_bootstrap
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
  append_to_file '.env', "PORT=3000\n"
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

def setup_webpack
  run 'mkdir app/javascript/stylesheets &&'\
      ' touch app/javascript/stylesheets/application.scss'
  append_to_file 'app/javascript/packs/application.js',
                 "import '../stylesheets/application'\n"
  gsub_file 'app/views/layouts/application.html.erb',
            /stylesheet_link_tag/, 'stylesheet_pack_tag'
end

def add_bootstrap
  run 'yarn add bootstrap jquery popper.js'
end

def setup_bootstrap
  insert_into_file 'config/webpack/environment.js', after: /require\('@rails\/webpacker'\)\n/ do
    <<~JS
      const webpack = require('webpack')
      environment.plugins.append(
        'Provide',
        new webpack.ProvidePlugin({
          $: 'jquery',
          jQuery: 'jquery',
          Popper: ['popper.js', 'default']
        })
      )

    JS
  end

  run 'touch app/javascript/packs/bootstrap_custom.js &&'\
      ' touch app/javascript/stylesheets/bootstrap_custom.scss'

  insert_into_file 'app/javascript/packs/bootstrap_custom.js' do
    <<~JS
      import 'bootstrap/js/dist/alert'
      import 'bootstrap/js/dist/button'
      import 'bootstrap/js/dist/carousel'
      import 'bootstrap/js/dist/collapse'
      import 'bootstrap/js/dist/dropdown'
      import 'bootstrap/js/dist/index'
      import 'bootstrap/js/dist/modal'
      import 'bootstrap/js/dist/popover'
      import 'bootstrap/js/dist/scrollspy'
      import 'bootstrap/js/dist/tab'
      import 'bootstrap/js/dist/toast'
      import 'bootstrap/js/dist/tooltip'
      import 'bootstrap/js/dist/util'

    JS
  end
  insert_into_file 'app/javascript/stylesheets/bootstrap_custom.scss' do
    <<~SCSS
      @import '~bootstrap/scss/_functions.scss';
      @import '~bootstrap/scss/_variables.scss';
      @import '~bootstrap/scss/_mixins.scss';
      @import '~bootstrap/scss/_root.scss';
      @import '~bootstrap/scss/_reboot.scss';
      @import '~bootstrap/scss/_type.scss';
      @import '~bootstrap/scss/_alert.scss';
      @import '~bootstrap/scss/_badge';
      @import '~bootstrap/scss/_breadcrumb';
      @import '~bootstrap/scss/_button-group';
      @import '~bootstrap/scss/_buttons';
      @import '~bootstrap/scss/_buttons.scss';
      @import '~bootstrap/scss/_card.scss';
      @import '~bootstrap/scss/_carousel.scss';
      @import '~bootstrap/scss/_close.scss';
      @import '~bootstrap/scss/_code.scss';
      @import '~bootstrap/scss/_custom-forms.scss';
      @import '~bootstrap/scss/_dropdown.scss';
      @import '~bootstrap/scss/_forms.scss';
      @import '~bootstrap/scss/_grid.scss';
      @import '~bootstrap/scss/_images.scss';
      @import '~bootstrap/scss/_input-group.scss';
      @import '~bootstrap/scss/_jumbotron.scss';
      @import '~bootstrap/scss/_list-group.scss';
      @import '~bootstrap/scss/_media.scss';
      @import '~bootstrap/scss/_modal.scss';
      @import '~bootstrap/scss/_nav.scss';
      @import '~bootstrap/scss/_navbar.scss';
      @import '~bootstrap/scss/_pagination.scss';
      @import '~bootstrap/scss/_popover.scss';
      @import '~bootstrap/scss/_print.scss';
      @import '~bootstrap/scss/_progress.scss';
      @import '~bootstrap/scss/_spinners.scss';
      @import '~bootstrap/scss/_tables.scss';
      @import '~bootstrap/scss/_toasts.scss';
      @import '~bootstrap/scss/_tooltip.scss';
      @import '~bootstrap/scss/_transitions.scss';
      @import '~bootstrap/scss/_utilities.scss';

    SCSS
  end

  insert_into_file 'app/javascript/packs/application.js',
                   "import './bootstrap_custom.js'\n"
  insert_into_file 'app/javascript/stylesheets/application.scss',
                   "@import './bootstrap_custom.scss';\n"
end

# This will launch the template build process
build_template!
