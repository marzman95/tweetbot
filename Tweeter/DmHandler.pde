import java.io.*;

public class DmHandler extends Tweeter {
  
  /**
   * This class needs an instance of Twitter to work.
   * @pre instance of Twitter
   */
  Twitter twitter;
  DmHandler(Twitter twitter) {
    this.twitter = twitter;
  }
  
  /**
   * Method to get the 20 most recent Direct Messages.
   * @pre {@code twitter} = true
   * @outputs ResponseList<DirectMessage>
   * @todo change to object
   *
   * Rate limit of 15 requests per 15 minutes
   */
  void getDMs() {
    try {
      ResponseList dms = twitter.getDirectMessages();
      println("[twitter4j-dm] DM's fetched!");
      println(dms);
    } catch (Exception e) {
      println(e);
    }
  }
  
  /**
   * Send a direct message.
   * @pre {@code twitter} true
   * @param user the user that receives the direct message
   * @param message the message contents
   */
   void sendDM(String user, String message) {
     //Get user
     //Send message
   }
  
  /**
   * Creates helptext and send it.
   * @pre {@code twitter} true
   * @param String user
   */
   void sendHelp(String user) {
     //Get user id
     //Generate helptext
     //Send the dm using sendDM(user, helptext);
   }
   
   /**
    * Generates a helptext form the help-file
    * @exists helpText.tweeter
    */
   void createHelpText() {
     Path filePath = Paths.getFile("helperText.tweeter");
     Scanner scanner = new Scanner(filePath);
   }
}