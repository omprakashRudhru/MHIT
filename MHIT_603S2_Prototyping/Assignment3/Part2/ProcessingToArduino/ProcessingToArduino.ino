/*MHIT603 S2 Assignment 3
Student: Omprakash - 87538553
This program will read the serial buffer and processes it to display LEDs. 

Processing program writes a decimal number from (0-7) to the buffer. 
Decimal number is processed and is converted to binary and LEDs are displayed accordingly. 

Ex: Processing output: 7
Arduino LEDs (Pin10:HIGH pin11:HIGH pin12:HIGH)

*/
int ledPin[] = {10,11,12};
//Our Serial Buffer
String serialBuffer = "";
//The Pin our LED is on
//int LEDPIN = 10;

//Function declaration
String getMostRecentValidSerialPacket();

void setup() {
  //Set up Serial Communications
  Serial.begin(9600);
  //Set up our LED pin to output
  for (int i =0;i<3;i++)
  {
    pinMode(ledPin[i], OUTPUT);
  }
  
}

void loop() {
  //Check to see if there's any data available on the Serial port
  while (Serial.available() >0) {
    //If so read the byte, convert it to a char, 
    //and add it to the buffer
    int sByte = Serial.read();
    serialBuffer += char(sByte);
  }

  //Get the most recent valid serial packet in the buffer
  String packet = getMostRecentValidSerialPacket();
  //If it's not an empty string
  if (packet.length()>0) {
    //Convert it to an int
    int value = packet.toInt();
    //converting from decimal to binary and writing it to the LED pins.
    for (int i =0;i<3;i++)
  {
    if (bitRead(value, i)==1)
    {
      digitalWrite(ledPin[i], HIGH); 
      
    }
    else
    {
      digitalWrite(ledPin[i], LOW); 
    }
    
  }
    //Set the brightness of the LED based on that pin
    //analogWrite(LEDPIN, value);
  }
}


//This function gets the most recent valid packet from the serial buffer
//You shouldn't have to modify this
String getMostRecentValidSerialPacket() {

  //If our serial buffer has any data in it
  if (serialBuffer.length()>0) {
       
    //If so, grab the index of the last starting and last ending delimiters
    int lastStartDelimiter = serialBuffer.lastIndexOf('<');
    int lastEndDelimiter = serialBuffer.lastIndexOf('>');

    //If we've found both delimiters and the ending one is after the starting
    if (lastEndDelimiter>-1 && lastStartDelimiter>-1 && 
        lastEndDelimiter > lastStartDelimiter) {
    
          //Get the  packet data
          String packetData = serialBuffer.substring(lastStartDelimiter+1, lastEndDelimiter);
      
          //Remove that packet from the serial buffer
          serialBuffer = serialBuffer.substring(lastEndDelimiter+1);
          
          //Return the packet
          return packetData;
          
    }
          
  }
  
  //If we haven't got any data, return an empty string
  return "";
}
