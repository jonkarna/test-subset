require 'test-subset'
require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'turn'
require 'mocha'

module TestSubset
  class TaskTest < Test::Unit::TestCase
    subject { TestSubset::Task.new("foo") }

    context "#integration" do
      should "add integration tests" do
        subject.expects(:test_task).with("integration", "test/integration/foo/*_test.rb")
        subject.integration "foo/*"
      end
    end

    context "#functionals" do
      should "add functional tests" do
        subject.expects(:test_task).with("functionals", "test/functional/foo/*_test.rb")
        subject.functionals "foo/*"
      end
    end

    context "#units" do
      should "add unit tests" do
        subject.expects(:test_task).with("units", "test/unit/foo/*_test.rb")
        subject.units "foo/*"
      end
    end

    context "helper methods" do
      setup do
        @args = ["test_section", "1", "2"]
        Rake::TestTask.expects(:new).with("test:foo")
      end

      context "#test_task" do
        should "create a rake test task with the proper name" do
          Rake::TestTask.expects(:new).with("test:foo:test_section")
          subject.send(:test_task, *@args)
        end
      end

      context "#combo_test_task" do
        should "create a rake task that requires a group of tasks" do
          Rake::Task.expects(:define_task).
                     with("test:foo:test_section" => ["test:foo:1",
                                                      "test:foo:2"])
          subject.send(:combo_test_task, *@args)
        end
      end

      context "#alias_test_task" do
        should "create a rake task that requires one other task" do
          Rake::Task.expects(:define_task).
                     with("test:foo:another_one" => "test:foo:one")
          subject.send(:alias_test_task, "another_one", "one")
        end
      end

      context "#task_name" do
        should "use the common pattern for all names expect blanks" do
          task_name = subject.send(:task_name)
          assert_equal "test:foo:whatever", task_name["whatever"]
          assert_equal "test:foo", task_name[""]
          assert_equal "test:foo", task_name[nil]
        end
      end
    end

    context "TestSubset::Task Class" do
      subject { TestSubset::Task }

      context "#new" do
        should "create a tesk task" do
          subject.any_instance.expects(:test_task).
                               with("", "test/units/foo/*_test.rb")
          subject.new(:foo, "test/units/foo/*_test.rb")
        end

        context "with a block" do
          should "#units" do
            subject.any_instance.expects(:units).with("foo/*")
            subject.any_instance.expects(:functionals).with("foo/*")
            subject.any_instance.expects(:integration).with("foo/*")
            subject.any_instance.expects(:combo_test_task).times(4)
            subject.any_instance.expects(:alias_test_task).times(3)
            subject.new("foo") do |test|
              test.units "foo/*"
              test.functionals "foo/*"
              test.integration "foo/*"
            end
          end
        end
      end
    end
  end
end
