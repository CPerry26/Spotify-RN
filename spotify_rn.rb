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
	CLIENT_ID = "YOUR_CLIENT_ID"
	CLIENT_SECRET = "YOUR_CLIENT_SECRET"

	# These are the keys for the Twilio API.
	APP_SID = "TWILIO_SID"
	APP_AUTH = "TWILIO_AUTH"

	# A list of phone numbers to send notifications to.
	# They need to be in the following format:
	# [+country code][area code][phone number]
	# i.e. "+12225557777"
	PHONE_NUMBERS = ["YOUR_PHONE_NUMBERS"]
	TWILIO_NUMBER = "YOUR_TWILIO_NUMBER"

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
		return RSpotify::Album.new_releases(country: 'US', limit: 50)
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
				if release.release_date.eql? Time.now.strftime("%Y-%m-%d")
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

		# Add "None" if no results were found for that category.
		albums << "None\n" if albums.length <= 8
		singles << "None\n" if singles.length <= 9
		compilations << "None\n" if compilations.length <= 14

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

spotifyRN = SpotifyRN.new

newReleases = spotifyRN.get_new_releases

filteredResults = spotifyRN.filter_releases(newReleases)

textBody = spotifyRN.build_text_string(filteredResults)

spotifyRN.send_text_message(textBody)