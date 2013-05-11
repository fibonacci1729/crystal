require 'spec_helper'

describe 'Code gen: nil' do
  it "codegens empty program" do
    run('')
  end

  it "codegens nil? for Object gives false" do
    run('require "object"; Object.new.nil?').to_b.should be_false
  end

  it "codegens nil? for Object gives true" do
    run(%Q(
      require "nil"

      class Foo
        def initialize
          if false
            @x = Object.new
          end
          1
        end

        def x
          @x
        end
      end

      Foo.new.x.nil?
      )).to_b.should be_true
  end

  it "codegens nil? for primitives gives false" do
    run("0.nil?").to_b.should be_false
  end

  it "codegens nilable dispatch" do
    run(%q(
      def foo(x)
        x
      end

      a = nil
      a = "foo"

      foo(a)
      )).to_string.should eq('foo')
  end

  it "codegens nilable dispatch with obj nilable" do
    run(%q(
      class Nil
        def foo
          1
        end
      end

      class Foo
        def foo
          2
        end
      end

      a = Foo.new
      a = nil
      a.foo
      )).to_i.should eq(1)
  end

  it "assigns nilable to union" do
    run(%q(
      a = nil
      a = "foo"
      a = Object.new

      b = nil
      b = "foo"

      a = b
      )).to_string.should eq('foo')
  end
end
