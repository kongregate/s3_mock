# S3Mock

Quick and dirty mocking for S3 using https://github.com/freerange/mocha

## Installation

Add this line to your application's Gemfile:

    gem 's3_mock'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_mock

## Usage

In your test or test_helper, include like so:

```
include S3Mock
```

Look at the [test](test/s3_mock_test.rb) for examples



## Contributing

1. Fork it ( https://github.com/[my-github-username]/s3_mock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
