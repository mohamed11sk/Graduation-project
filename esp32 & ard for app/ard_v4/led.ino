void led(){  
  pinMode(ledgrn, OUTPUT);
  pinMode(ledred, OUTPUT);
  //pinMode(motor, OUTPUT);
  pinMode(sensorgas, INPUT);
}
void led_grn(){
  digitalWrite(ledgrn, HIGH);
  digitalWrite(ledred, LOW);
}
void led_red(){
  digitalWrite(ledgrn, LOW);
  digitalWrite(ledred, HIGH);
}
//void motor_off(){
//  digitalWrite(motor, LOW);
//}
//void motor_on(){
//  digitalWrite(motor, HIGH);
//}

