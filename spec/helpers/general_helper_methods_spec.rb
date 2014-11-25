require 'spec_helper'

describe Sinatra::GeneralHelperMethods do 
  include Sinatra::GeneralHelperMethods

  describe '::return_json' do 
    context 'hash' do 
      it 'returns JSON' do 
        hash = {foo: 'bar'}
        expect(return_json(hash)).to eql hash.to_json
      end
    end

    context 'empty string' do 
      it 'returns nil' do 
        expect(return_json('')).to eql nil
      end
    end

    context 'nothing' do 
      it 'returns nil' do 
        expect(return_json(nil)).to eql nil
      end
    end
  end

  describe '::request_body' do 
    it 'indicates request_body is a hash' do
      post '/test/request-body', {foo: 'bar'}.to_json
      expect(last_response.body).to eql('Hash')
    end
  end

  describe '::sanitize_attributes!' do 
    context 'when attributes are all permitted' do 
      it 'doesn\'t change the hash' do 
        hash = {:foo => :bar}
        expect{ sanitize_attributes!(hash) }.not_to change(hash, :keys)
      end
    end

    context 'when there are unpermitted attributes' do 
      let(:hash) {
        {
          id: 476,
          title: 'Hello world',
          created_at: 'Four days ago',
          updated_at: 'Just now',
          owner_id: '2'
        }
      }

      it 'removes disallowed attributes' do 
        sanitize_attributes!(hash)
        expect(hash).to eql({title: 'Hello world'})
      end

      it 'returns the hash' do 
        expect(sanitize_attributes!(hash)).to eql hash
      end
    end

    context 'when there are no permitted attributes' do 
      it 'returns an empty hash' do 
        expect(sanitize_attributes!({id: 4})).to eql({})
      end
    end
  end
end