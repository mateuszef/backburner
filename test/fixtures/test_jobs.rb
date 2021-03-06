$worker_test_count = 0
$worker_success = false

class TestJob
  include Backburner::Queue
  queue_priority 1000
  def self.perform(x, y); $worker_test_count += x + y; end
end

class TestFailJob
  include Backburner::Queue
  def self.perform(x, y); raise RuntimeError; end
end

class TestRetryJob
  include Backburner::Queue
  def self.perform(x, y)
    $worker_test_count += 1
    raise RuntimeError unless $worker_test_count > 2
    $worker_success = true
  end
end

class TestAsyncJob
  include Backburner::Performable
  def self.foo(x, y); $worker_test_count = x * y; end
end