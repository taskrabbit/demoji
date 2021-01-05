require 'spec_helper'

describe TestUser do

  def ord_to_str(ord)
    ord.chr("UTF-8")
  end

  it "doesn't blow up when trying to save emoji" do
    u = TestUser.new
    u.name = ord_to_str(65554)
    expect{ u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql ""
  end

  it "only tries to fix once" do
    allow_any_instance_of(TestUser).to receive(:create).and_raise(ActiveRecord::StatementInvalid.new("Mysql2::Error: Incorrect string value: things!"))
    expect_any_instance_of(TestUser).to receive(:_fix_utf8_attributes).once

    u = TestUser.new
    u.name = ord_to_str(65554)
    expect{ u.save }.to raise_error(ActiveRecord::StatementInvalid)
    expect(u).to_not be_persisted
  end

  it "leaves other chars alone" do
    u = TestUser.new
    u.name = "Peter Perez\n#{ord_to_str(65554)}"
    expect{ u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql "Peter Perez"
  end

  it "fixes non-binary columns but leaves binary columns alone" do
    u = TestUser.new
    u.name = "Peter Perez\n#{ord_to_str(65554)}"
    cart = "some binary data #{ord_to_str(65554)}"
    u.cart = cart
    expect{ u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql "Peter Perez"
    expect(u.reload.cart).to eql "some binary data #{ord_to_str(65554)}".force_encoding("ASCII-8BIT")
  end

  it "doesn't mess up with valid language specific chars" do
    u = TestUser.new
    u.name = "#{ord_to_str(252)}"
    expect { u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql "#{ord_to_str(252)}"
  end

  it "doesn't remove valid 3-byte utf8 chars" do
    u = TestUser.new
    u.name = "#{ord_to_str(10004)} #{ord_to_str(10027)} \xE2\x9C\x8C\xEF\xB8\x8F #{ord_to_str(66318)} abc"
    expect { u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql "#{ord_to_str(10004)} #{ord_to_str(10027)} \xE2\x9C\x8C\xEF\xB8\x8F   abc"
  end

  it "removes emoji modifier chars" do
    u = TestUser.new
    u.name = "#{ord_to_str(10004)} #{ord_to_str(10027)} \xE2\x9C\x8C\xF0\x9F\x8F\xBE #{ord_to_str(66318)} abc"
    expect { u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql "#{ord_to_str(10004)} #{ord_to_str(10027)} #{ord_to_str(9996)}    abc"
  end
end
