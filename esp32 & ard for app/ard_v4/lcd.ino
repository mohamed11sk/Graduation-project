void lcd1(){
  lcd.setCursor(0, 0);
  lcd.print("Gas Level:");
  lcd.setCursor(0, 1);
  lcd.print("Status: SAFE");
}
void lcd2(){
  lcd.setCursor(10, 0);
  lcd.print(gasLevel);
  lcd.print("   ");
  lcd.setCursor(8, 1);
  lcd.print("ALERT ");
}
void lcd3(){
  lcd.setCursor(10, 0);
  lcd.print(gasLevel);
  lcd.print("   ");
  lcd.setCursor(8, 1);
  lcd.print("SAFE  ");
}