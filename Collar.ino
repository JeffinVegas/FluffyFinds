#include "Adafruit_FONA.h"
#include <SoftwareSerial.h>
#include <stdlib.h>
SoftwareSerial GPRSs(3,2);
SoftwareSerial *fonaGPRS = &GPRSs;

// Values to print GSM buffer
unsigned char buffer[200];
int returns = 0;
int count=0;

// Values for GPS location
float latitude, longitude;
double lats, longs;
const char colon[2] = ":";
const char comma[2] = ",";
char *token;
uint16_t vbat;
#define FONA_RST 4
Adafruit_FONA_3G fona = Adafruit_FONA_3G(FONA_RST);

void setup() {
  while (!Serial);
  Serial.begin(115200);

  fonaGPRS->begin(4800);
  if (! fona.begin(*fonaGPRS)) {
    Serial.println(F("Couldn't find FONA"));
    while (1);
  }
  Serial.println(F("FONA is OK"));
}

// Printing the GSM buffer
void  printFONA() {
  while(fonaGPRS->available())
  {
    buffer[count++]=fonaGPRS->read(); // writing data into array
    if(count == 200) break;
  }
  Serial.write(buffer,count);
  returns = buffer[1];
  clearBufferArray();
  count = 0;
  delay(1000);
}

void loop() {
    
//  if (! fona.getBattPercent(&vbat)) {
//    Serial.println(F("Failed to read Batt"));
//  } else {
//    Serial.print(F("VPct = ")); Serial.print(vbat); Serial.println(F("%"));
//  }
//  delay(2000);

  while(GPRSs.available()){
    GPRSs.read();
  }
  GPRSs.println("AT+CBC\r\n)"); // Enable/ Turn on GPS
  delay(2000);
  printBatFONA();
  
  // ACQUIRING GPS LOCATION 
  GPRSs.println("AT+CGPS=1\r\n)"); // Enable/ Turn on GPS
  delay(2000);
  printFONA();
  GPRSs.println("AT+CGPS?\r\n)"); // Check if GPS is on
  delay(2000);
  printFONA();
  
  GPRSs.println("AT+CGPSINFO\r\n)");// Read GPS Information
  delay(15000);
  printGPSFONA();
  
  while (latitude == 0 || longitude == 0){ // If GPS hasn't acquired Location yet
    GPRSs.println("AT+CGPS=1\r\n)"); // Keep Reading GPS Information Again till acquired
    delay(2000);
    printFONA();
    GPRSs.println("AT+CGPSINFO\r\n)");
    delay(2000);
    printGPSFONA();
    delay(30000);
  }
  Serial.print("Latitude in loop Decimal: "); Serial.println(latitude,6);
  Serial.print("Longitude in loop Decimal: ");Serial.println(longitude,6);
  
  GPRSs.println("AT+CGPS=0\r\n)");
  delay(30000);
  printFONA();



  // Sending Data to Firebase's Real Time Database
  // Using Rest API commands.
  GPRSs.println("AT+CHTTPSSTOP\r\n)"); //Stop Connection to Server
  delay(2000);
  printFONA();
  
  GPRSs.println("AT+CHTTPSCLSE\r\n)"); //Close a session
  delay(15000);
  printFONA();
  
  GPRSs.println("AT+CGDCONT=1,\"IP\",\"fast.t-mobile.com\",\"1.1.1.1\"");
  delay(1000);
  printFONA();
  
  GPRSs.println("AT+CGSOCKCONT=1,\"IP\",\"fast.t-mobile.com\"");
  delay(1000);
  printFONA();
  
  GPRSs.println("AT+CSOCKSETPN=1");
  delay(1000);
  printFONA();
  
  GPRSs.println("AT+CHTTPSSTART\r\n");
  delay(15000);
  printFONA();
  
  GPRSs.println("AT+CHTTPSOPSE=\"sd-498-ff.firebaseio.com\",443");
  delay(15000);
//  while(!GPRSs.available()){
//    GPRSs.println("AT+CHTTPSOPSE=\"sd-498-ff.firebaseio.com\",443");
//  }
  printFONA();
  while(!GPRSs.available()){
    GPRSs.println("AT+CHTTPSSEND = 202");
    delay(3000);
  }
  
  printFONA();
  GPRSs.write("PATCH /petA.json HTTP/1.1\r\n");
  delay(2000);
  printFONA();
  
  GPRSs.write("Host: sd-498-ff.firebaseio.com:443\r\n");
  delay(2000);
  printFONA();
  
  GPRSs.write("Content-Type: application/json\r\n");
  delay(2000);
  printFONA();
  
  GPRSs.write("Content-Length: 81\r\n\r\n");
  delay(2000);
  printFONA();

  GPRSs.write("{\"battery\": ");
  char batChar[1];
  itoa(vbat,batChar, 10);
  GPRSs.write(batChar);
  GPRSs.write(",\"temperature\": ");
  char tempChar[3] = "79.9";
  GPRSs.write(tempChar);
  GPRSs.write(",\"latitude\": ");
  char latChar[8]; 
  dtostrf(latitude,9,6,latChar);   // Convert Float Latitude to String
  GPRSs.write(latChar,8); // Max character counter = 9
  GPRSs.write(",\"longitude\": ");
  char longChar[10]; 
  dtostrf(longitude,11,6,longChar); // Convert Float Longitude to String
  GPRSs.write(longChar, 10);// Max character counter = 11
  GPRSs.write("}\r\n\r\n");
  delay(5000);
  printFONA();
 
  GPRSs.println("AT+CHTTPSCLSE\r\n");
  delay(15000);
  printFONA();
 
  GPRSs.println("AT+CHTTPSSTOP\r\n)");
  delay(15000);
  printFONA();
   while(GPRSs.available()){
    Serial.write(GPRSs.read());
  }
  latitude = 0;
}

