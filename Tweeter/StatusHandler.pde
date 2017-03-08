public class StatusHandler {

  // Method to handle our mentions (tweets to us)
  void handleStatus(Status status) {
    println("[Twitter4j-stream] " + status.getUser().getName() + " : " + status.getText()); 
    
    String tweetText = status.getText().toLowerCase();
    if(tweetText.contains("deadline")) {
        Deadline nextDeadline = deadlineHandler.getNextDeadline();
        String requestReply = "@" + status.getUser().getScreenName() + 
            " The next deadline is for " 
            + nextDeadline.getItem() + ", on " 
            + dateFormat.format(nextDeadline.getCal().getTime()) + ".";
        postStatus(requestReply);
    }
    checkProduct("coffee", status);
    checkProduct("pizza", status);
  }
  
  // Method to check a tweet for a product order and handle it
  void checkProduct(String product, Status status) {
    String tweetText = status.getText().toLowerCase();
    if(tweetText.contains("i want " + product) || tweetText.contains("order " + product)) {
      // For assignment 2: order product here
      confirmOrder(product, status);
    }
  }
  
  // Method to confirm a placed order to a Twitter user
  void confirmOrder(String product, Status status) {
    String orderReply = "@" + status.getUser().getScreenName() + " Your " + product + " has been ordered!";
    postStatus(orderReply);
  }

}