import java.io.*;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;

public class DmHandler extends Tweeter {
  // The value in milliseconds between DM-fetches.
  static final int BREAK = 60 * 1000;

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
  public ResponseList getDms() throws IllegalStateException {
    ResponseList dms;
    try {
      dms = twitter.getDirectMessages();
      //System.out.println("\n[twitter4j-dm] DM's fetched!");
      //System.out.println(dms);
      return dms;
    } 
    catch (Exception e) {
      throw new IllegalStateException("Empty DM's list: " + e);
    }
  }

  /**
   * Send a direct message.
   * @pre {@code twitter} true
   * @param user the user that receives the direct message
   * @param message the message contents
   */
  public void sendDM(String user, String message) {
    try {
      //System.out.println("Sending DM to: " + user);
      twitter.sendDirectMessage(user, message);
    } 
    catch (Exception e) {
      System.out.println("[DMHandler-exception]: " + e);
    }
  }

  /**
   * Creates helptext and send it.
   * @pre {@code twitter} true
   * @param String user
   */
  void sendHelp(String user) {
    String helpText = createHelpText();
    sendDM(user, helpText);
  }

  /**
   * Generates a helptext form the help-file
   * @exists helpText.tweeter
   */
  String createHelpText() {
    String content = null;
    File file = new File("C:\\Users\\s147433\\Documents\\tue\\Year 3\\Y3Q3\\DBSU10\\tweetbot\\Tweeter\\helpText.tweeter");
    FileReader fr = null;
    try {
      fr = new FileReader(file);
      char[] chars = new char[(int) file.length()];
      fr.read(chars);
      content = new String(chars);
      fr.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    } 
    finally {
      if (fr != null) {
        try {
          fr.close();
        } 
        catch (IOException e) {
          e.printStackTrace();
        }
      }
    }
    return content;
  }

  /**
   * Setup the "dmStreamListener", looping every BREAK-milliseconds.
   */
  public void dmStream() {
    try {
      while (true) {
        System.out.println(BREAK / 1000 + " sec: " + new Date() + " get dm's");
        lookHelp();
        Thread.sleep(BREAK);
      }
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }
  
  /**
   * Finds dms that have been send after the BREAK-milliseconds and
   * test whether those contains "help". If so, send help.
   */  
  public void lookHelp() {
    Date lt = new Date();
    lt.setTime(lt.getTime() - BREAK);
    System.out.println("[twitter4j-dm] After this time is checked: " + lt);
    ResponseList dmsList = getDms();
    Iterator<DirectMessage> dmIterator = dmsList.iterator();
    while (dmIterator.hasNext()) {
      DirectMessage dm = dmIterator.next();
      long dmTime = dm.getCreatedAt().getTime();
      if (dmTime > lt.getTime()) {
        String text = dm.getText().toLowerCase();
        String user = dm.getSenderScreenName();
        if (text.contains("help")) {
          sendHelp(user);
        }
      }
    }
  }
}