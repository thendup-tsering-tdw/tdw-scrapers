require 'mechanize'
require 'awesome_print'
require 'zip'
require 'open-uri'
require 'net/http'
require 'uri'
require 'tempfile'
require 'nokogiri'
require 'csv'
require 'titleize'
require 'pdf-reader'

API_KEY = 'AIzaSyD0kGtJ5C0sgtRF312cBSg0mVjIfd2yE4o'

############################################################
# Geocode Address
def get_response(query)
  query = query + 'Sturgeon Canada'
  encoded_query = CGI.escape(query)
  response = JSON.parse(open("https://maps.googleapis.com/maps/api/geocode/json?address=#{encoded_query}&key=#{API_KEY}").read)
  result = response['results'][0]

  street_number = nil
  route = nil
  locality = nil
  administrative_area_level_1 = nil
  administrative_area_level_2 = nil
  country = nil
  postal_code = nil
  latitude = nil
  longitude = nil

  unless result.nil?
    unless result['address_components'].nil?
      result['address_components'].each do |component|
        if component['types'][0] == 'street_number'
          street_number = component['long_name']
        elsif component['types'][0] == 'route'
          route = component['long_name']
        elsif component['types'][0] == 'locality'
          locality = component['long_name']
        elsif component['types'][0] == 'administrative_area_level_1'
          administrative_area_level_1 = component['long_name']
        elsif component['types'][0] == 'administrative_area_level_2'
          administrative_area_level_2 = component['long_name']
        elsif component['types'][0] == 'country'
          country = component['long_name']
        elsif component['types'][0] == 'postal_code'
          postal_code = component['long_name']
        end
      end
    end
    latitude = result['geometry']['location']['lat']
    longitude = result['geometry']['location']['lng']
  end

  {
    street_number: street_number,
    route: route,
    locality: locality,
    administrative_area_level_1: administrative_area_level_1,
    administrative_area_level_2: administrative_area_level_2,
    country: country,
    postal_code: postal_code,
    latitude: latitude,
    longitude: longitude
  }

end
############################################################
