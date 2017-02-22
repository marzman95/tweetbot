Coder encoder = new Coder();

void setup() {
  String nonce = encoder.getNonce();
  System.out.println("Nonce: " + nonce);
  String bNonce = encoder.bEncode(nonce);
  System.out.println("bNonce: " + bNonce);
}