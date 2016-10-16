package model;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

import org.json.JSONArray;
import org.json.JSONObject;

public class SearchProvider {
	
	String rest_url = "" ;
	String search_string ;
	String cobSession = "";
	String userSession = "";

	public String search(String search_string) {
		HttpURLConnection urlConnection = null;
		String response;
		JSONObject result = null;
		String query;
		String paramSearchString = "name";
		query = paramSearchString + "=" + search_string;
		query = query.replaceAll("\\s+", "%20");
		Scanner s = null;

		String cobrand_auth = "cobSession=" + cobSession;
		System.out.println(cobrand_auth);
		String user_auth = "userSession=" + userSession;
		System.out.println(user_auth);
		try {
			String GET_PROVIDER_URL = "providers";
			String complete_url = rest_url + GET_PROVIDER_URL + "?" + query+"&skip=1000&top=500";
			URL url = new URL(complete_url);
			System.out.println(complete_url);
			
			urlConnection = (HttpURLConnection) url.openConnection();
			GetMethod gm = new GetMethod();
			gm.getMethod(urlConnection, cobrand_auth, user_auth);

			int statusCode = urlConnection.getResponseCode();
			System.out.println(statusCode);
			if (statusCode == 200) {

				InputStream is = urlConnection.getInputStream();
				HttpHelper hh = new HttpHelper();
				response = hh.readResponse(is);
				JSONObject jsonObject = new JSONObject(response);
				result = new JSONObject();
				JSONArray jarray = new JSONArray();
				if (jsonObject.has("provider")) {
					JSONArray provider = jsonObject.getJSONArray("provider");
                    for (int i = 0; i < provider.length(); i++) {
                        JSONObject ob = provider.getJSONObject(i);
                        JSONObject p = new JSONObject();
                        int id = ob.getInt("id");
                        String provider_name = ob.getString("name");
                        String base_url = ob.getString("baseUrl");
                        p.put("id",id);
                        p.put("name", provider_name);
                        p.put("baseUrl", base_url);
                        jarray.put(p);                
                    }
                    result.put("provider", jarray);
                    System.out.println(result.toString());
				}

			} else {
				InputStream errorStream = urlConnection.getErrorStream();
				s = new Scanner(errorStream).useDelimiter("\\A");
				String error = s.hasNext() ? s.next() : "";
				s.close();
				result = new JSONObject(error);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			if (urlConnection != null)
				urlConnection.disconnect();
		}
		return result.toString();
	}
}
