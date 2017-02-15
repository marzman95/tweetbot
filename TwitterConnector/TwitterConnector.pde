Connector TwitterConnector;
//Translator TweetTranslator;

void setup() {
  TwitterConnector = new Connector("GET");
  System.out.println(TwitterConnector.returnData());
  System.out.println(TwitterConnector.getSignature());
}