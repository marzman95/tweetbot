import java.io.*;
import java.net.*;
import java.util.Random;
import java.util.Base64;

public static class Connector {
  public static String readThisURL = "http://mven.nl";
  public static String method;
  public static String consumerKey = "nFxSHrom3pNdvmx2TvLRFdzAh";
  public static String consumerSecret = "kt45RjkQbKUHF3WqB9WoPHBlx4LbInutPraLD5k9DqcV3IjQYo";
  public static String accessToken = "831786162872262658-MZmxeFo3si5f7BToGLcmIZmf6qH9TI2";
  public static String accessSecret = "CweKTuNzimS3l5jAZdOp41kSWqpEcZkZAIxe4G7fsdCze";
  public static String tweet = "This is a tweet!";
  
  // Constructor for class
  Connector(String callMethod) {
    //readThisURL = "http://mven.nl";
    method = callMethod;
  }
  
  // Get unixTime for Twitter signature
  private long getTime() {
    long unixTime = System.currentTimeMillis() / 1000L;
    return unixTime;
  }
  
  // Encoder for strings to Base64
  byte[] bEncodeString(String value) {
    byte[] result = Base64.getEncoder().encode(value.getBytes());
    return result;
  }
  
  // Create random String
  private String getNonce() {
    final String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    StringBuilder randomString = new StringBuilder();
    Random rand = new Random();
    for (int l = 0; l < 32; l++) {
      int n = rand.nextInt(AB.length());
      randomString.append(AB.charAt(n));
    }
    return bEncodeString(randomString.toString()).toString();
  }
  
  // Percent encoder for strings
  String pEncodeString(String value) {
    try {
      String result = URLEncoder.encode(value, "UTF-8");
      return result;
    } catch (UnsupportedEncodingException e) {
      return "error";
    }
  }
  
  // Create the parameter data
  String bEncodedNonce = getNonce();
  String timeStamp = String.valueOf(getTime());
    
  // Encode data
  String eq = "=";
  String and = "&";
  String pEncodedTweet = pEncodeString("status") + eq + pEncodeString(tweet);
  String pEncodedEntities = pEncodeString("include_entities") + eq + pEncodeString("true");
  String pEncodedConsKey = pEncodeString("oauth_consumer_key") + eq + pEncodeString(consumerKey);
  String pEncodedNonce = pEncodeString("oauth_nonce") + eq + pEncodeString(bEncodedNonce);
  String pEncodedSignMethod = pEncodeString("oauth_signature_method") + eq + pEncodeString("HMAC-SHA1");
  String pEncodedToken = pEncodeString("oauth_token") + eq + pEncodeString(accessToken);
  String pEncodedVersion = pEncodeString("oauth_version") + eq + pEncodeString("1.0");
    
  String getSignature() {
    String signature = "";
    signature = signature + this.pEncodedTweet + this.and;
    signature = signature + this.pEncodedEntities + this.and;
    signature = signature + this.pEncodedConsKey + this.and;
    signature = signature + this.pEncodedNonce + this.and;
    signature = signature + this.pEncodedSignMethod + this.and;
    signature = signature + this.pEncodedToken + this.and;
    signature = signature + this.pEncodedVersion;
    return signature;
  }
  
  String[][] oAuthData = {
    {"oauth_consumer_key", consumerKey},
    {"oauth_nonce", bEncodedNonce},
    {"oauth_signature", getSignature()},
    {"oauth_signature_method", "HMAC-SHA1"},
    {"oauth_timestamp", timeStamp},
    {"oauth_token", accessToken},
    {"oauth_version", "1.0"}
  };
  
  // Get data
  private static String getData(String urlToRead, String method) throws Exception {
    StringBuilder result = new StringBuilder();
    URL url = new URL(urlToRead);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod(method);
    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    String line;
    while ((line = rd.readLine()) != null) {
      result.append(line);
    }
    rd.close();
    return result.toString();
  }
  
  public String returnData() {
    try {
      String result = getData(readThisURL, method);
      return result;
    } catch (Exception e) {
      return "Error: " + e;
    }
  }
}