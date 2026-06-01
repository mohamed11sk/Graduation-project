#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include "Servo.h"

#define ledgrn 2
#define ledred 3
#define buz A3
#define sensorgas A2

int gasLevel;
unsigned long previousMillis = 0;  // Store last time gas data was sent
unsigned long sendInterval = 3000;  // Send data every 3 seconds

Servo myServo;
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  Wire.begin(8);  // I2C address of Arduino (8)
  Serial.begin(115200);
  lcd.init();
  lcd.backlight();
  led();
  lcd1();
}

void loop() {
  unsigned long currentMillis = millis();  // Get current time

  // Check if it's time to read and send gas data
  if (currentMillis - previousMillis >= sendInterval) {
    previousMillis = currentMillis;  // Update last send time

    // Read the gas sensor value
    gasLevel = analogRead(sensorgas);

    // Send the gas value over I2C to the ESP32
    Wire.beginTransmission(8);  // Start I2C transmission to the ESP32
    Wire.write((gasLevel >> 8) & 0xFF);  // Send high byte
    Wire.write(gasLevel & 0xFF);  // Send low byte
    Wire.endTransmission();  // End I2C transmission

    // Debugging: Print the gas level
    Serial.print("Gas Level Sent: ");
    Serial.println(gasLevel);  // Make sure the value is in the range of 0-1023

    // Perform actions based on gas level
    if (gasLevel > 50) {
      lcd2();
      led_red();
      tone(buz, 1000);
      myServo.attach(4);
      myServo.write(160);
      delay(100);  // You can modify this delay for your needs
    } else {
      led_grn();
      lcd3();
      noTone(buz);
      myServo.attach(4);
      myServo.write(0);
      delay(100);
    }
  }
}