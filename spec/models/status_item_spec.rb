require 'rails_helper'

RSpec.describe StatusItem, type: :model do
  describe 'validatations' do
    describe 'state' do
      context 'valid' do
        it 'with a value of UP' do
          subject = StatusItem.new state: 'UP'
          subject.valid?
          expect(subject.errors[:state]).to be_empty
        end

        it 'with a value of DOWN' do
          subject = StatusItem.new state: 'DOWN'
          subject.valid?
          expect(subject.errors[:state]).to be_empty
        end
      end

      context 'invalid' do
        it 'with no value' do
          subject = StatusItem.new state: nil
          subject.valid?
          expect(subject.errors[:state]).not_to be_empty
        end

        it 'with a value of ANYTHING_ELSE' do
          subject = StatusItem.new state: 'ANYTHING_ELSE'
          subject.valid?
          expect(subject.errors[:state]).not_to be_empty
        end
      end
    end

    describe 'message' do
      context 'valid' do
        it 'has a non-blank value' do
          subject = StatusItem.new message: 'hello'
          subject.valid?
          expect(subject.errors[:message]).to be_empty
        end
      end

      context 'invalid' do
        it 'with nil value' do
          subject = StatusItem.new message: nil
          subject.valid?
          expect(subject.errors[:message]).not_to be_empty
        end

        it 'with blank value' do
          subject = StatusItem.new message: ''
          subject.valid?
          expect(subject.errors[:message]).not_to be_empty
        end
      end
    end
  end
end
