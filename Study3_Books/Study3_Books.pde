float circleCenterX;
float circleCenterY;
float circleDiameter;
int numberOfSpokes;
ArrayList<Word> words;

Ball ball;

String[] filenames = {"dickinson.xml", "teasdale.xml"};
ArrayList<XML> allPoemsXML;
ArrayList<Poem> allPoems;
ArrayList<String> terms;
ArrayList<String> rawTerms;
IntDict wordPositions;

int currentPoemNumber;
int ballStartIndex;
int ballEndIndex;
color ballStartColor;
color ballEndColor;

boolean start;

void setup() {
  //fullScreen();
  size(1300, 800);
  //colorMode(HSB, 255);
  background(255);
  circleCenterX = width / 2;
  circleCenterY = height / 2;
  circleDiameter = height - 200;
  words = new ArrayList<Word>();
  allPoemsXML = new ArrayList<XML>();
  allPoems = new ArrayList<Poem>();
  terms = new ArrayList<String>();
  rawTerms = new ArrayList<String>();
  wordPositions = new IntDict();
  getRawTerms();
  createTerms();
  sortTerms();
  createWords();
  createPoems();
  ball = new Ball(circleDiameter / 2, circleCenterX, circleCenterY);
  currentPoemNumber = 0;
  loadBall();
  start = false;
}

void draw() {
  stroke(0);
  noFill();
  ellipse(circleCenterX, circleCenterY, circleDiameter, circleDiameter);
  for (int i = 0; i < words.size(); i++) { 
   words.get(i).displayRange();
   words.get(i).displayText();
  }
  if (start) {
    readPoems();
  }
  displaySignature();
  displayPoemInfo();
}

void getRawTerms() {
  XML data;
  for (int i = 0; i < filenames.length; i++) {
    data = loadXML(filenames[i]);
    XML[] poems = data.getChildren("poem");
    for (int j = 0; j < poems.length; j++) {
      allPoemsXML.add(poems[j]);
      XML[] lines = poems[j].getChild("text").getChildren("line");
      for (int k = 0; k < lines.length; k++) {
        XML[] punctuation = lines[k].getChildren("p");
        for (int l = 0; l < punctuation.length; l++) {
          lines[k].removeChild(punctuation[l]);
        }
        String[] text = splitTokens(lines[k].getContent());
        for (int m = 0; m < text.length; m++) {
          rawTerms.add(text[m]);
        }
      }
    }
  }
}

void createTerms() {
  for (int i = 0; i < rawTerms.size(); i++) {
    rawTerms.set(i, rawTerms.get(i).toLowerCase());
  }

  boolean match = false;
  for (int i = 0; i < rawTerms.size(); i++) {
    match = false;
    for (int j = 0; j < terms.size(); j++) {
      if (terms.get(j).equals(rawTerms.get(i))) {
        match = true;
      }
    }
    if (!match) {
      terms.add(rawTerms.get(i));
    }
  }
}

void sortTerms() {
  String[] wordsToSort = new String[terms.size()];
  for (int i = 0; i < wordsToSort.length; i++) {
    wordsToSort[i] = terms.get(i);
  }
  String[] sortedWords = sort(wordsToSort);
  for (int i = 0; i < sortedWords.length; i++) {
    terms.set(i, sortedWords[i]);
  }
}

void createWords() {
  float theta = 0;
  float deltaTheta = TWO_PI / terms.size();
  float buffer = 0.01;

  for (int i = 0; i < terms.size(); i++) {
    words.add(new Word(terms.get(i), circleCenterX, circleCenterY, circleDiameter / 2, theta - (deltaTheta / 2) + buffer, theta + (deltaTheta / 2) - buffer));
    theta += deltaTheta;
    wordPositions.set(terms.get(i), i);
  }

  for (int i = 0; i < words.size(); i++) {
    if (i % 6 == 0) {
      words.get(i).setTextOffset(15);
    } else if (i % 6 == 1) {
      words.get(i).setTextOffset(30);
    } else if (i % 6 == 2) {
      words.get(i).setTextOffset(45);
    } else if (i % 6 == 3) {
      words.get(i).setTextOffset(60);
    } else if (i % 6 == 4) {
      words.get(i).setTextOffset(75);
    } else {
      words.get(i).setTextOffset(90);
    }
  }
}

void createPoems() {
  for (int i = 0; i < allPoemsXML.size(); i++) {
    XML poem = allPoemsXML.get(i);
    String title = "";
    String[] titleString = splitTokens(poem.getChild("title").getContent());
    for (int j = 0; j < titleString.length; j++) {
      title += titleString[j] + " ";
    }

    String author = "";
    String[] authorString = splitTokens(poem.getChild("author").getContent());
    for (int j = 0; j < authorString.length; j++) {
      author += authorString[j] + " ";
    }

    String source = "";
    String[] sourceString = splitTokens(poem.getChild("source").getContent());
    for (int j = 0; j < sourceString.length; j++) {
      source += sourceString[j] + " ";
    }

    XML[] lines = poem.getChild("text").getChildren("line");
    int numberOfLines = lines.length;

    color col = color(random(255), random(255), random(255));
    //color col = color(random(255), 255, 255);
    Poem p = new Poem(title, author, source);
    p.setNumberOfLines(numberOfLines);
    p.setColor(col);
    allPoems.add(p);
  }
}

