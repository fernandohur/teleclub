class Panic < ActiveRecord::Base
<<<<<<< HEAD
  attr_accessible :position_id
  belongs_to :position

  def Panic.construct (taxi_id)

    taxi = Taxi.find(taxi_id)

    position = taxi.get_last_position
    raise NoPositionError, "Taxi with id #{taxi_id} does not have any position" if position == nil
    return Panic.new(:position_id=>position.id)
  rescue ActiveRecord::RecordNotFound
    raise NoTaxiError, "Taxi with id #{taxi_id} must exist" if taxi == nil
  end

  def get_taxi
    position.taxi
=======
  attr_accessible :latitude, :longitude, :taxi_id

  def Panic.construct(latitude, longitude, taxi_id)
		return Panic.new(:latitude=>latitude, :longitude=>longitude, :taxi_id=>taxi_id)
>>>>>>> ceduquey
  end

end
