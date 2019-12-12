#include "FirebaseESP8266.h"
#include <ESP8266WiFi.h>

#define FIREBASE_HOST "sd-498-ff.firebaseio.com"
#define FIREBASE_AUTH "EMErfXHl2cKQGEwF1zHVedBQzyGwbau7a5g7uLIH"
#define WIFI_SSID "Sibly System"
#define WIFI_PASSWORD "Jabala7391"

// Define FirebaseESP8266 data object
FirebaseData firebaseData;
String path = "/petA";
String house = "Inside"; 

int sensor = 13;  // Digital pin D7
void setup() {
  Serial.begin(115200);
  pinMode(sensor, INPUT);   // declare sensor as input
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while(WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
}

void loop() {
  while(!Serial);
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

  //Set database Read timeout to 1 minute (max 15 minutes)
  Firebase.setReadTimeout(firebaseData, 1000 * 60);
  //tiny, small, medium, large, and unlimited
  //Size and its write timeout e.g. tiny(1s), small(10s), medium (30s), large (60s).
  Firebase.setwriteSizeLimit(firebaseData, "tiny");

  
  FirebaseJson json;

  Firebase.getString(firebaseData, path + "/house", house);
  Serial.print("Where is the pet? : ");
  Serial.println(house); 
  long state = digitalRead(sensor);
  if(state == HIGH) {
    if(house == "Outside"){
    Firebase.setString(firebaseData, path + "/house", "Inside");
    }
    else {
      Firebase.setString(firebaseData, path + "/house", "Outside");
    }
    Serial.println("Motion detected!");
    delay(10000);
  }
  else {
    Serial.println("Motion absent!");
    delay(1000);
  }
}
