# frozen_string_literal: true

RSpec.describe SingleSignOnRecordSerializer do
  fab!(:user) { Fabricate(:user) }
  let :sso do
    SingleSignOnRecord.create!(user_id: user.id, external_id: '12345', external_email: user.email, last_payload: 'foobar')
  end

  context "admin" do
    fab!(:admin) { Fabricate(:admin) }
    let :serializer do
      SingleSignOnRecordSerializer.new(sso, scope: Guardian.new(admin), root: false)
    end

    it "should include user sso info" do
      payload = serializer.as_json
      expect(payload[:user_id]).to eq(user.id)
      expect(payload[:external_id]).to eq('12345')
      expect(payload[:external_email]).to be_nil
    end
  end

  context "moderator" do
    let(:moderator) { Fabricate(:moderator) }
    let :serializer do
      SingleSignOnRecordSerializer.new(sso, scope: Guardian.new(moderator), root: false)
    end

    it "should not include user sso payload" do
      payload = serializer.as_json
      expect(payload[:user_id]).to eq(user.id)
      expect(payload[:external_id]).to eq('12345')
      expect(payload[:last_payload]).to be_nil
    end
  end
end
