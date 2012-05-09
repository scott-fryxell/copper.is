def slow_test
  unless ENV['FAST_TEST']
    yield
  else
    it 'skipping slow tests'
  end
end

