require 'spec_helper'
require './lib/registrant'
require './lib/facility'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    @facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
    @registrant_1 = Registrant.new('Bruce', 18, true )
    @registrant_2 = Registrant.new('Penny', 16 )
    @registrant_3 = Registrant.new('Tucker', 15 )
  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('Albany DMV Office')
      expect(@facility.address).to eq('2242 Santiam Hwy SE Albany OR 97321')
      expect(@facility.phone).to eq('541-967-2014')
      expect(@facility.services).to eq([])
    end
  end
  describe '#registered vehicles' do
    it 'can keep data on register vehicles' do 
      expect(@facility.registered_vehicles).to eq([])
      expect(@facility_2.registered_vehicles).to eq([])
    end 
  end
  describe '#register vehicles' do
    it 'can register vehicles' do
      @facility.add_service('Vehicle Registration')
      @facility.register_vehicle(@cruz)
      @facility.register_vehicle(@camaro)
      @facility.register_vehicle(@bolt)
      expect(@facility.registered_vehicles).to eq([@cruz, @camaro, @bolt])
    end
    it 'can update registration dates on vehicles' do
      @facility.add_service('Vehicle Registration')
      @facility.register_vehicle(@cruz)
      @facility.register_vehicle(@camaro)
      @facility.register_vehicle(@bolt)
      expect(@cruz.registration_date).to eq(Date.today)
      expect(@camaro.registration_date).to eq(Date.today)
      expect(@bolt.registration_date).to eq(Date.today)
    end
    it 'can assign plate type' do
      @facility.add_service('Vehicle Registration')
      @facility.register_vehicle(@cruz)
      @facility.register_vehicle(@camaro)
      @facility.register_vehicle(@bolt)
      expect(@cruz.plate_type).to eq :regular
      expect(@camaro.plate_type).to eq :antique
      expect(@bolt.plate_type).to eq :ev
    end
    it 'cannot register vehicle if does not offer service' do
      @facility.add_service('Vehicle Registration')
      @facility.register_vehicle(@cruz)
      @facility.register_vehicle(@camaro)
      @facility.register_vehicle(@bolt)
      expect(@facility.registered_vehicles).to eq([@cruz, @camaro, @bolt]) 
      expect(@facility_2.register_vehicle(@bolt)).to eq(nil)
      expect(@facility_2.registered_vehicles).to eq([])
    end
    it 'keeps track of collected fees' do
      @facility.add_service('Vehicle Registration')
      @facility.register_vehicle(@cruz)
      @facility.register_vehicle(@camaro)
      @facility.register_vehicle(@bolt)
      expect(@facility.collected_fees).to eq(325)
      expect(@facility_2.collected_fees).to eq(0)
    end
  end
  describe '#add service' do
    it 'can add available services' do
      expect(@facility.services).to eq([])
      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')
      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
      expect(@facility_2.services).to eq([])
    end
  end
  describe '#written test' do
    it 'can provide driver data' do
      @registrant_1.license_data
      @registrant_1.permit?
      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
      expect(@registrant_1.permit?).to eq(true)
    end
    it "cant administer a test it doesn't offer" do
      @facility.services.include?('Written Test')
      @facility.administer_written_test(@registrant_1)
      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
      expect(@facility.services.include?('Written Test')).to eq (false)
      expect(@facility.administer_written_test(@registrant_1)).to eq(false)
      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
    end
    it 'can add services' do
      @facility.services.include?('Written Test')
      @facility.add_service('Written Test')
      expect(@facility.services).to eq(['Written Test'])
      expect(@facility.services.include?('Written Test')).to eq (true)
      expect(@facility.administer_written_test(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false} )
    end
    it 'cant give some services to those 16 with no permit' do
      expect(@registrant_2.age).to eq(16)
      expect(@registrant_2.permit?).to eq(false)
      expect(@facility.administer_written_test(@registrant_2)).to eq(false)
    end
    it 'can give give a written test to those who are 16 plus with a permit' do
      @facility.add_service('Written Test')
      @registrant_2.earn_permit
      @registrant_2.permit?
      expect(@facility.services.include?('Written Test')).to eq(true)
      expect(@facility.administer_written_test(@registrant_2)).to eq(true)
      expect(@registrant_2.permit?).to eq(true)
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>false, :renewed=>false} )
    end
    it 'cannot provide service to those who do not qualify' do
      @facility.add_service('Written Test')
      expect(@registrant_3.age).to eq (15)
      expect(@registrant_3.permit?).to eq(false)
      expect(@facility.administer_written_test(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
    end
    it 'cannot give a written test if they are not of age' do
      @facility.add_service('Written Test')
      @registrant_3.earn_permit
      expect(@registrant_3.age).to eq(15)
      expect(@registrant_3.permit?).to eq(true)
      expect(@facility.administer_written_test(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
    end
  end
  describe '#road test' do
    it 'cannot provide a license with no written test' do
      @registrant_3.earn_permit
      expect(@facility.administer_road_test(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false} )
    end
    it 'cannot give a road test if it does not offer the service' do
      expect(@facility.administer_road_test(@registrant_1)).to eq(false)
    end
    it 'can add services to those who qualify' do 
      @facility.add_service('Road Test')
      @facility.add_service('Written Test')
      @registrant_2.earn_permit
      @facility.administer_written_test(@registrant_1)
      @facility.administer_written_test(@registrant_2)
      @facility.administer_road_test(@registrant_1)
      @facility.administer_road_test(@registrant_2)
      expect(@facility.administer_road_test(@registrant_1)).to eq(true)
      expect(@facility.administer_road_test(@registrant_2)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
    end
  end
  describe '#Renew License' do
    it 'cannot renew a license if it does not offer the service' do
      expect(@facility.renew_drivers_license(@registrant_1)).to eq(false)
      end
    it 'can add services' do
      @facility.add_service('Written Test')
      @facility.add_service('Road Test')
      @facility.add_service('Renew License')
      expect(@facility.services).to eq(['Written Test', 'Road Test', 'Renew License'])
      end
    it 'can renew a license sometimes' do
      @facility.add_service('Written Test')
      @facility.add_service('Road Test')
      @facility.add_service('Renew License')
      @registrant_2.earn_permit
      @registrant_3.earn_permit
      @facility.administer_written_test(@registrant_1)
      @facility.administer_road_test(@registrant_1)
      @facility.renew_drivers_license(@registrant_1)
      @facility.administer_written_test(@registrant_2)
      @facility.administer_road_test(@registrant_2)
      @facility.renew_drivers_license(@registrant_2)
      @facility.administer_written_test(@registrant_3)
      expect(@facility.renew_drivers_license(@registrant_1)).to eq(true)
      expect(@facility.renew_drivers_license(@registrant_2)).to eq(true)
      expect(@facility.administer_written_test(@registrant_3)).to eq(false)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  end
end
