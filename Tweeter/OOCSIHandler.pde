public class OOCSIHandler {
  
  String OOCSItweet;
  
  // Handler method for OOCSI events
  void handleOOCSI(OOCSIEvent event) {
    OOCSItweet = event.getString("tweet", "Default tweet. Something went wrong.");
    if (OOCSItweet.length() > maxTweetLength) {
      println("Error: The status is too long to be posted.");
    }
    println("[OOSCI-receiver] Received a Tweet to be sent!");
    postStatus(OOCSItweet);
  }
  
}