import nl.tue.id.oocsi.*;

Connector TwitterConnector;
//Translator TweetTranslator;
String tweet;

void setup() {
  OOCSI oocsi = new OOCSI(this, "TweetReceiver", "oocsi.id.tue.nl");
  oocsi.subscribe("tweetBot");
  
  TwitterConnector = new Connector();
  System.out.println("Timestamp: " + TwitterConnector.timeStamp);
  System.out.println("Nonce: " + TwitterConnector.getNonce());
  System.out.println("ByteNonce: " + TwitterConnector.bEncodedNonce);
  System.out.println(TwitterConnector.createOAuthHeaderString());
}

void tweetBot(OOCSIEvent event) {
  //println(event.getString("tweet"));
  tweet = event.getString("tweet", "Default tweet. Something went wrong.");
  sendTweet();
}

void sendTweet() {
  //send the tweet
  //this only works after closing the channel, but I don't know why
  println(tweet);
}