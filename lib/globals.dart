library globals;

String token = "";
String email = "";

getHeader(){
  return {
    "authorization": 'Bearer $token'
  };
}

getHeaderContentType(){
  return {
    "authorization": 'Bearer $token',
    "content-type" : "application/json"
  };
}

getUrl(String url){
  return Uri.http("localhost:8081", url);
}