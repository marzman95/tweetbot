import java.io.*;
import java.net.*;
import java.util.Base64;
import java.util.Random;
import java.nio.charset.StandardCharsets;

class Coder {
  
  String getNonce() {
    final String AB = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    StringBuilder randomString = new StringBuilder();
    Random rand = new Random();
    for (int l = 0; l < 32; l++) {
      int n = rand.nextInt(AB.length());
      randomString.append(AB.charAt(n));
    }
    return randomString.toString();
  }
  
  String bEncode(String value) {
    byte[] bValue = value.getBytes(StandardCharsets.UTF_8);
    byte[] eValue = Base64.getEncoder().encode(bValue);
    String result = new String (eValue, StandardCharsets.UTF_8);
    return result;
  }
}