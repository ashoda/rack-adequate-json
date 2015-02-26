module Rack
  class AdequateJson
    attr_reader :app, :root, :target_param, :status, :headers, :response

    def initialize(app , options={})
      @app = app
      @root = options.fetch(:root, nil)
      @target_param = options.fetch(:target_param, "fields")
    end

    def call(env)
      call_and_setup(env)
      if content_type_json? && filter_fields
        [status, headers, [filtered_json_body]]
      else
        [status, headers, response]
      end
    end

    protected

    def call_and_setup(env)
      @status, @headers, @response = app.call(env)
      @request = request(env)
      @filter_fields = nil
    end

    def filtered_json_body
      json_body = JSON.parse(response.body)
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

    def slice_data!(data, fields)
      data.select!{|k,v| fields.include?(k) } if fields
    end

    def params
      @request.params
    end

    def content_type_json?
      @headers["Content-Type"].include?("json")
    end

    def request(env)
      Rack::Request.new(env)
    end
  end
end
