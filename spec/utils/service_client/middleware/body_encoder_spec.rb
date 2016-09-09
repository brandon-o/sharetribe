require 'spec_helper'

describe ServiceClient::Middleware::BodyEncoder do

  def expect_headers(ctx, mime_type)
    expect(ctx[:req][:headers]).to include(
                                     "Accept" => mime_type,
                                     "Content-Type" => mime_type,
                                   )
  end

  let(:body_encoder) { ServiceClient::Middleware::BodyEncoder }

  describe "JSONEncoder" do

    let(:encoder) { body_encoder.new(:json) }

    it "#enter" do
      ctx = encoder.enter(req: { body: {"a" => 1}, headers: {}})

      expect(JSON.parse(ctx[:req][:body])).to eq({"a" => 1})
      expect_headers(ctx, "application/json")
    end

    it "#leave" do
      ctx = encoder.leave(res: { body: {"a" => 1}.to_json })
      expect(ctx[:res][:body]).to eq({"a" => 1})
    end
  end

  describe "TransitEncoder" do

    describe "transit+json" do

      let(:encoder) { body_encoder.new(:transit_json) }

      it "#enter" do
        ctx = encoder.enter(req: { body: {a: 1}, headers: {}})

        expect(TransitUtils.decode(ctx[:req][:body], :json)).to eq({a: 1})
        expect_headers(ctx, "application/transit+json")
      end

      it "#leave" do
        ctx = encoder.leave(res: { body: TransitUtils.encode({a: 1}, :json) })
        expect(ctx[:res][:body]).to eq({a: 1})
      end
    end

    describe "transit+msgpack" do

      let(:encoder) { body_encoder.new(:transit_msgpack) }

      it "#enter" do
        ctx = encoder.enter(req: { body: {a: 1}, headers: {}})

        expect(TransitUtils.decode(ctx[:req][:body], :msgpack)).to eq({a: 1})
        expect_headers(ctx, "application/transit+msgpack")
      end

      it "#leave" do
        ctx = encoder.leave(res: { body: TransitUtils.encode({a: 1}, :msgpack) })
        expect(ctx[:res][:body]).to eq({a: 1})
      end
    end
  end
end
