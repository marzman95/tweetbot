import nl.tue.id.oocsi.*;

/**
* This class is a test class for Tweetbot's OOCSI
* functionality. It sets up an OOCSI sender to the
* tweetBot channel and sends a Tweet to be posted.
*
* @author  Marcin van de Ven
* @author  Dianne Vasseur
* @author  Manon Blankendaal
* @author  Anne Kok
*/

OOCSI oocsi;

/**
* Sets up an OOCSI sender to the tweetBot channel
* and sends a Tweet to be posted.
*/
public void setup() {
  oocsi = new OOCSI(this, "TweetSender", "oocsi.id.tue.nl");
  oocsi.channel("tweetBot").data("tweet", "This is a tweet sent via OOCSI!").send();
}