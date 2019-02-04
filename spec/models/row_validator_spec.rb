require 'rails_helper'

describe RowValidator do
  context 'Verify validator without params' do
    let(:object){ RowValidator.new({}) }
    let(:error_msg){
      object.valid?
      object.errors.full_messages
    }

    it 'expect valid false' do
      expect(object.valid?).to eq false
    end

    it 'expect phone number should presents' do
      expect(error_msg).to include("Phone can't be blank")
    end

    it 'expect email should presents' do
      expect(error_msg).to include("Email can't be blank")
    end

    it 'expect valid email id' do
      expect(error_msg).to include("Email is invalid")
    end

    it 'expect presents of first_name or last_name' do
      expect(error_msg).to include("First name or last name shoul be present.")
    end

    it 'expect valid row_id' do
      expect(error_msg).to include("Row can't be blank")
    end
  end

  context 'Validate with values' do
    # let(:object){ RowValidator.new()
    let(:attrs) {
      { row_id: 1,
        first: 'first name',
        last: 'last name',
        phone: '(123)321-3123',
        email: 'krishna@krishna.in',
        identifier_id: 1
      }
    }
    it 'Check the valid values' do
      obj =  RowValidator.new(attrs)
      expect(obj.valid?).to eq true
      expect(obj.errors.full_messages).to eq []
    end

    it 'Check the invalid email' do
      attrs[:email] = 'test@test'
      obj =  RowValidator.new(attrs)
      expect(obj.valid?).to eq false
      expect(obj.errors.full_messages).to include("Email is invalid")
    end

    it 'Check the phone validation' do
      attrs[:phone] = '342.432-43244'
      obj =  RowValidator.new(attrs)
      expect(obj.valid?).to eq false
      expect(obj.errors.full_messages).to include("Phone is the wrong length (should be 10 characters).")
    end
  end
end