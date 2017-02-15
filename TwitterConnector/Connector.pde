import java.io.*;
import java.net.*;

public static class Connector {
  static String readThisURL;
  static String method;
  
  // Constructor for class
  Connector(String callMethod) {
    readThisURL = "http://nu.nl";
    method = callMethod;
  }
  
  // Get unixTime for Twitter signature
  private long getTime() {
    long unixTime = System.currentTimeMillis() / 1000L;
    return unixTime;
  }
  
  String requestSignature;
  
  String[][] oAuthData {
    {"oauth_consumer_key", "KEY"}, //the consumer key
    {"oauth_nonce", "KEY"}, //32-bytes data with base64 encoding
    {"oauth_signature", requestSignature}, //base64
    {"oauth_signature_method", "HMAC-SHA1"},
    {"oauth_timestamp", getTime()},
    {"oauth_token", "KEY"},
    {"oauth_version", "KEY"}
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