package model;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.ProtocolException;
import java.net.URL;

import org.json.JSONArray;
import org.json.JSONObject;

public class GetLoginForms {

	String rest_url = "";
	String cobSession = "";
	String userSession = "";
	JSONObject result;

	public String getForm(String provider_id) {
		HttpURLConnection urlConnection = null;
		String response;
		JSONObject login_form = null;
		String cobrand_auth = "cobSession=" + cobSession;
		String user_auth = "userSession=" + userSession;

		try {
			String GET_PROVIDER_URL = "providers/";

			String complete_url = rest_url + GET_PROVIDER_URL + provider_id;
			URL url = new URL(complete_url);
			System.out.println(complete_url);
			urlConnection = (HttpURLConnection) url.openConnection();
			GetMethod gm = new GetMethod();
			gm.getMethod(urlConnection, cobrand_auth, user_auth);

			int statusCode = urlConnection.getResponseCode();
			if (statusCode == 200) {
				InputStream is = urlConnection.getInputStream();
				HttpHelper hh = new HttpHelper();
				response = hh.readResponse(is);

				JSONObject jsonObject = new JSONObject(response);
				result = new JSONObject();

				JSONArray provider = jsonObject.getJSONArray("provider");
				JSONObject ar = provider.getJSONObject(0);
				login_form = ar.getJSONObject("loginForm");
				System.out.println(login_form.toString());
				JSONArray row = login_form.getJSONArray("row");
				JSONArray jarray = new JSONArray();
				for (int i = 0; i < row.length(); i++) {
					JSONObject r = new JSONObject();
					String label = row.getJSONObject(i).getString("label");
					r.put("label", label);
					JSONArray arr = row.getJSONObject(i).getJSONArray("field");
					JSONObject ob1 = arr.getJSONObject(0);
					
					int id = ob1.getInt("id");
					String type = ob1.getString("type");
					r.put("id", id);
					r.put("type", type);
					
					JSONArray newArr = new JSONArray();
					if(ob1.has("option")){
						JSONArray option = ob1.getJSONArray("option");	
						for(int j=0;j<option.length();j++){
							String displayText = option.getJSONObject(j).getString("displayText");				
							JSONObject op = new JSONObject();
							op.put("displayText", displayText);
							newArr.put(op);
						}
						r.put("option", newArr);
					}
					

					jarray.put(r);

				}
				result.put("login", jarray);
				System.out.println(result.toString());
			}
		} catch (ProtocolException e1) {
			e1.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {

			if (urlConnection != null)
				urlConnection.disconnect();
		}
		return result.toString();
	}

}
