# Epaudit

## Installation

    $ gem install epaudit

## Configuration

Create `$HOME/.epaudit.yaml`:

    ---
    dns:
      nameservers:
        - 8.8.8.8
        - 8.8.4.4
    synthetics:
      apikey: your_newrelic_api_key_here

Follow the instructions for the [Borderlands](https://github.com/fairfaxmedia/borderlands)
gem in order to setup your `$HOME/.edgerc`, required for finding Akamai properties related
to an endpoint.

## Usage

    $ epaudit audit www.sitename.com.au

If you haven't run this recently, or at all, it may take quite a while
to complete, as various data won't have been cached (or will have
expired from cache) and will thus need to be retrieved via various APIs.
Watch the `DEBUG` log messages for details.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/fairfaxmedia/epaudit.

## License

The gem is available as open source under the terms of the [Apache-2.0 License](http://opensource.org/licenses/Apache-2.0).

