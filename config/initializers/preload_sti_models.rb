if Rails.env.development?
  %w[phony].each do |c|
    require_dependency File.join("app","models","sites","#{c}.rb")
  end
end
