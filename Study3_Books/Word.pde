class Word {
  String term;
  float centerX;
  float centerY;
  float radius;
  float lowerAngleBound;
  float upperAngleBound;
  float currentAngle;
  float angleIncrement;
  float textOffset;

  color rangeColor;

  Word(String term, float centerX, float centerY, float radius, float lowerAngleBound, float upperAngleBound) {
    this.term = term;
    this.centerX = centerX;
    this.centerY = centerY;
    this.radius = radius;
    this.lowerAngleBound = lowerAngleBound;
    this.upperAngleBound = upperAngleBound;
    currentAngle = lowerAngleBound;
    angleIncrement = 0.05;
    textOffset = 10;
    rangeColor = color(random(255), random(255), random(255));
  }

  void setTextOffset(float textOffset) {
    this.textOffset = textOffset;
  }

  void setRangeColor(color rangeColor) {
    this.rangeColor = rangeColor;
  }

  float getCurrentAngle() {
    return currentAngle;
  }

  void incrementAngle() {
    currentAngle += angleIncrement;
    if (currentAngle > upperAngleBound) {
      currentAngle = lowerAngleBound;
    }
  }

  void displayRange() {
    pushMatrix();
    translate(centerX, centerY);
    float lowerBoundX = cos(lowerAngleBound) * radius;
    float lowerBoundY = sin(lowerAngleBound) * radius;
    float upperBoundX = cos(upperAngleBound) * radius;
    float upperBoundY = sin(upperAngleBound) * radius;
    fill(rangeColor);
    noStroke();
    ellipse(lowerBoundX, lowerBoundY, 8, 8);
    ellipse(upperBoundX, upperBoundY, 8, 8);
    popMatrix();
  }

  void displayText() {
    float centerAngle = lowerAngleBound + (upperAngleBound - lowerAngleBound) / 2;
    pushMatrix();
    translate(centerX, centerY);
    float x = cos(centerAngle) * radius;
    float y = sin(centerAngle) * radius;
    pushMatrix(); 
    fill(rangeColor);
    translate(x, y);
    rotate(centerAngle - HALF_PI + PI);
    textAlign(CENTER);
    textSize(15);
    text(term, 0, -textOffset);
    popMatrix();
    popMatrix();
  }
}