import java.io.*;
import java.net.*;

public static class Connect {
  public static String getHTML(String urlToRead) throws Exception {
    StringBuilder result = new StringBuilder();
    URL url = new URL(urlToRead);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    String line;
    while ((line = rd.readLine()) != null) {
      result.append(line);
    }
    rd.close();
    return result.toString();
  }
}

void setup() {
  try {
    String context = Connect.getHTML("http://nu.nl");
    System.out.println(context);
  } catch (Exception e) {
    System.err.println(e);
  }
}