# This file is the driver of the application. It gets the information from
# the Spotify API and then sends the actual text message.

# This application uses the RSpotify library. All credit for that goes here:
# https://github.com/guilhermesad/rspotify

# Author: Cody Perry (CPerry26)

require 'rspotify'
require 'twilio-ruby'

class SpotifyRN
	# This array contains the different genres to find new releases for.
	GENRES = ["rap", "hip-hop", "r&b"]

	# These are the client app authorization keys required to make calls to
	# the Spotify API.
	CLIENT_ID = "5c8595d229b84961b9f6038526e35323"
	CLIENT_SECRET = "34ad767420d64b6ba1440553ed8285f0"

	# These are the keys for the Twilio API.
	APP_SID = "AC13465bd382ed5fe5d08299a7f2fa592c"
	APP_AUTH = "bdb8bb7902dca17b98f001685a9f5445"

	# A list of phone numbers to send notifications to.
	PHONE_NUMBERS = ["+14012567204"]
	TWILIO_NUMBER = "+17743077136"

	def initialize
		RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)
	end

	# This method gets and returns the newest 50 albums released
	# on Spotify for the United States.
	#
	# Parameters: None
	#
	# Returns:
	# 	=> A list of RSpotify albums (the newest 50 releases in the US).
	def get_new_releases
		return RSpotify::Album.new_releases(country: 'US', limit: 20)
	end

	# This method filters the full results for the releases in the desired
	# GENRES and released on the current day. The idea is this application
	# would be run every Friday on the release day of Spotify.
	#
	# Parameters:
	# 	=> releases : A list of releases to filter.
	#
	# Returns:
	# 	=> An array of filtered results.
	def filter_releases(releases)
		filteredResults = []

		releases.each { |release| 
			release.genres.each { |genre|
				if GENRES.include? genre and 
					release.release_date.eql? Time.now.strftime("%Y-%m-%d")
					
					filteredResults << release
				end
			}
		}

		return filteredResults
	end

	# This function builds the text message text which gets sent the phone
	# numbers.
	#
	# Parameters:
	# 	=> releases : A set of releases to be sent to the phone numbers.
	#
	# Returns:
	# 	=> A string with the text to send.
	def build_text_string(releases)
		albums = "Albums:\n"
		singles = "Singles:\n"
		compilations = "Compilations:\n"

		releases.each { |release|
			if release.album_type.eql? "album"
				albums << "- " << release.name << " : " 
				
				release.artists.each { |artist| 
					albums << artist.name

					albums << ", " if release.artists.last != artist
				}

				albums << "\n"
			elsif release.album_type.eql? "single"
				singles << "- " << release.name << " : "
				
				release.artists.each { |artist| 
					singles << artist.name

					singles << ", " if release.artists.last != artist
				}

				singles << "\n"
			else
				compilations << "- " << release.name << " : "
				
				release.artists.each { |artist| 
					compilations << artist.name

					compilations << ", " if release.artists.last != artist
				}

				compilations << "\n"
			end
		}

		albums << "None\n" if albums.length < 8
		singles << "None\n" if singles.length < 9
		compilations << "None\n" if compilations.length < 14

		return albums + "\n" + singles + "\n" + compilations
	end

	# This method sends the constructed text message to each phone number
	# in the PHONE_NUMBERS array.
	#
	# Parameters:
	# 	=> textMessage : The text message to send.
	#
	# Returns: None
	def send_text_message(textMessage)
		client = Twilio::REST::Client.new(APP_SID, APP_AUTH)

		PHONE_NUMBERS.each { |number| 
			begin
				client.messages.create(
					from: TWILIO_NUMBER,
					to: number,
					body: textMessage
				)
			rescue Exception => e
				print("Could not send text message! See below:\n" + e.to_s + "\n")
				return
			end

			print("Text message sent to " + number + " successfully!")
		}
	end
end

instance = SpotifyRN.new

testing = instance.get_new_releases

#testing = instance.filter_releases(testing)

#print(testing)

testText = instance.build_text_string(testing)

print(testText)

instance.send_text_message(testText)