require 'spec_helper'

describe TestUser do

  it "doesn't blow up when trying to save emoji" do
    u = TestUser.new
    u.name = "😊"
    expect{ u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql ""
  end

  it "only tries to fix once" do
    TestUser.any_instance.stub(:create).and_raise(ActiveRecord::StatementInvalid.new("Mysql2::Error: Incorrect string value: things!"))
    TestUser.any_instance.should_receive(:_fix_utf8_attributes).once

    u = TestUser.new
    u.name = "😊"
    expect{ u.save }.to raise_error
    expect(u).to_not be_persisted
  end

  it "leaves other chars alone" do
    u = TestUser.new
    u.name = "Peter Perez\n😊"
    expect{ u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name.strip).to eql "Peter Perez"
  end

  it "doesn't mess up with valid language specific chars" do
    u = TestUser.new
    u.name = "üç£"
    expect { u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name).to eql "üç£"
  end

   it "doesn't remove valid 3-byte utf8 chars" do
    u = TestUser.new
    u.name = "✔ ✫ 𐌎 abc"
    expect { u.save }.to_not raise_error
    expect(u).to be_persisted
    expect(u.reload.name).to eql "✔ ✫   abc"
  end

end
