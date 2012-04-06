require 'rake/testtask'

module TestSubset
  class Task

    def initialize(name, *expressions, &block)
      @name = name
      @list = {}
      if block_given?
        yield self
        combo_test_task("units_and_functionals", "units", "functionals")
        combo_test_task("functionals_and_integration", "functionals", "integration")
        combo_test_task("units_and_integration", "units", "integration")
        combo_test_task("", "units", "functionals", "integration")
        alias_test_task("functionals_and_units", "units_and_functionals")
        alias_test_task("integration_and_units", "units_and_integration")
        alias_test_task("functionals_and_integration", "integration_and_functionals")
      else
        test_task("", *expressions)
      end
    end

    def integration(*expressions)
      expressions = expressions.map {|a| "test/integration/#{a}_test.rb" }
      test_task("integration", *expressions)
    end

    def functionals(*expressions)
      expressions = expressions.map {|a| "test/functional/#{a}_test.rb" }
      test_task("functionals", *expressions)
    end

    def units(*expressions)
      expressions = expressions.map {|a| "test/unit/#{a}_test.rb" }
      test_task("units", *expressions)
    end

    private
    def test_task(name, *expressions)
      @list[name] = expressions
      Rake::TestTask.new(task_name[name]) do |test|
        test.libs << 'lib' << 'test'
        test.test_files = FileList[*@list[name]]
        test.verbose = true
      end
    end

    def combo_test_task(name, *keys)
      test_tasks = keys.map {|k| task_name[k] }
      Rake::Task.define_task task_name[name] => test_tasks
    end

    def alias_test_task(name, real_name)
      Rake::Task.define_task task_name[name] => task_name[real_name]
    end

    def task_name
      @task_name ||= Hash.new do |h,k|
                       h[k] = ["test:#{@name}", k].compact.
                                                   reject(&:empty?).
                                                   join(":")
                     end
    end

  end
end
