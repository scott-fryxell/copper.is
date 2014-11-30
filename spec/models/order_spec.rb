describe Order, :type => :model do
  subject() { build!(:order) }

  describe '#save' do

    context 'with a user' do

      it "should succeed" do
        expect(subject.user).to be_truthy
        expect(subject.save).to be_truthy
      end

    end

    context 'without a user' do

      it "should fail" do
        subject.user = nil
        expect(subject.save).to be_falsey
      end

    end

  end

  describe '#process!' do
    subject { create!(:order) }

    it ':current => :unpaid' do

      expect(subject.current?).to be_truthy
      subject.process!
      subject.reload
      expect(subject.unpaid?).to be_truthy

    end

  end

  describe '#charge' do

    context 'good CC info' do
      subject(:current) { create!(:order_billable) }
      subject(:unpaid) { create!(:order_unpaid) }
      subject(:denied) { create!(:order_denied) }

      it 'current = > paid' do

        expect(current.billable?).to be_truthy
        current.rotate!
        expect(current.unpaid?).to be_truthy
        current.charge!
        current.reload

      end


      it ':unpaid => :paid' do
        expect(unpaid.unpaid?).to be_truthy
        unpaid.charge!
        unpaid.reload
        expect(unpaid.paid?).to be_truthy
      end

      it ':denied => :paid' do
        expect(denied.denied?).to be_truthy
        denied.charge!
        unpaid.reload
        expect(denied.paid?).to be_truthy
      end

    end

    context 'bad CC info' do

      subject() { build!(:order_unpaid) }

      it ':unpaid => :denied' do

        allow(Stripe::Charge).to receive(:create).and_raise(
          Stripe::CardError.new(':message', ':param', 'declined',  402, nil,nil) )

        expect(subject.unpaid?).to be_truthy
        expect{ subject.charge! }.to raise_error(Stripe::CardError)
        subject.reload
        expect(subject.denied?).to be_truthy

      end

    end

    context 'expired CC' do

      subject() { build!(:order_unpaid) }

      it ':unpaid => :denied' do

        allow(Stripe::Charge).to receive(:create).and_raise(
        Stripe::CardError.new( ':message', ':param', 'expired_card', 402, nil,nil) )

        expect(subject.unpaid?).to be_truthy
        expect{ subject.charge! }.to raise_error(Stripe::CardError)
        subject.reload
        expect(subject.denied?).to be_truthy
        expect(Order).to have_queued(subject.id, :send_card_expired_message)

      end


    end

  end

  describe '#billable?' do

    context 'current' do

      it 'is billable' do
        billable_order = create!(:order_billable)
        expect(billable_order.tips.count).to eq(5)
        expect(billable_order.tips.sum(:amount_in_cents) ).to eq(500)
        expect(billable_order.billable?).to be_truthy
      end

      it 'isn\'t billable' do
        expect(subject.tips.count).to eq(0)
        expect(subject.tips.sum(:amount_in_cents) ).to eq(0)
        expect(subject.user.can_give?).to be_falsey
        expect(subject.billable?).to be_falsey
      end

    end

  end

  describe '#subtotal' do

    context 'without tips' do

      it 'should return 0' do
        expect(subject.subtotal).to eq(0)
      end

    end

    context 'with tips' do
      subject() {create!(:order_billable)}

      it 'should return 500' do
        expect(subject.subtotal).to eq(500)
      end

    end

  end

  describe '#subtotal_in_dollars' do

    context 'without tips' do

      it 'should return 0.00' do
        expect(subject.subtotal_in_dollars).to eq('0.00')
      end

    end

    context 'with tips' do
      subject() {create!(:order_billable)}
      it 'should return 5.00' do
        expect(subject.subtotal_in_dollars).to eq('5.00')
      end

    end
  end

  describe '#fees' do

    context 'without tips' do

      it 'should return zero' do
        expect(subject.fees).to eq(0)
      end

    end

    context 'with tips' do

      subject() {create!(:order_billable)}
      it 'should return 50' do
        expect(subject.fees).to eq(50)
      end

    end
  end

  describe '#fees_in_dolars' do

    context 'without tips' do

      it 'should return 0.00' do
        expect(subject.fees_in_dollars).to eq('0.00')
      end

    end

    context 'without tips' do
      subject() {create!(:order_billable)}
      it 'should return 0.50' do
        expect(subject.fees_in_dollars).to eq('0.50')
      end

    end
  end

  describe '#total' do

    context 'without tips' do

      it 'should return 0' do
        expect(subject.total).to eq(0)
      end

    end

    context 'with tips' do
      subject() {create!(:order_billable)}
      it 'should return 550' do
        expect(subject.total).to eq(550)
      end

    end

  end

  describe '#total_in_dollars' do

    context 'without tips' do

      it 'should return 0.00' do
        expect(subject.total_in_dollars).to eq('0.00')
      end

    end

    context 'with tips' do

      it 'should return 5.50' do
        expect(subject.total_in_dollars) == '5.50'
      end

    end


  end

end
