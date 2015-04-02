#include <Servo.h>

#include <SPI.h>

#include <ble_assert.h>
#include <boards.h>

#include <RBL_nRF8001.h>
#include <RBL_services.h>

#include <ble_shield.h>
#include <ble_shield_services.h>



#define STEP_PIN    28
#define STEP_PIN_2  31
#define STEP_PIN_3  30
#define STEP_OBCHANGE 29

#define EN_1    24
#define EN_2    33
#define EN_3    34

#define DIR_PIN    35
#define DIR_PIN_2  26
#define DIR_PIN_3  32 

#define xLimit  44
#define yLimit  38
#define zLimit  40
#define LED_1   46
#define LED_2   47
#define MICRO_STEP_PIN  41

#define STEP_DURATION 500

Servo myservo;

void setup() {
  pinMode(STEP_PIN, OUTPUT);
  pinMode(STEP_PIN_2, OUTPUT);
  pinMode(STEP_PIN_3, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(STEP_OBCHANGE, OUTPUT);
  pinMode(DIR_PIN_2, OUTPUT);
  pinMode(DIR_PIN_3, OUTPUT);

  pinMode(EN_1, OUTPUT);
  pinMode(EN_2, OUTPUT);
  pinMode(EN_3, OUTPUT);
  pinMode(zLimit, INPUT);
  pinMode(xLimit, INPUT);
  pinMode(yLimit, INPUT);
  pinMode(LED_1, OUTPUT);
  pinMode(LED_2, OUTPUT);

  pinMode(MICRO_STEP_PIN, OUTPUT);
  digitalWrite(STEP_PIN, HIGH); 
  digitalWrite(STEP_PIN_2, HIGH);   
  digitalWrite(STEP_PIN_3, HIGH);   
  digitalWrite(DIR_PIN, HIGH); 
  digitalWrite(STEP_OBCHANGE, HIGH);   
  digitalWrite(DIR_PIN_2, HIGH);   
  digitalWrite(DIR_PIN_3, HIGH);     
  
  digitalWrite(EN_1, HIGH);   
  digitalWrite(EN_2, HIGH);   
  digitalWrite(EN_3, HIGH);
  digitalWrite(MICRO_STEP_PIN, LOW);  
  digitalWrite(LED_1, HIGH);   
  digitalWrite(LED_2, HIGH);   
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();

  ble_begin();
}

void loop() {
  static boolean analog_enabled = false;
  static byte old_state = LOW;
  
  // If data is ready
  while(ble_available()) {
    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
    switch (data0) {
      case 0x02: // step
        stepMotor(STEP_PIN, data1);
        stepMotor(STEP_PIN_2, data2);
        break;
      case 0x03: // set dir high
        digitalWrite(DIR_PIN, HIGH);
        break;
      case 0x13: // set dir low
        digitalWrite(DIR_PIN, LOW);
        break;
      case 0x04: // set EN1 to high
        digitalWrite(EN_1, HIGH);
        break;
      case 0x14: // set EN1 to low
        digitalWrite(EN_1, LOW);
        break;
      case 0x05: // set EN2 to HIGH
        digitalWrite(EN_2, HIGH);
        break;
      case 0x15: // set EN2 to low
        digitalWrite(EN_2, LOW);
        break;
      case 0x06: // set EN3 to HIGH
        digitalWrite(EN_3, HIGH);
        break;
      case 0x16: // set EN3 to low
        digitalWrite(EN_3, LOW);
        break;
      case 0x07: // set obchange dir to HIGH
        digitalWrite(DIR_PIN_2, HIGH);
        break;
      case 0x17: // set obchange dir to low
        digitalWrite(DIR_PIN_2, LOW);
        break;
      case 0x18: // step motor 1
        stepMotor(STEP_PIN, data1);
        break;
      case 0x19: // step motor 2
        stepMotor(STEP_PIN_2, data1);
        break;
      case 0x20: // step motor 3
        stepMotor(STEP_PIN_3, data1);
        break;
      case 0x21: // set to half step
        digitalWrite(MICRO_STEP_PIN, LOW);
        break;
      case 0x22: // set to full step
        digitalWrite(MICRO_STEP_PIN, HIGH);
        break;
      case 0x23:
        alignXY();
        break;
      case 0x24:
        alignZ();
        break;
      case 0x08: // set dir3 high
        digitalWrite(DIR_PIN_3, HIGH);
        break;
      case 0x09: // set dir3 low
        digitalWrite(DIR_PIN_3, LOW);
        break;
      case 0x25: // LED1 off
        digitalWrite(LED_1,LOW);
        break;
      case 0x26: // LED1 on
        digitalWrite(LED_1,HIGH);
        break;
      case 0x27: // LED2 off
        digitalWrite(LED_2,LOW);
        break;
      case 0x28: // LED2 on
        digitalWrite(LED_2,HIGH);
        break;
    }
    ble_write(data0);
    ble_write(data1);
  }
  if (!ble_connected()){}
  // Allow BLE Shield to send/receive data
  ble_do_events();  
}

void stepMotor(int motor, byte steps) {
  int i = 0;
  while (i < steps) {
    digitalWrite(motor, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(motor, LOW);
    delayMicroseconds(STEP_DURATION);
    i++;
  }
}

void alignXY() {
  //move x to limit
  digitalWrite(DIR_PIN_2, HIGH);
  while (digitalRead(xLimit)==HIGH) {
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(STEP_DURATION);
  }
  //move x away from limit
  digitalWrite(DIR_PIN_2, LOW);
  while (digitalRead(xLimit)==LOW) {
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(STEP_DURATION);
  }  
  //move y to limit
  digitalWrite(DIR_PIN, LOW);
  while (digitalRead(yLimit)==HIGH) {
    digitalWrite(STEP_PIN_2, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(STEP_PIN_2, LOW);
    delayMicroseconds(STEP_DURATION);
  }  
  //move y away from limit
  digitalWrite(DIR_PIN, HIGH);
  while (digitalRead(yLimit)==LOW){
    digitalWrite(STEP_PIN_2, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(STEP_PIN_2, LOW);
    delayMicroseconds(STEP_DURATION);
  }
}

void alignZ() {
  //move z to limit
  digitalWrite(DIR_PIN_3, LOW);
  while (digitalRead(zLimit)==HIGH){
    digitalWrite(STEP_PIN_3, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(STEP_PIN_3, LOW);
    delayMicroseconds(STEP_DURATION);
  }  
  //move z away from limit
  digitalWrite(DIR_PIN_3,HIGH);
  while (digitalRead(zLimit)==LOW){
    digitalWrite(STEP_PIN_3, HIGH);
    delayMicroseconds(STEP_DURATION);
    digitalWrite(STEP_PIN_3, LOW);
    delayMicroseconds(STEP_DURATION);
  }
}
