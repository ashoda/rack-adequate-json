module Rack
  class AdequateJson
    attr_reader :app, :root, :target_param, :status, :headers

    def initialize(app , options={})
      @app = app
      @root = options.fetch(:root, nil)
      @target_param = options.fetch(:target_param, "fields")
    end

    def call(env)
      call_and_setup(env)
      if content_type_json? && filter_fields
        [ status, headers, response_stream { |b| filter_json_body(b) } ]
      else
        [status, headers, response_stream]
      end
    end

    protected

    def call_and_setup(env)
      @status, @headers, @response = app.call(env)
      @request = request(env)
      @filter_fields = nil
    end

    def filter_json_body(body)
      json_body = JSON.parse(body)
      data = root ? json_body[root] : json_body

      if data.is_a?(Hash)
        slice_data!(data, filter_fields)
      elsif data.is_a?(Array)
        data.each{ |data| slice_data!(data, filter_fields) }
      end

      json_body.to_json
    end

    def filter_fields
      if params[target_param] && !params[target_param].strip.empty?
        @filter_fields ||= params[target_param].split(',').map(&:strip)
      else
        nil
      end
    end

    def response_stream(&block)
      body = @response.map do |body|
        block ? block.call(body) : body
      end
    end

    def slice_data!(data, fields)
      data.select!{|k,v| fields.include?(k) } if fields
    end

    def request(env)
      Rack::Request.new(env)
    end

    def params
      @request.params
    end

    def content_type_json?
      @headers["Content-Type"].include?("json")
    end


  end
end
