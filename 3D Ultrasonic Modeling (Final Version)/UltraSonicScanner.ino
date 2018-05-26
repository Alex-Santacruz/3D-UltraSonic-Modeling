#include <Servo.h>.
#define PI 3.1415926535897932384626433832795

// Servo and sensor pins
const int trigPin = 13;
const int echoPin = 11;
const int horizServoPin = 3;
const int vertServoPin = 5;

Servo horizServo;
Servo vertServo;

// Anglular Variables
int vertMinAngle = 90;
int horizMinAngle = 35;
int horizMaxAngle = 135;
int vertMaxAngle = 135;

float radius;
float deg2rad = PI / 180.0;
float scale = 1;
boolean isOn = true; // Used for stopping loop

void setup() {

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);

// Servo pin assignment
  horizServo.attach(horizServoPin);
  vertServo.attach(vertServoPin);
  horizServo.write(horizAngle);
  vertServo.write(vertAngle);

}

void loop() {

if(isOn){
  for(int j = vertMinAngle; j <= vertMaxAngle; j++){ // j is vertical angle
    vertServo.write(j);
    for(int i = horizMinAngle; i <= horizMaxAngle; i++){ // i is horizontal angle
      horizServo.write(i);
      delay(30);
      radius = pingSensor();
      float x = radius*sin(j*deg2rad)*cos(i*deg2rad)*scale;
      float z = -radius*sin(j*deg2rad)*sin(i*deg2rad)*scale;
      float y = radius*cos(j*deg2rad)*scale;
      Serial.println(String(x) + " " + String(y) + " " + String(z));
    }
    
    j++;
    vertServo.write(j);
    
    for(int i = horizMaxAngle; i >= horizMinAngle; i--){
      horizServo.write(i);
      delay(30);
      
      radius = pingSensor();
      float x = radius*sin(j*deg2rad)*cos(i*deg2rad)*scale;
      float z = -radius*sin(j*deg2rad)*sin(i*deg2rad)*scale;
      float y = radius*cos(j*deg2rad)*scale;
      Serial.println(String(x) + " " + String(y) + " " + String(z));
    }
   }
   isOn = false; // Falsifies if(isOn) statement, suspending point sweeper
   Serial.println("END END END"); // Serial readout to stop Processing once arduino completes full sweep
  }
}

// Retreive ultrasonic sensor depth (radius)
float pingSensor(){
  
  digitalWrite(trigPin,LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  long duration = pulseIn(echoPin,HIGH);
  float distance = duration*0.034/2;
  return distance;
}


