# Starting Block

Rails 6 application template including the following standard packages and setup steps:

* Dotenv
* Devise
* Foreman
* Faker
* Webpack CSS packaging
* Bootstrap
* Font Awesome
* Database initialization
* GitHub remote setup (optional)

## Requirements

* Rails 6.0.0 or above
* An empty GitHub repository (optional)

## Usage

To build a project with the latest version of the template:

```
rails new [project-name] \
  -m https://raw.githubusercontent.com/thewillgabriel/starting-block/master/template.rb
```

...or include database setup (for example, PostgreSQL):

```
rails new [project-name] \
  -d postgresql \
  -m https://raw.githubusercontent.com/thewillgabriel/starting-block/master/template.rb
```

If you would like to modify the template, clone it to your system:

```
git clone https://github.com/TheWillGabriel/starting-block.git
```

...then, after you've made your modifications, point `rails new` to the local directory instead:

```
rails new [project-name] -m [starting-block-directory]/template.rb
```
