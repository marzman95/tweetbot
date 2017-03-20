/**
* This class contains the OOCSI handler method.
* It handles incoming OOCSI events. In the future, it will
* be expanded to allow more OOCSI communication.
*
* @author  Marcin van de Ven
* @author  Dianne Vasseur
* @author  Manon Blankendaal
* @author  Anne Kok
*/
public class OOCSIHandler {
  
  String OOCSItweet;
  
  /**
  * Handles OOCSI events.
  *
  * @param  event The OOCSI event to be handled. Should be
  *  at most {@code maxTweetLength} characters.
  */
  public void handleOOCSI(OOCSIEvent event) {
    
    OOCSItweet = event.getString("tweet", "Default tweet. Something went wrong.");
    if (OOCSItweet.length() > maxTweetLength) {
      println("Error: The status is too long to be posted.");
    }
    println("[OOCSIHandler] Received a Tweet to be sent!");
    postStatus(OOCSItweet);
    
  }
  
}