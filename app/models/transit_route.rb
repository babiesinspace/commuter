class TransitRoute
  include HTTParty
  base_uri 'maps.googleapis.com/maps/api/directions/json?'

  def initialize(origin, destination, arrival_time)
    @options = { query: { mode: 'transit', origin: origin, destination: destination, arrival_time: arrival_time, key: ENV['GOOGLE_ROUTES_API_KEY']} }
  end

  def get_route
    self.class.get(@options)
  end

  # def users
  #   self.class.get("/2.2/users", @options)
  # end
end

#   base_uri 'api.stackexchange.com'
#   response = HTTParty.get('http://api.stackexchange.com/2.2/questions?site=stackoverflow')
# https://maps.googleapis.com/maps/api/directions/json?&mode=transit&origin=540+saint+johns+place+brooklyn+ny+11238&destination=90+john+street+new+york+ny&arrival_time=1527699039&key=AIzaSyArxzeiN4HHA34q1ncsyPaCIC4bzQ4Mt0s