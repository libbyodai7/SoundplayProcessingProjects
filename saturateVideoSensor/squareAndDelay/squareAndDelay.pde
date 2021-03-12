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
Oscil myLFO;
Delay myDelay;
Gain gain;


void setup() {
  //size(640, 320);
  fullScreen();
  textSize(32);
  
    
  minim = new Minim(this);
  
  gain = new Gain(0.f);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  myDelay = new Delay( 0.4, 0.5, true, true );
  
  //can change waveform 
    wave = new Oscil( 100, 0.5f, Waves.SQUARE);
  // patch the Oscil to the output
  //wave.patch( out );
  
    Waveform square = Waves.square( 0.9 );
  // create an LFO to be used for an amplitude envelope
  myLFO = new Oscil( 10, 0.3, square );
  
    myLFO.offset.setLastValue( 0.3 );

  myLFO.patch( wave.amplitude );
  
  // and the Blip is patched through the delay into the output
  wave.patch( myDelay ).patch( out );
  
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
  newDist = 20 - (smoothedDist * 2);
  
 // println(timeElapsed);
  println(newDist);
  
  gain.setValue(-60 + (newDist *10));
   float amp = map( newDist * 100, 0, newDist * 100, newDist * 100, 0 );
  wave.setAmplitude( amp );
  
  //float freq = map( smoothedDist * 10, 0, width, 110, 880 );
  //wave.setFrequency( freq );
  
   myLFO.offset.setLastValue( newDist);
  
  float delayTime = map( smoothedDist * 2, 0, width, 0.0001, 0.5 );
  myDelay.setDelTime( delayTime );
  // set the feedback factor by the vertical location
  float feedbackFactor = map( smoothedDist * 10, 0, height, 0.99, 0.0 );
 myDelay.setDelAmp( feedbackFactor );
  
  
  
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
