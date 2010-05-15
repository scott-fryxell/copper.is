# Loads preformatted mail body output for comparison in specs.
module MailTestHelper
  FIXTURE_LOAD_PATH = File.join(Rails.root, 'spec/fixtures')
  
  def load_mail_fixture(example_message)
    File.read(File.join(FIXTURE_LOAD_PATH, example_message))
  end
end
