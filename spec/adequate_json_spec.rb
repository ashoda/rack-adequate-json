require 'json'

describe Rack::AdequateJson do
  include Rack::Test::Methods
  
  let(:app) { -> {[200,{},[json_body]]} }
  let(:stack) { binding.pry  }#Rack::AdequateJson.
  let(:json_body) {
    {
      data:[
        {id:1, name:'test', city:'San Francisco'},
        {id:1, name:'test', city:'Oakland'}
      ]
    }.to_json
  }
  let(:request) { Rack::MockRequest.new(stack) }

  describe "#call" do
    context "filter fields provided in query params" do
      let(:response) { request.get('/') }
      it { expect(response.body).to eq({"data"=>[{}]}.to_json) }
    end

    context "filter fields not provided in query params" do

    end
  end
end
