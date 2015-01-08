describe EventsController, :type => :controller do

  it 'keep you updated with events', :broken do
    expect(Redis).to receive(:new)
    expect(Redis).to receive(:quit)
    expect(Redis).to receive(:psubscribe)
    expect(Redis).to receive(:pnmessage)
    get_with @me, :publisher
  end


end
