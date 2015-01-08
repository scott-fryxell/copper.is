describe 'The whole code base' do

  it 'loads all the factories successfully', :slow do
    FactoryGirl.lint
  end

  it 'contains no code smells', :broken do
    expect(Dir['lib/**/*.rb']).not_to reek
    expect(Dir['app/**/*.rb']).not_to reek
  end

end
