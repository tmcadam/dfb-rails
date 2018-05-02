source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# rails gems
gem 'rails', '5.1.6'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

# app specific gems
gem 'bootstrap-sass', '~> 3.3.6'
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
gem 'isotope-rails', '~> 2.2', '>= 2.2.2'
gem 'scrollto-rails'
gem 'devise'
gem 'rufus-scheduler'
gem "cocoon"
gem 'validates_email_format_of'

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
    gem 'minitest-rails'
    gem 'selenium-webdriver'
    gem 'rails-controller-testing'
    gem 'database_cleaner'
end
