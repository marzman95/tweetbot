import nl.tue.id.oocsi.*;

OOCSI oocsi;

void setup() {
  oocsi = new OOCSI(this, "TweetSender", "oocsi.id.tue.nl");
  oocsi.channel("tweetBot").data("tweet", "The second OOCSI tweet! Yay!").send();
}