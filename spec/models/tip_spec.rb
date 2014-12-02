describe Tip, :type => :model do

  subject { build!(:tip) }

  describe '#save' do

    context 'with a order' do

      it "should save" do
        expect(subject.save).to be_truthy
        expect(subject.order).not_to be_nil
        expect(subject.amount_in_cents).to eq 100
      end

    end

    context 'without an order' do

      it "should not save" do
        subject.order = build!(:order_paid)
        expect(subject.save).to be_falsey
      end

    end

  end

  it '#amount_in_cents' do
    expect(subject.amount_in_cents).to eq 100
  end

  it '#thumbnail' do
    expect(subject.thumbnail).to eq 'http://example.com/image.png'
  end

  it '#title' do
    expect(subject.title).to eq 'Page Title'
  end

  it '#url' do
    expect(subject.url).to eq URI.parse(subject.page.url)
  end

  it '#amount_in_dollars' do
    expect(subject.amount_in_dollars).to eq "1.00"
  end

  describe '#destroy' do
    context 'promised'do
      it 'should succeed' do
        expect(subject.save).to be_truthy

        expect(subject.destroy).to be_truthy
      end
    end
  end

  describe '#validate_presence_of_paid_order' do
  end

  describe '#validate_presence_of_check' do

  end

  it 'should not allow a tip of 0 cents' do
    tip = Tip.new(:amount_in_cents => 0)
    subject.order = create!(:order_unpaid)
    # subject.save
    expect(subject.valid?).to be_falsey
  end

  it 'should not allow a tip of -1 cents' do
    tip = Tip.new(:amount_in_cents => -1)

    subject.order = create!(:order_unpaid)

    expect(subject.valid?).to be_falsey
  end
end
