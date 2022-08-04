require 'rails_helper' 

RSpec.describe Discount, type: :model do 
  describe 'validations' do 
    it { should validate_presence_of(:discount)}
    it { should_validate_numericality_of(:discount).only_float}
    it { should validate_presence_of(:threshold)}
    it { should_validate_numericality_of(:threshold).only_integer}
  end
end