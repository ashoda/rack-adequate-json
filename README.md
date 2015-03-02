# Rack Adequate Json

Filters JSON response given attribute names to reduce payload size

## Installation

Add this line to your application's Gemfile:

    gem 'rack-adequate-json'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-adequate-json

## Configure

### Rails

``` ruby  
#config/application.rb
module AppName
  class Application < Rails::Application
    # Middleware options
    # root: the root key for the json payload     , default: nil
    # target_param: query param of filter fields  , default: 'fields'
    config.middleware.use 'Rack::AdequateJson' , { root: 'data' }
  end
end
```

### Sinatra

``` ruby
require 'rack/adequate_json'

class AppName < Sinatra::Base
  configure do
    # Middleware options
    # root: the root key for the json payload     , default: nil
    # target_param: query param of filter fields  , default: 'fields'
    use Rack::AdequateJson , { root: 'data' , target_param: 'select' }
  end
end

```


## Contributing

1. Fork it ( http://github.com/<my-github-username>/rack-adequate-json/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
