import processing.io.*;
int GPIO_TRIGGER = 18;
int GPIO_ECHO = 24;
float duration;


  float timeStart = 0;
 float timeStop = 0;
  float timeElapsed = 0;
  float distance = 0;
  float smoothedDist;
  float newDist;
  float easing = 0.05;
  
  //minim vars
  
  import ddf.minim.*;
import ddf.minim.ugens.*;

Minim       minim;
AudioOutput out;
Oscil       wave;


void setup() {
  size(640, 320);
  textSize(32);
  
    
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  //can change waveform 
    wave = new Oscil( 440, 0.5f, Waves.TRIANGLE);
  // patch the Oscil to the output
  wave.patch( out );
  
  GPIO.pinMode(GPIO_TRIGGER,GPIO.OUTPUT);
  GPIO.pinMode(GPIO_ECHO,GPIO.INPUT);
  thread("get_sensor");
  thread("digital_writing_loop");
  
  
}

void draw(){
  
  if(timeElapsed > 10) {
    timeElapsed = 10.0; 
  }
  
  smoothedDist += (timeElapsed - smoothedDist) * easing;
  newDist = 20 - smoothedDist;
  
 // println(timeElapsed);
  println(smoothedDist);
  
    float amp = map( smoothedDist * 10, 0, height, 1, 0 );
  wave.setAmplitude( amp );
  
  float freq = map( smoothedDist * 10, 0, width, 110, 880 );
  wave.setFrequency( freq );
  
  background(0);
  
  noFill();
  stroke(10, 200, 255);
  
    pushMatrix();
       rectMode(CENTER);
        translate(width/2, height/2);
        rect(0, 0, newDist *10, newDist * 10);
        // Rotation formula based on brightness
        rotate((2 * PI * newDist / 255.0));
        
         rect(0, 0, newDist * 10 , newDist * 10);
        // Rotation formula based on brightness
        rotate((2 * PI * newDist / 255.0));
         
         rect(0, 0, newDist * 10 , newDist * 10);
        // Rotation formula based on brightness
        rotate((2 * PI * newDist / 255.0));
     
      
        
        // Rects are larger than the cell for some overlap
       
        popMatrix();
  
 // ellipse(width/2, height/2, smoothedDist *10, smoothedDist *10);
 
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
//println(timeElapsed);


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
