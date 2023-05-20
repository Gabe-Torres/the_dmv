class Facility

  attr_reader :name, 
              :address, 
              :phone, 
              :services, 
              :registered_vehicles,
              :collected_fees

  def initialize(data)
    @name = data[:name]
    @address = data[:address]
    @phone = data[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def register_vehicle(data)
    @registered_vehicles.push(data)
    data.registration_date = Date.today
    if data.antique? 
      @plate_type = :antique
      @collected_fees += 25
    elsif
        data.electric_vehicle? 
        @plate_type = :ev
        @collected_fees += 200
      else
        data.plate_type = :regular
        @collected_fees += 100
    end
    
  end

  def add_service(service)
    @services << service
  end
end
