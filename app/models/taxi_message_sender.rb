class TaxiMessageSender

  # urban airship app key used for the driver app
  DRIVER_APP_KEY = ENV['URBAN_AIRSHIP_APP_KEY']
  # urban airship master secret key used for driver app
  DRIVER_MASTER_KEY = ENV['URBAN_AIRSHIP_MASTER_SECRET']
  #Urban airship app secret key used for driver app
  DRIVER_APP_SECRET = ENV['URBAN_AIRSHIP_APP_SECRET']

  def initialize
    Urbanairship.application_key = DRIVER_APP_KEY
    Urbanairship.application_secret = DRIVER_APP_SECRET
    Urbanairship.master_secret = DRIVER_MASTER_KEY
    Urbanairship.logger = Rails.logger
    Urbanairship.request_timeout = 5 # default
    @options = {
        :expiry => "300"
    }
  end

  def notify_broadcast(alert,  key_values={})
    notification = {
        :android=>{
            :alert=>alert,
            :extra=>key_values
        },
        :options=>@options
    }
    Urbanairship.broadcast_push(notification)
  end

  def notify_update(alert, driver_id, service_id)
    driver = Driver.find(driver_id)
    apid_driver = driver.apid_driver
    apid_value = apid_driver.value
    notification = {
        :apids => [apid_value],
        :android => {
            :alert => alert,
            :extra => {:service_id => service_id.to_s, :"com.thinkbites.taxista.state_changed" => "com.thinkbites.taxista.state_changed"}
        }
    }
    Urbanairship.push(notification)
  rescue ActiveRecord::RecordNotFound
    puts '---- No se encontro el driver para notificar ---'
  end

  def notify_create_service(service_id, tags)
    if tags == '' || tags == nil
    notify_broadcast('',
                     {
                         :service_id=>service_id.to_s,
                         :"com.thinkbites.taxista.new_service"=>"com.thinkbites.taxista.new_service"
                     }
    )
    else
      notify_push_tag('',
                      {
                          :service_id=>service_id.to_s,
                          :"com.thinkbites.taxista.new_service"=>"com.thinkbites.taxista.new_service"
                      },
                      tags
      )
    end
  end

  def notify_push_tag(alert,  key_values={}, tags)
    notification = {
        :tags => [tags],
        :android=>{
            :alert=>alert,
            :extra=>key_values
        },
        :options=>@options
    }
    Urbanairship.push(notification)
  end

end