import nl.tue.id.oocsi.*;
import nl.tue.id.oocsi.client.*;
import nl.tue.id.oocsi.client.behavior.*;
import nl.tue.id.oocsi.client.behavior.state.*;
import nl.tue.id.oocsi.client.data.*;
import nl.tue.id.oocsi.client.protocol.*;
import nl.tue.id.oocsi.client.services.*;
import nl.tue.id.oocsi.client.socket.*;

import twitter4j.*;
import twitter4j.api.*;
import twitter4j.auth.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.management.*;
import twitter4j.util.*;
import twitter4j.util.function.*;

ConfigurationBuilder cb; 
Query query; 
TwitterFactory factory;
Twitter twitter;
Status status;
String OOCSItweet;

void setup() {       
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("nFxSHrom3pNdvmx2TvLRFdzAh");   
  cb.setOAuthConsumerSecret("kt45RjkQbKUHF3WqB9WoPHBlx4LbInutPraLD5k9DqcV3IjQYo");   
  cb.setOAuthAccessToken("831786162872262658-MZmxeFo3si5f7BToGLcmIZmf6qH9TI2");   
  cb.setOAuthAccessTokenSecret("CweKTuNzimS3l5jAZdOp41kSWqpEcZkZAIxe4G7fsdCze");
  
  factory = new TwitterFactory(cb.build());
  twitter = factory.getInstance();
  
  OOCSI oocsi = new OOCSI(this, "TweetReceiver", "oocsi.id.tue.nl");
  oocsi.subscribe("tweetBot");
} 

void tweetBot(OOCSIEvent event) {
  OOCSItweet = event.getString("tweet", "Default tweet. Something went wrong.");
  postStatus(OOCSItweet);
}

void postStatus(String newStatus) {
  try {
  status = twitter.updateStatus(newStatus);
  } catch(Exception e) {
    println(e);
  }
}