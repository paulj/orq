require 'orq/impulse'

describe ORQ::Impulse do
  it "should be inheritable with default details" do
    class TrivialObj < ORQ::Impulse
    end
    
    TrivialObj.uri.should == 'TrivialObj'
  end
  
  it "should get fully qualified details by default" do
    module TrivialNS
      class TrivialObj < ORQ::Impulse
      end
    end
    
    TrivialNS::TrivialObj.uri.should == 'TrivialNS::TrivialObj'
  end
  
  it "should allow multiple different types to be created with overidden uri" do
    class FirstTrivialNamedObj < ORQ::Impulse
      uri 'http://vuderacha.com/orq/trivial_named/first'
    end
    class SecondTrivialNamedObj < ORQ::Impulse
      uri 'http://vuderacha.com/orq/trivial_named/second'
    end
    
    FirstTrivialNamedObj.uri.should == 'http://vuderacha.com/orq/trivial_named/first'
    SecondTrivialNamedObj.uri.should == 'http://vuderacha.com/orq/trivial_named/second'
  end
  
  it "should support the declaration of fields" do
    class FieldedImpulse < ORQ::Impulse
      field :first_val
      field :second_val
    end
    
    f = FieldedImpulse.new
    f.first_val = 'a'
    f.second_val = 'b'
    f.first_val.should == 'a'
    f.second_val.should == 'b'
  end
  
  it "should support restoring from a hash" do
    class RestorableImpulse < ORQ::Impulse
      field :first_val
      field :second_val
    end
    
    f = RestorableImpulse.new({:first_val => 1, :second_val => 'a'})
    f.first_val.should == 1
    f.second_val.should == 'a'
  end
  
  it "should support restoring from a hash with too many values" do
    class AnotherRestorableImpulse < ORQ::Impulse
      field :first_val
      field :second_val
    end
    
    f = AnotherRestorableImpulse.new({:first_val => 1, :second_val => 'a', :third_val => [1,2,3]})
    f.first_val.should == 1
    f.second_val.should == 'a'
  end
  
  it "should support configuration from a YAML file" do
    ORQ::Impulse.configure 'spec/simple_config.yml', :development
  end
  
  it "should return default as a target name when not overriden" do
    class DefaultTargetImpulse < ORQ::Impulse; end
    DefaultTargetImpulse.target_name.should == 'default'
  end

  it "should return the configured target name" do
    class SpecialTargetImpulse < ORQ::Impulse
      target_name 'special'
    end
    SpecialTargetImpulse.target_name.should == 'special'
  end
end

describe "configured #{ORQ::Impulse}" do
  before(:all) do
    ORQ::Impulse.configure 'spec/stub_config.yml', :development
  end
  
  it "should provide its uri and content to the adapter when being fired" do
    class AnotherFireableImpulse < ORQ::Impulse 
      field :simple
    end
    StubAdapter.instance.should_receive(:fire).with('AnotherFireableImpulse', '{"simple": "a"}')
    
    i = AnotherFireableImpulse.new({:simple => 'a'})
    i.fire!
  end
  
  it "should support subscribing with a block" do
    # Declare our subscribable impulse
    class SubscribableImpulse < ORQ::Impulse
      field :a
    end
    
    # Create our receiver
    r = []
    
    # Extend the stub adapter to respond the way that way we want it to
    class StubAdapter
      def subscribe(type, &block)
        type.should == SubscribableImpulse
        yield SubscribableImpulse.new({:a => 1})
      end
    end
    
    # Perform the subscription
    SubscribableImpulse.subscribe do |imp|
      r << imp
    end
    
    r.length.should == 1
    r[0].a.should == 1
  end
end