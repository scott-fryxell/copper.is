shared_examples_for "Itemable" do
  it '#item_id' do
    expect(page.item_id).to eq("/pages/#{page.id}")
  end

  it '#nested' do
    expect(page.nested?).to be_falsey
  end

  it '#as_item_attributes' do
    expect(page.as_item_attributes).to eq %Q[
        itemscope itemtype='page'
        itemid='#{page.item_id}'
        itemprop='author_state'
        data-author_state='#{page.author_state}'
      ]
  end

end
