# Spotify-RN
Spotify-RN is an application which sends text updates for new releases on Spotify. I wrote this because going through Spotify's browse tab for new releases can be very cumbersome when there are a plethora of new releases. On top of this, Spotify doesn't display whether the release is an album, single or compilation directly to the user. Personally, I like listening to singles first and then make my way through the albums. Spotify-RN will separate those in the text message so you can decide to listen in whatever order you desire.

## Current Issues
As of right now everything works besides the genre filtering. Essentially RSpotify displays the genre for every release as nil so it isn't possible to filter the results. I'm unsure if this is a bug in RSpotify or if Spotify just isn't tagging the releases with a genre. I'm investigating this and hoping to have it fixed soon.

## Why not a script?
As of now, Spotify-RN behaves just like a Ruby script. I decided to make it a class with its own methods for the purpose of extensibility. Whether I implement new features or if someone wanted to use Spotify-RN in their application (i.e. build a custom playlist for themselves with those new releases), getting the output from an instance would be nicer and cleaner than running the script and getting the output from either a created file or the command line.

## Future of Spotify-RN
- [ ] Fix genre filtering
- [ ] Deploy the application so it automatically sends the texts every Friday


## How to run
Spotify-RN requires both the RSpotify and Twilio gems. To install these, run:
<br>`gem install rspotify`
<br>`gem install twilio-ruby`

Once both gems are installed, add your Spotify app ID and secret keys, as well as your Twilio SID and AUTH keys. Both sets of these can be obtained by creating/registering your application with the Spotify Developer's console and Twilio. Spotify-RN will **NOT** run without these!

After the keys are entered. Edit the `TWILIO_NUMBER` variable with your Twilio phone number and the array of phone numbers (`PHONE_NUMBERS`) with all the numbers you'd like to send release notifications to.

With all the above complete, you run:
<br>`ruby spotify_rn.rb`

Each number you wanted to send a text to will receive a text message shortly. An example is:
<br>Albums:
- QUAVO HUNCHO : Quavo
- "A" : Usher, Zaytoven
- Ella Mai : Ella Mai
- Bottle It In : Kurt Vile
- Things That We Drink To : Morgan Evans
- Fully Loaded : Shy Glizzy
- IMMIGRANT : Belly
- Always In Between (Deluxe) : Jess Glynne

Singles:
- Spotify Singles : Panic! At The Disco
- Spotify Singles : SG Lewis
- Spotify Singles : Blanco White
- MIA (feat. Drake) : Bad Bunny
- ZEZE (feat. Travis Scott & Offset) : Kodak Black
- Inolvidable (Remix) : Farruko, Daddy Yankee, Sean Paul
- Let's Go (The Royal We) : Run The Jewels
- Cowboy : ALMA
- Love You Anymore : Michael Bublé
- Under Pressure : Shawn Mendes
- Woman Like Me (feat. Nicki Minaj) : Little Mix, Nicki Minaj
- I'm Still Here : Sia

Compilations:
None

## Issues
If any issues are discovered or a feature is requested, feel free to file an issue and I will get to it! Of course, if you want to fix it yourself that's fine too. Just submit a PR!
