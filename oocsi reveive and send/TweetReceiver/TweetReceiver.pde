import nl.tue.id.oocsi.*;

// ******************************************************
// This example requires a running OOCSI server!
//
// How to do that? Check: Examples > Tools > LocalServer
//
// More information how to run an OOCSI server
// can be found here: https://iddi.github.io/oocsi/)
// ******************************************************

int fillColor = 255;
int position = 0;
String tweet = "Hey there";

void setup() {
  size(200, 200);
  noStroke();

  // connect to OOCSI server running on the same machine (localhost)
  // with "receiverName" to be my channel others can send data to
  // (for more information how to run an OOCSI server refer to: https://iddi.github.io/oocsi/)
  OOCSI oocsi = new OOCSI(this, "TweetReceiver", "oocsi.id.tue.nl");

  // subscribe to channel "testchannel"
  // either the channel name is used for looking for a handler method...
  oocsi.subscribe("tweetBot");
  // ... or the handler method name can be given explicitly
  // oocsi.subscribe("testchannel", "testchannel");
}

void tweetBot(OOCSIEvent event) {
  println(event.getString("tweet"));
  tweet = event.getString("tweet", "Default tweet. Something went wrong.");
}

String getTweet() {
  return tweet;
}