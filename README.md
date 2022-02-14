# README

# Rose Hearthstone Quest

Purpose: Provide a user with a hand of 10 Hearthstone cards <br/>

## Summary

The app utlizes Blizzard's API to generates a random hand of 10 Hearthstone cards.
The cards must have a rarity of legendary, be a Warlock or Druid and have a Mana of at least 7.
The hand is displayed in a human readable table that shows the card image, name, type, rarity, set and class and is sorted by the cardId.

### Environemnt Variables

Environment Variable should be included in a secret manager mechanism such as Vault, Paramater Store, etc...

CLIENT_ID - used for Blizzard API calls

CLIENT_SECRET - used for Blizzard API calls

### Run Locally

To run this app you will need to first clone the repo using:

`git clone git@github.com:RDoukas/Rose-Hearthstone-Quest.git`

Move into that directory and install the gems using Bundler:

`bundle install`

Run the rails server in the console using:

`rails s`

Open your favorite GUI or web browser and use the url `localhost:3000/cards` to see your cards!
