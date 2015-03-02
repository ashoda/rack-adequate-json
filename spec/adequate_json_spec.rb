require 'json'
require 'rack/test'

describe 'Rack::AdequateJson' do
  include Rack::Test::Methods
  let(:app) { ->(env) { [200,{"Content-Type" => "application/json" }, [original_json] ] } }
  let(:stack) { Rack::AdequateJson.new(app, root: root_key ) }
  let(:request) { Rack::MockRequest.new(stack) }

  RSpec.shared_examples "json field filtering middleware" do
    context "with filter fields provide" do
      it { expect(response.body).to eq(filtered_json) }
    end

    context "with no filter fields provide" do
      let(:query_params) { nil }
      it { expect(response.body).to eq(original_json) }
    end
  end

  describe "request passing through middleware" do
    let(:url) { '/' }
    let(:query_params) { '?fields=a,b' }
    let(:response) { request.get("#{url}#{query_params}") }

    context "given root element" do
      let(:root_key) { "data" }
      context "collection" do
        let(:original_json) { {data:[{a:1, b:'test1', c:'rest2'},{a:2, b:'test2', c:'rest2'}]}.to_json }
        let(:filtered_json) { {data:[{a:1, b:'test1'},{a:2, b:'test2'}]}.to_json }
        it_behaves_like "json field filtering middleware"
      end
      context "object" do
        let(:original_json) { {data:{a:1, b:'test1', c:'rest2'}}.to_json }
        let(:filtered_json) { {data:{a:1, b:'test1'}}.to_json }
        it_behaves_like "json field filtering middleware"
      end
    end

    context "given no root element" do
      let(:root_key) { nil }
      context "given collection" do
        let(:original_json) { [{a:1, b:'test1', c:'rest2'},{a:2, b:'test2', c:'rest2'}].to_json }
        let(:filtered_json) { [{a:1, b:'test1'},{a:2, b:'test2'}].to_json }
        it_behaves_like "json field filtering middleware"
      end
      context "given object" do
        let(:original_json) { {a:1, b:'test1', c:'rest2'}.to_json }
        let(:filtered_json) { {a:1, b:'test1'}.to_json }
        it_behaves_like "json field filtering middleware"
      end
    end
  end

end
