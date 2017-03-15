# Tweetbot
#### TU/e [DBSU10] "Technologies for connectivity"
###### [Anne Kok](http://github.com/AnneKok), [Dianne Vasseur](http://github.com/Dmvasseur), [Manon Blankendaal](http://github.com/Manonx4), [Marcin van de Ven](http://github.com/marzman95)
Software & File repository for group 4 of the course "Technologies for connectivity" [DBSU10], TU/e

## API Documentation
### API calls through [OOCSI](https://github.com/iddi/oocsi)
The OOCSI channel we are monitoring is `tweetBot`. Set up a direct sender to our channel like this:
```Processing
oocsi = new OOCSI(this, "<Groupname>", "oocsi.id.tue.nl");
```
Where \<Groupname\> has to be replaced by your groupname and between double qoutes `"`.

#### General tweet
If you want our Tweetbot to simply send out a tweet, use key-value pair with tweet as key, and the text of the tweet you want to send as value. In Processing, it looks like this:
```Processing
oocsi
  .channel("tweetBot")
  .data("tweet", "text of your tweet here")
  .send();
```
The tweet text cannot be more than 140 characters. The same tweet cannot be sent twice in a row.

#### API calls through Twitter
Our Twitter handle is [@Tweetbot_DBSU10](http://twitter.com/tweetbot_dbsu10). Send a tweet to `@Tweetbot_DBSU10` containing one of the following inputs to achieve the specified result.

| Input | Result |
| -------- | -------- |
| Deadline | Tweetbot replies with the next deadlines for DBSU10. |
| Order pizza | Tweetbot orders you pizza through OOCSI using Group 3's module and tweets you a confirmation. |
| I want pizza | Tweetbot orders you pizza through OOCSI using Group 3's module and tweets you a confirmation. |
| Order coffee | Tweetbot orders you coffee through OOCSI using Group 2's module and tweets you a confirmation. |
| I want coffee | Tweetbot orders you coffee through OOCSI using Group 2's module and tweets you a confirmation. |

Tweets should contain the exact input string, so `order me pizza` will not work. The API is not case-sensitive, so `order pizza` will work. An example:
`Hey @Tweetbot_DBSU10, can you please order pizza for me?`
