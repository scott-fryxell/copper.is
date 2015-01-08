describe Authorizer::Phony, :type => :model do
  subject {build!(:author_phony)}

  describe '#populate_uid_and_username!' do
    context 'has username' do

      it 'finds the uid' do
        subject.uid = nil
        subject.username = '1'
        subject.populate_uid_and_username!
        expect(subject.uid).to eq('1')
      end

    end

    context 'has uid' do

      it 'finds the username' do
        subject.uid = '1'
        subject.username = nil
        subject.populate_uid_and_username!
        expect(subject.username).to eq('1')
      end

    end

    context 'without uid or username' do
      it 'throws an exception' do
        subject.uid = nil
        subject.username = nil
        expect{subject.populate_uid_and_username!}.to raise_error(RuntimeError)
      end
    end

  end
end