void loadBall() {

  XML poem = allPoemsXML.get(currentPoemNumber);

  ballStartColor = allPoems.get(currentPoemNumber).col;
  if (currentPoemNumber == allPoems.size() - 1) {
    ballEndColor = allPoems.get(0).col;
  } else {
    ballEndColor = allPoems.get(currentPoemNumber + 1).col;
  }

  int currentLineNumber = allPoems.get(currentPoemNumber).currentLineNumber;
  int currentLinePosition = allPoems.get(currentPoemNumber).currentLinePosition;
  int numberOfLines = allPoems.get(currentPoemNumber).numberOfLines;

  XML[] lines = poem.getChild("text").getChildren("line");

  XML currentLineXML = lines[currentLineNumber];
  String currentLine = "";
  String[] currentLineString = splitTokens(currentLineXML.getContent());
  for (int j = 0; j < currentLineString.length; j++) {
    currentLine += currentLineString[j] + " ";
  }

  allPoems.get(currentPoemNumber).setCurrentLine(currentLine);
  allPoems.get(currentPoemNumber).setCurrentLineWords(currentLineString.length);
  int currentLineWords = allPoems.get(currentPoemNumber).currentLineWords;

  String currentWord = currentLineString[currentLinePosition].toLowerCase();
  ballStartIndex = wordPositions.get(currentWord);

  int nextLineNumber;
  int nextLinePosition;
  int nextPoemNumber;
  if (currentLinePosition < currentLineWords - 1) {
    nextPoemNumber = currentPoemNumber;
    nextLinePosition = currentLinePosition + 1;
    nextLineNumber = currentLineNumber;
  } else {
    nextLinePosition = 0;
    if (currentLineNumber < numberOfLines - 1) {
      nextPoemNumber = currentPoemNumber;
      nextLineNumber = currentLineNumber + 1;
    } else {
      nextLineNumber = 0;
      if (currentPoemNumber < allPoems.size() - 1) {
        nextPoemNumber = currentPoemNumber + 1;
      } else {
        nextPoemNumber = 0;
      }
    }
  }

  String nextWord = "";
  if (currentPoemNumber == nextPoemNumber) {
    if (currentLineNumber == nextLineNumber) {
      nextWord = currentLineString[nextLinePosition].toLowerCase();
    } else {
      XML nextLineXML = lines[nextLineNumber];
      String[] nextLineString = splitTokens(nextLineXML.getContent());

      nextWord = nextLineString[nextLinePosition].toLowerCase();
    }
  } else {
    XML nextPoem = allPoemsXML.get(nextPoemNumber);
    XML[] nextLines = nextPoem.getChild("text").getChildren("line");

    XML nextLineXML = nextLines[nextLineNumber];
    String[] nextLineString = splitTokens(nextLineXML.getContent());

    nextWord = nextLineString[nextLinePosition].toLowerCase();
  }
  ball.incrementRadius();
  ballStartIndex = wordPositions.get(currentWord);
  ballEndIndex = wordPositions.get(nextWord);
  ball.setAngles(words.get(ballStartIndex).getCurrentAngle(), words.get(ballEndIndex).getCurrentAngle()); 
  words.get(ballStartIndex).incrementAngle();
  //println(allPoems.get(currentPoemNumber).currentLine);
  //println("current line position: " + currentLinePosition);
  //println("current line number: " + currentLineNumber);
  //println("current poem number: " + currentPoemNumber);
  //println(currentWord);
  //println("next line position: " + nextLinePosition);
  //println("next line number: " + nextLineNumber);
  //println("next poem number: " + nextPoemNumber);
  //println(nextWord);
  //println(ballStartIndex);
  //println(ballEndIndex);
}

void readPoems() {
  displayCurrentLine();
  int currentLineNumber = allPoems.get(currentPoemNumber).currentLineNumber;
  int numberOfLines = allPoems.get(currentPoemNumber).numberOfLines;
  color currentFill = lerpColor(ballStartColor, ballEndColor, currentLineNumber / (float)numberOfLines);
  ball.setColor(currentFill);
  ball.display();
  ball.move();
  if (ball.endOfPath()) {
    allPoems.get(currentPoemNumber).incrementCurrentLinePosition();
    if (allPoems.get(currentPoemNumber).endOfLine()) {
      allPoems.get(currentPoemNumber).setCurrentLinePosition(0);
      allPoems.get(currentPoemNumber).incrementCurrentLineNumber();
      if (allPoems.get(currentPoemNumber).endOfPoem()) {
        allPoems.get(currentPoemNumber).reset();
        currentPoemNumber++;
        if (currentPoemNumber >= allPoems.size()) {
          currentPoemNumber = 0;
        }
      }
    }
    loadBall();
  }
}

void displayCurrentLine() {
  float pastLineLength = allPoems.get(currentPoemNumber).pastLineLength;
  float currentLineLength = allPoems.get(currentPoemNumber).currentLineLength;
  float boxLength = max(pastLineLength, currentLineLength);
  String currentLine = allPoems.get(currentPoemNumber).currentLine;
  fill(255);
  noStroke();
  rectMode(CENTER);
  rect(circleCenterX, circleCenterY, 8 * (boxLength + 2), 24);
  textAlign(CENTER, CENTER);
  fill(0);
  textSize(12);
  text(currentLine, circleCenterX, circleCenterY);
}

void displayPoemInfo() {
  pushMatrix();
  translate(150, 100);
  noStroke();
  fill(255);
  rectMode(CENTER);
  rect(0, 0, 300, 100);
  textAlign(CENTER, CENTER);
  fill(0);
  text(allPoems.get(currentPoemNumber).title, 0, -20);
  text(allPoems.get(currentPoemNumber).author, 0, 0);
  text(allPoems.get(currentPoemNumber).source, 0, 20);
  popMatrix();
}

void displaySignature() {
  fill(0);
  textSize(12);
  text("Brittni Watkins", width - 100, height - 12);
}

void keyPressed() {
  start = true;
}

void mouseReleased() {
  background(255);
}