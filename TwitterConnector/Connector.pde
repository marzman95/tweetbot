import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.Random;
import java.util.Base64;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.Mac;

public static class Connector {
  String requestURL = "http://mven.nl";
  String method;
  private String consumerKey = "nFxSHrom3pNdvmx2TvLRFdzAh";
  private String consumerSecret = "kt45RjkQbKUHF3WqB9WoPHBlx4LbInutPraLD5k9DqcV3IjQYo";
  private String accessToken = "831786162872262658-MZmxeFo3si5f7BToGLcmIZmf6qH9TI2";
  private String accessSecret = "CweKTuNzimS3l5jAZdOp41kSWqpEcZkZAIxe4G7fsdCze";
  public String tweet = "This is a tweet!";
  
  // Constructor for class
  Connector() {
    //readThisURL = "http://mven.nl";
    method = "GET";
  }
  
  // Get unixTime for Twitter signature
  private long getTime() {
    long unixTime = System.currentTimeMillis() / 1000L;
    return unixTime;
  }
  
  // Encoder for strings to Base64
  byte[] bEncodeString(String value) {
    byte[] result = Base64.getEncoder().encode(value.getBytes(StandardCharsets.UTF_8));
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
    return randomString.toString();
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
  String nonce = getNonce();
  String bEncodedNonce = new String(bEncodeString(nonce), StandardCharsets.UTF_8);
  String timeStamp = String.valueOf(getTime());
    
  // Encode data
  String eq = "=";
  String and = "&";
  String dq = String.valueOf('"');
  String pEncodedEntities = pEncodeString("include_entities") + eq + pEncodeString("true");
  String pEncodedConsKey = pEncodeString("oauth_consumer_key") + eq + pEncodeString(consumerKey);
  String pEncodedNonce = pEncodeString("oauth_nonce") + eq + pEncodeString(bEncodedNonce);
  String pEncodedSignMethod = pEncodeString("oauth_signature_method") + eq + pEncodeString("HMAC-SHA1");
  String pEncodedToken = pEncodeString("oauth_token") + eq + pEncodeString(accessToken);
  String pEncodedVersion = pEncodeString("oauth_version") + eq + pEncodeString("1.0");
  String pEncodedTweet = pEncodeString("status") + eq + pEncodeString(tweet);
  String pEncodedReqURL = pEncodeString(requestURL);
    
  private String getSignature() {
    // Request parameters
    String params = "";
    params = params + pEncodedEntities + and;
    params = params + pEncodedConsKey + and;
    params = params + pEncodedNonce + and;
    params = params + pEncodedSignMethod + and;
    params = params + pEncodedToken + and;
    params = params + pEncodedVersion + and;
    params = params + pEncodedTweet;
    String pEncodedParams = pEncodeString(params);
    
    // Create the request URL
    String signatureBase = method;
    signatureBase = signatureBase + and;
    signatureBase = signatureBase + pEncodedReqURL + and;
    signatureBase = signatureBase + pEncodedParams;
    
    // Generate the signing key
    String secret = pEncodeString(consumerSecret) + and + pEncodeString(accessSecret);
    
    // Generate the signature
    try{
    Mac m = Mac.getInstance("HmacSHA1");
    m.init(new SecretKeySpec(secret.getBytes(), "HmacSHA1"));
    m.update(signatureBase.getBytes());
    byte[] res = m.doFinal();
    String signature = new String(res, StandardCharsets.UTF_8);
    res = bEncodeString(signature);
    signature = String.valueOf(res);
    return signature;
    } catch (Exception e) {
      return "Error: " + e;
    }
  }
  
  private String[][] oAuthData = {
    {"oauth_consumer_key", consumerKey},
    {"oauth_nonce", bEncodedNonce},
    {"oauth_signature", getSignature()},
    {"oauth_signature_method", "HMAC-SHA1"},
    {"oauth_timestamp", timeStamp},
    {"oauth_token", accessToken},
    {"oauth_version", "1.0"}
  };
  
  String createOAuthHeaderString() {
    String result = "OAuth ";
    for(int k = 0; k < 7; k++) {
      result = result + pEncodeString(oAuthData[k][0]);
      result = result + eq;
      result = result + dq;
      result = result + pEncodeString(oAuthData[k][1]);
      result = result + dq;
      if (k < 6) {
        result = result + ", ";
      }
    }
    return result;
  }
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
      String result = getData(requestURL, method);
      return result;
    } catch (Exception e) {
      return "Error: " + e;
    }
  }
}