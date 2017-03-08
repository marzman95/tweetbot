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

TwitterFactory factory;
Twitter twitter;
TwitterStreamFactory streamFactory;
TwitterStream twitterStream;

StatusHandler statusHandler = new StatusHandler();
DeadlineHandler deadlineHandler = new DeadlineHandler();
OOCSIHandler oocsiHandler = new OOCSIHandler();

Query query; 
Status status;
StatusListener listener;
List<Deadline> deadlines;

int maxTweetLength = 140;
SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, 'at' HH:mm");

/*
* Sets up Twitter instance, stream listener, and OOCSI receiver.
* The listener can monitor streaming Twitter data. The OOCSI receiver
* monitors incoming OOCSI messages on the tweetBot channel.
*
*/
void setup() {       
  // Setup Twitter instance
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
  deadlineHandler.setDeadlines();
  
  // Setup listener for streaming API
  listener = new StatusListener() {
    
    public void onStatus(Status status) {
        statusHandler.handleStatus(status);
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

/* 
* Handles OOCSI events.
* Calls OOCSIHandler's method handleOOCSI.
*
* @param  event  The incoming OOCSI event to be handled.
* @modifies none
*/
void tweetBot(OOCSIEvent event) {
  oocsiHandler.handleOOCSI(event);
}

/* 
* Sets up streaming API with listener and filter.
* Filters for tweets containing @Tweetbot_DBSU10.
*
* @modifies  none
*/
void setupStream() {
  TwitterStream twitterStream = streamFactory.getInstance();
  twitterStream.addListener(listener);
  twitterStream.filter("@Tweetbot_DBSU10");
}

/*
* Posts a status to Twitter.
* Posts a new status on the Tweetbot_DBSU10 account. Tweets cannot
* exceed 140 characters.
* 
* @param  newStatus  The status to be posted, a string.
* @modifies none
*/
void postStatus(String newStatus) {
  if(newStatus.length() > maxTweetLength) {
    println("Error: tweet was too long to send.");
    // For Challenge 2: Also reply over OOCSI that this error occurred.
  } else {
    try {
    status = twitter.updateStatus(newStatus);
    println("[Twitter4j-tweet] Status updated!");  
    } catch(Exception e) {
      println(e);
    }
  }
}