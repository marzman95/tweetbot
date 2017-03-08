import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.text.SimpleDateFormat;

import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;

import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

Twitter twitter;
TwitterFactory factory;
TwitterStreamFactory streamFactory;
Query query; 
Status status;
StatusListener listener;
String OOCSItweet;
int maxTweetLength = 140;
List<Deadline> deadlines;
SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, 'at' HH:mm");

public class Deadline {
    private final String item;
    private final Calendar time;
   
    public Deadline(String item, Calendar time) {
        this.item = item;
        this.time = time;
    }

    public String getItem() { return item; }
    public Calendar getCal() { return time; }
}

// Method to setup Twitter instance, stream listener, and OOCSI receiver
void setup() {       
  // Setup Twitter instance
  //twitter = TwitterFactory.getSingleton();
  //streamFactory = TwitterStreamFactory.getSingleton();
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setDebugEnabled(true)
  .setOAuthConsumerKey("CdgOhLWmfD6gO4MqwAsQYpvHu")
  .setOAuthConsumerSecret("LueXAWdgCWluDHq2I5hGlMOw4RwPpx0fsD8RehXuqtMxmyx3Ii")
  .setOAuthAccessToken("831786162872262658-5TdHdOM7tU7eFD3wwJIFUTc7d6tW97z")
  .setOAuthAccessTokenSecret("qreucGdtDLrFoPdzyxVDBaqXQXVgd2Cm11H8jaJJzRjv2");
  Configuration conf = cb.build();
  factory = new TwitterFactory(conf);
  streamFactory = new TwitterStreamFactory(conf);
  twitter = factory.getInstance();
  
  // Setup OOCSI receiver
  OOCSI oocsi = new OOCSI(this, "TweetReceiver", "oocsi.id.tue.nl");
  oocsi.subscribe("tweetBot");
  
  // Set deadlines
  deadlines = new ArrayList<Deadline>();
  setDeadlines();
  
  // Setup listener for streaming API (stub)
  listener = new StatusListener() {
    
    public void onStatus(Status status) {
        handleStatus(status);
    }
    public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {}
    public void onTrackLimitationNotice(int numberOfLimitedStatuses) {}
    public void onStallWarning(StallWarning stallWarning) {}
    public void onScrubGeo(long l1, long l2) {}
    public void onException(Exception ex) {
        ex.printStackTrace();
    }
  };
  setupStream();
  
} 

// Handler method for OOCSI events
void tweetBot(OOCSIEvent event) {
  OOCSItweet = event.getString("tweet", "Default tweet. Something went wrong.");
  if (OOCSItweet.length() > maxTweetLength) {
    println("Error: The status is too long to be posted.");
  }
  println("[OOSCI-receiver] Received a Tweet to be sent!");
  postStatus(OOCSItweet);
}

// Posting a status
void postStatus(String newStatus) {
  if(newStatus.length() > maxTweetLength) {
    println("Error: tweet was too long to send.");
  } else {
    try {
    status = twitter.updateStatus(newStatus);
    println("[Twitter4j-tweet] Status updated!");  
    } catch(Exception e) {
      println(e);
    }
  }
}

// Setup for streaming API
void setupStream() {
  TwitterStream twitterStream = streamFactory.getInstance();
  twitterStream.addListener(listener);
  twitterStream.filter("@Tweetbot_DBSU10");
}

// Method to handle our mentions (tweets to us)
void handleStatus(Status status) {
  println("[Twitter4j-stream] " + status.getUser().getName() + " : " + status.getText()); 
  
  String tweetText = status.getText().toLowerCase();
  if(tweetText.contains("deadline")) {
      Deadline nextDeadline = getNextDeadline();
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

// Methods to add a deadline, must be in chronological order!
void setDeadlines() {
  addDeadline("the mini-PDP", 2017, 1, 13, 8, 45);
  addDeadline("Challenge 1", 2017, 2, 10, 17, 0);
  addDeadline("Challenge 2", 2017, 3, 10, 17, 0);
}
void addDeadline(String item, int year, int month, int day, int hour, int minute) {
  Calendar cal = Calendar.getInstance();
  cal.set(year, month, day, hour, minute);
  Deadline dl = new Deadline(item, cal);
  deadlines.add(dl);
}

// Method to get the next deadline
Deadline getNextDeadline() {
  long currentTime = System.currentTimeMillis();
  System.out.println(currentTime);
  for(Deadline dl : deadlines) {
    if (dl.getCal().getTimeInMillis() < currentTime) {
      // This deadline has passed. Do nothing.
    } else {
      return dl;
    }
  }
  return new Deadline("-- there are no more deadlines! --", Calendar.getInstance());
}