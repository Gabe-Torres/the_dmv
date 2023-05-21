RSpec.describe Registrant do
  before(:each) do
      @registrant_1 = Registrant.new({name: 'Bruce', age: 18, permit: true} )
      @registrant_2 = Registrant.new({name: 'Penny', age: 15} )
    end
    describe '#initialize' do
      it 'can initialize' do
        expect(@registrant_1).to be_an_instance_of(Registrant)
        expect(@registrant_2).to be_an_instance_of(Registrant)
        expect(@registrant_1.name).to eq('Bruce')
        expect(@registrant_2.name).to eq('Penny')
        expect(@registrant_1.age).to eq(18)
        expect(@registrant_2.age).to eq(15)
        expect(@registrant_1.permit?).to eq(true)
        expect(@registrant_2.permit?).to eq(false)
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
        expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
      end
  end
    describe '#it has license data' do
      it'can look up license data' do
        expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
        expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
      end
    end
    describe '#earn a permit' do
      it 'can earn a permit' do
        @registrant_1.earn_permit
        @registrant_2.earn_permit
        expect(@registrant_1.permit?).to eq(true)
        expect(@registrant_2.permit?).to eq(true)
      end
    end
end


RSpec.describe Registrant do
  describe "Iteration 1" do
    it 'exist' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Penny', 15)

      expect(registrant_1).to be_an_instance_of(Registrant)
      expect(registrant_2).to be_an_instance_of(Registrant)
    end

  it 'is initialized with attributes' do
    registrant_1 = Registrant.new('Bruce', 18, true)
    registrant_2 = Registrant.new('Penny', 15)

      expect(registrant_1.name).to eq('Bruce')
      expect(registrant_2.name).to eq('Penny')
      expect(registrant_1.age).to eq(18)
      expect(registrant_2.age).to eq(15)
      expect(registrant_1.permit?).to eq(true)
      expect(registrant_2.permit?).to eq(false)
      expect(registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
        expect(registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
    end

    it 'can assign a permit' do
      registrant_1 = Registrant.new('Bruce', 18, true)
      registrant_2 = Registrant.new('Penny', 15)
      registrant_2.earn_permit

      expect(registrant_1.permit?).to eq(true)
      expect(registrant_2.permit?).to eq(true)
    end
  end
end