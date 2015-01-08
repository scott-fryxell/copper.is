shared_examples_for "Itemable" do
  it '#item_id' do
    expect(subject.item_id).to eq("/pages/#{subject.id}")
  end

  it '#nested' do
    expect(subject.nested?).to be_falsey
  end

  it '#as_item_attributes' do
    expect(subject.as_item_attributes).to eq %Q[
        itemscope itemtype='page'
        itemid='#{subject.item_id}'
        itemprop='author_state'
        data-author_state='#{subject.author_state}'
      ]
  end

end
