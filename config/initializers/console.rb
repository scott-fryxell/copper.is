Copper::Application.configure do
  # Use Pry instead of IRB
  silence_warnings do
    begin
      require 'pry'
      IRB = Pry
      module Pry::RailsCommands ;end
      IRB::ExtendCommandBundle = Pry::RailsCommands
    rescue LoadError
    end
  end
end


