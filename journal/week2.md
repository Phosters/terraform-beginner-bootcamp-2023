# Terraform Beginner Bootcamp 2023 - Week 2

### Working with Ruby

#### Bundler 
Bundler is a package maanager for Ruby. 
It is the primary way to install ruby packages **(known as gems)** for ruby.

#### Install Ruby
You need to create a **Gemfile** and define your gems in that file.

```
source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'

```

Then you need to run the `bundle install` command 
This installs the gems on the system globally (unlike nodejs that installs packages in a folder called **node_modules**)
A Gemfile lock will be created to lock down the gem versions used in the project 

#### Executing ruby scripts in the context of bundler
We have to use `bundle exec` to tell future ruby scripts to use the gems we installed.
This is the way we set context

#### Sinatra
Sinatra is a micro web-webframework for ruby to build web apps.
Its great for mock or development servers or for simple projects
You can simply create a web-server in a single file
[Sinatra](https://sinatrarb.com/)

## Terratowns Mock Web Server 

### Running the Web Server
We can run the web server by executing the following commands

```rb
bundle install
bundle exec ruby server.rb 

```
All the codes for our web server are in the `server.rb` file

## CRUD
Terraform Provider resources utilizes CRUD

CRUD stands for create, read, update and delete

[CRUD](https://www.codecademy.com/article/what-is-crud)
