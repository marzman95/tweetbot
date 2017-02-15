import java.security.SecureRandom;

class Nonce {
  static final String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  
  public String makeNonce(int length) {
    static SecureRandom random = new SecureRandom();
    StringBuilder string = new StringBuilder(length);
    for(int i=0; i<length; i++) {
      string.append(chars.charAt(random.nextInt(chars.length())));
    }
    return string.toString();
  }

}