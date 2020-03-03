# Rubannotate

Annotate Rails classes with schema.


## Installation

Add this line to your application's Gemfile:

  ```ruby
  group :development do
    gem 'rubannotate'
  end
  ```

And then execute:

  ```bash
  $ bundle
  ```

Or install it yourself as:

  ```bash
  $ gem install rubannotate
  ```


## Usage

Add schema information to model files:

  ```bash
  $ bundle exec rake rubannotate:annotate
  ```

This is what a common annotation looks like:

  ```ruby
  # == Schema Information
  #
  # Table name: users
  #
  #  id               :integer  not null, primary key
  #  name             :string   not null
  #  password_digest  :string
  #
  # Indexes
  #
  #  index_users_on_name  (name) UNIQUE
  #
  ```

Remove schema information from model files:

  ```bash
  $ bundle exec rake rubannotate:cleanup
  ```

**Note:** It will automatically annotate every time after `db:migrate` or `db:rollback`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/john-doe-330/rubannotate. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the Rubannotate project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubannotate/blob/master/CODE_OF_CONDUCT.md).
