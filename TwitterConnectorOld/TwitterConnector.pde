Connector TwitterConnector;
//Translator TweetTranslator;

void setup() {
  TwitterConnector = new Connector();
  System.out.println("Timestamp: " + TwitterConnector.timeStamp);
  System.out.println("Nonce: " + TwitterConnector.getNonce());
  System.out.println("ByteNonce: " + TwitterConnector.bEncodedNonce);
  System.out.println(TwitterConnector.createOAuthHeaderString());
}