class Ball {
  float initialRadius;
  float radius;
  float centerX;
  float centerY;
  float initialAngle;
  float finalAngle;
  float initialX;
  float initialY;
  float finalX;
  float finalY;
  float x;
  float y;
  float xSpeed;
  float ySpeed;
  float defaultSpeed;
  float radiusSpeed;
  
  color col;

  Ball(float initialAngle, float finalAngle, float radius, float centerX, float centerY) {
    this.initialAngle = initialAngle;
    this.finalAngle = finalAngle;
    this.radius = 5;
    this.centerX = centerX;
    this.centerY = centerY;
    defaultSpeed = 3;
    radiusSpeed = -0.5;
    initialRadius = radius;
    setBallPositions();
    setBallSpeed();
    col = color(0);
  }
  
  Ball(float radius, float centerX, float centerY) {
    this.radius = 5;
    this.centerX = centerX;
    this.centerY = centerY;
    defaultSpeed = 3;
    radiusSpeed = -0.5;
    initialRadius = radius;
  }

  void setAngles(float intialAngle, float finalAngle) {
    this.initialAngle = intialAngle;
    this.finalAngle = finalAngle;
    setBallPositions();
    setBallSpeed();
  }

  void setBallPositions() {
    initialX = cos(initialAngle) * radius;
    initialY = sin(initialAngle) * radius;
    x = initialX;
    y = initialY;
    finalX = cos(finalAngle) * radius;
    finalY = sin(finalAngle) * radius;
  }

  void setBallSpeed() {
    int numberOfFrames = 1;
    float xDist = abs(finalX - initialX);
    float yDist = abs(finalY - initialY);

    if (xDist > yDist && xDist > 0) {
      numberOfFrames = (int)(xDist / defaultSpeed);

      if (finalX > initialX) {
        xSpeed = defaultSpeed;
      } else if (finalX < initialX) {
        xSpeed = -defaultSpeed;
      }

      if (finalY > initialY) {
        ySpeed = yDist / numberOfFrames;
      } else if (finalY < initialY) {
        ySpeed = - (yDist / numberOfFrames);
      } else {
        ySpeed = 0;
      }
    } else if (xDist < yDist && yDist > 0) { 
      numberOfFrames = (int)(yDist / defaultSpeed);

      if (finalX > initialX) {
        xSpeed = xDist / numberOfFrames;
      } else if (finalX < initialX) {
        xSpeed = -(xDist / numberOfFrames);
      } else {
        xSpeed = 0;
      }

      if (finalY > initialY) { 
        ySpeed = defaultSpeed;
      } else {
        ySpeed = -defaultSpeed;
      }
    }
  }
  
  void setColor(color col) {
   this.col = col; 
  }

  void incrementRadius() {
    radius += radiusSpeed;
    if (radius < 5 || radius > initialRadius) {
      radiusSpeed *= -1;
    }
  }

  void display() {
    pushMatrix();
    translate(centerX, centerY);
    fill(col, 30);
    ellipse(x, y, 10, 10);
    popMatrix();
  }

  void move() {
    x += xSpeed;
    y += ySpeed;
  }

  boolean endOfPath() {
    boolean result = false;
    if (xSpeed >= 0) {
      if (ySpeed >= 0) {
        if (x > finalX && y > finalY) {
          result = true;
        }
      } else {
        if (x > finalX && y < finalY) {
          result = true;
        }
      }
    } else {
      if (ySpeed >= 0) {
        if (x < finalX && y > finalY) {
          result = true;
        }
      } else {
        if (x < finalX && y < finalY) {
          result = true;
        }
      }
    }
    return result;
  }
}