void printBatFONA() {
  while(fonaGPRS->available())
  {
    buffer[count++]=fonaGPRS->read(); // writing data into array
    if(count == 200) break;
  }
  token = strtok (buffer, colon);
  char *batPowered  = strtok(NULL,comma);
  char *batPercent = strtok(NULL,comma);
  vbat = atof(batPercent);
}
// Print the buffer/response from the GSM when reading GPS
void  printGPSFONA() {
  while(fonaGPRS->available())
  {
    buffer[count++]=fonaGPRS->read(); // writing data into array
    if(count == 200) break;
  }
  token = strtok (buffer, colon);
  
  //Serial.println(token);
  char *latPos = strtok(NULL,comma);
  char *latDir = strtok(NULL,comma);
  char *longPos = strtok(NULL,comma);
  char *longDir = strtok(NULL,comma);
  
  Serial.println("----------- Converting into Degrees ------------");
  lats = atof(latPos);
  longs = atof(longPos);
  
  // Converting Latitude from minutes to decimal
  float deg = floor(lats/100);
  double mins = lats - (100*deg);
  mins /= 60;
  deg += mins;
  
  if(latDir[0] == 'S')
  deg *= -1;
  
  latitude = deg;
  Serial.print("Latitude in Decimal: "); Serial.println(latitude,6);
  
  // Converting Longitude from minutes to decimal
  deg = floor(longs/100);
  mins = longs - (100 * deg);
  mins /= 60;
  deg += mins;
  
  if(longDir[0] == 'W')
  deg *= -1;

  longitude = deg;
  Serial.print("Longitude in Decimal: ");Serial.println(longitude,6);
      
  clearBufferArray();
  count = 0;
  delay(1000);
  while(GPRSs.available()){
    GPRSs.read();
  }
}

void clearBufferArray()
{
  for(int i=0; i<count; i++)
  {
    buffer[i]=NULL;
  }
}
