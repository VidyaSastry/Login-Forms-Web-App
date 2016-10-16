package model;

import java.net.HttpURLConnection;
import java.net.ProtocolException;

public class GetMethod {
    public HttpURLConnection getMethod(HttpURLConnection urlConnection, String cobrand_auth_token, String user_auth_token)
            throws ProtocolException {
        urlConnection.setRequestMethod("GET");
        urlConnection.setDoInput(true);
        urlConnection.setRequestProperty("Authorization", cobrand_auth_token + "," + user_auth_token);
        urlConnection.addRequestProperty("Accept-Charset", "UTF-8");
        return  urlConnection;
    }
}
