import processing.io.*;
int GPIO_TRIGGER = 18;
int GPIO_ECHO = 24;
float duration;


  float timeStart = 0;
 float timeStop = 0;
  float timeElapsed = 0;
  float distance = 0;

void setup() {
  textSize(32);
  GPIO.pinMode(GPIO_TRIGGER,GPIO.OUTPUT);
  GPIO.pinMode(GPIO_ECHO,GPIO.INPUT);
  thread("get_sensor");
  thread("digital_writing_loop");
  
  
}

void draw(){
  
  background(0);
  
  fill(255, 255, 255);
  
  ellipse(width/2, height/2, timeElapsed *10, timeElapsed *10);
 
//distance = int(duration * 0.034 / 2);
  
 
};

void digital_writing_loop() {
  while ( true ) {
  while(GPIO.digitalRead(GPIO_ECHO) == GPIO.LOW) {
    timeStart = millis();
   // println(timeStart);
  }
  
    while(GPIO.digitalRead(GPIO_ECHO) == GPIO.HIGH) {
    timeStop = millis();
   // println(timeStop);
  }
 timeElapsed= timeStop - timeStart;
println(timeElapsed);


  //distance = (timeElapsed  * 0.034)/2;
  //distance = round(distance);
  
 //println(distance);
    
  }
 
  
}

void get_sensor() {
  
  while ( true ) {
   GPIO.digitalWrite(GPIO_TRIGGER, GPIO.LOW);
 delay(5); 
  GPIO.digitalWrite(GPIO_TRIGGER, GPIO.HIGH);
  delay(5);
  GPIO.digitalWrite(GPIO_TRIGGER, GPIO.LOW);
   
  
  }
  
}
