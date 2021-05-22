source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# rails gems
gem 'rails', '6.1.3.1'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'sassc', '2.1.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'tzinfo-data'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'

# app specific gems
gem 'bootstrap', '>=4.6', '<5.0.0'
gem "font-awesome-rails"
gem 'autoprefixer-rails'
gem 'jquery-rails'
gem 'yui-compressor'
gem 'json'
gem 'truncate_html'
gem 'kaminari', :git => 'https://github.com/kaminari/kaminari'
gem "paperclip", "~> 5.2.1"
gem 'simple_form'
gem 'lightbox-bootstrap-rails', '5.1.0.1'
gem 'pg'
gem 'summernote-rails', :git => 'https://github.com/summernote/summernote-rails.git'
gem 'scrollto-rails'
gem "devise", ">= 4.7.1"
gem 'rufus-scheduler'
gem "cocoon"
gem 'validates_email_format_of'
gem "nokogiri", ">= 1.11.0"
gem "typhoeus"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails_real_favicon'
end

group :test do
    gem 'capybara', '~> 2.13'
    gem "minitest-rails", "~> 6.1.0"
    gem 'selenium-webdriver'
    gem 'rails-controller-testing'
    gem 'database_cleaner'
end
