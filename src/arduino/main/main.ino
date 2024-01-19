#define INPUT_SIZE 120

#define DIR_LIFT 2
#define STEP_LIFT 3
#define ENABLE_LIFT 4


#define DIR_ROTOR 8
#define STEP_ROTOR 9
#define ENABLE_ROTOR 10

#define MIX_PIN 6

void setup() {
  pinMode(STEP_LIFT, OUTPUT);
  pinMode(ENABLE_LIFT, OUTPUT);
  pinMode(DIR_LIFT, OUTPUT);

  pinMode(STEP_ROTOR, OUTPUT);
  pinMode(ENABLE_ROTOR, OUTPUT);
  pinMode(DIR_ROTOR, OUTPUT);

  digitalWrite(ENABLE_LIFT, HIGH);
  digitalWrite(ENABLE_ROTOR, HIGH);

  Serial.begin(9600);
}

void loop() {
  while (Serial.available() == 0) {}

  char input[INPUT_SIZE + 1];
  byte size = Serial.readBytes(input, INPUT_SIZE);
  input[size] = 0;

  if (strstr(input, "ready?") != 0) {
    Serial.println("ready to recieve;");
    return;
  }

  const char outer_delimiters[] = "&";
  const char inner_delimiters[] = ":";

  char* token;
  char* outer_saveptr = NULL;
  char* inner_saveptr = NULL;

  token = strtok_r(input, outer_delimiters, &outer_saveptr);

  if (outer_saveptr == NULL) {
    int motorId = atoi(strtok_r(token, inner_delimiters, &inner_saveptr));
    if (inner_saveptr == NULL) return;
    
    int motorDir = atoi(strtok_r(NULL, inner_delimiters, &inner_saveptr));
    int steps = atoi(strtok_r(NULL, inner_delimiters, &inner_saveptr));
 
    if (steps == 0) return;

    Serial.println("command recieved;");
    driveMotor(motorId, motorDir, steps);
    Serial.println("continue;");
    return;
  }

  Serial.println("command recieved;");

  while (token != NULL) {
    int motorId = atoi(strtok_r(token, inner_delimiters, &inner_saveptr));
    int motorDir = atoi(strtok_r(NULL, inner_delimiters, &inner_saveptr));
    int steps = atoi(strtok_r(NULL, inner_delimiters, &inner_saveptr));
 
    driveMotor(motorId, motorDir, steps);

    token = strtok_r(NULL, outer_delimiters, &outer_saveptr);
  }

  Serial.println("continue;");
}

void driveMotor(int motorId, int motorDir, int steps) {
  int enablePin, stepPin, dirPin;

  if (motorId == 2) {

    digitalWrite(MIX_PIN, HIGH);
    delay(1000);
    digitalWrite(MIX_PIN, LOW);

    return;
  }

  if (motorId == 1) {
    enablePin = ENABLE_LIFT;
    stepPin = STEP_LIFT;
    dirPin = DIR_LIFT;
  } else {
    enablePin = ENABLE_ROTOR;
    stepPin = STEP_ROTOR;
    dirPin = DIR_ROTOR;
  }

  if (motorDir == 1) {
    digitalWrite(dirPin, HIGH);
  } else {
    digitalWrite(dirPin, LOW);
  }

  digitalWrite(enablePin, LOW);

  for (int i = 0; i <= steps; i++) {
    digitalWrite(stepPin, HIGH);
    delay(1);
    digitalWrite(stepPin, LOW);
    delay(1);
  }

  digitalWrite(enablePin, HIGH);
}