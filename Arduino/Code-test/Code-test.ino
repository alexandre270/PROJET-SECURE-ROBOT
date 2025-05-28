// Définir les pins des moteurs
#define DIR1 2
#define PWM1 3
#define DIR2 4
#define PWM2 5
#define DIR3 6
#define PWM3 7
#define DIR4 8
#define PWM4 9

void setup() {
  Serial.begin(9600);
  
  pinMode(DIR1, OUTPUT);
  pinMode(PWM1, OUTPUT);
  pinMode(DIR2, OUTPUT);
  pinMode(PWM2, OUTPUT);
  pinMode(DIR3, OUTPUT);
  pinMode(PWM3, OUTPUT);
  pinMode(DIR4, OUTPUT);
  pinMode(PWM4, OUTPUT);
}

void loop() {
  if (Serial.available()) {
    char commande = Serial.read();
    
    if (commande == 'Z') {
      avancer();
    }   
    else if (commande == 'Q') {
      Tournergauche();
    }
    else if (commande == 'X') {
      arreterMoteurs();
    }
    else if (commande == 'D') {
      Tournerdroite();
    }
    else if (commande == 'S') {
      reculer(); 
    }
    else if (commande == 'A') {
      Tours();
    }
    else if (commande == 'W') {
      Recgauche();
    }
    else if (commande == 'C') {
      Recdroite();
}
}
}

void avancer() {
  digitalWrite(DIR1, HIGH); analogWrite(PWM1, 150);
  digitalWrite(DIR2, LOW);  analogWrite(PWM2, 150);
  digitalWrite(DIR3, HIGH); analogWrite(PWM3, 150);
  digitalWrite(DIR4, LOW);  analogWrite(PWM4, 150);
}

void Tournerdroite() {
  digitalWrite(DIR1, LOW); analogWrite(PWM1, 0);
  digitalWrite(DIR2, HIGH); analogWrite(PWM2, 0);
  digitalWrite(DIR3, HIGH); analogWrite(PWM3, 150);
  digitalWrite(DIR4, LOW); analogWrite(PWM4, 150);
}

void Tournergauche() {
  digitalWrite(DIR1, HIGH); analogWrite(PWM1, 150);
  digitalWrite(DIR2, LOW);  analogWrite(PWM2, 150);
  digitalWrite(DIR3, LOW);  analogWrite(PWM3, 0);
  digitalWrite(DIR4, HIGH); analogWrite(PWM4, 0);
}

void reculer() {
  digitalWrite(DIR1, LOW); analogWrite(PWM1, 150);
  digitalWrite(DIR2, HIGH); analogWrite(PWM2, 150);
  digitalWrite(DIR3, HIGH); analogWrite(PWM3, 0);
  digitalWrite(DIR4, LOW); analogWrite(PWM4, 0);
}

void arreterMoteurs() {
  digitalWrite(DIR1, LOW); analogWrite(PWM1, 0);
  digitalWrite(DIR2, LOW); analogWrite(PWM2, 0);
  digitalWrite(DIR3, LOW); analogWrite(PWM3, 0);
  digitalWrite(DIR4, LOW); analogWrite(PWM4, 0);
}

void Tours() {
  digitalWrite(DIR1, HIGH); analogWrite(PWM1, 150);
  digitalWrite(DIR2, HIGH); analogWrite(PWM2, 150);
  digitalWrite(DIR3, HIGH); analogWrite(PWM3, 150);
  digitalWrite(DIR4, LOW); analogWrite(PWM4, 0);
  
}

void Recgauche() {
  digitalWrite(DIR1, LOW); analogWrite(PWM1, 0);
  digitalWrite(DIR2, HIGH); analogWrite(PWM2, 150);
  digitalWrite(DIR3, LOW); analogWrite(PWM3, 0);
  digitalWrite(DIR4, HIGH); analogWrite(PWM4, 150);
}

void Recdroite() {
  digitalWrite(DIR1, HIGH);  analogWrite(PWM1, 0); 
  digitalWrite(DIR2, LOW); analogWrite(PWM2, 0); 
  digitalWrite(DIR3, HIGH);  analogWrite(PWM3, 0);   
  digitalWrite(DIR4, LOW); analogWrite(PWM4, 0);  
}
