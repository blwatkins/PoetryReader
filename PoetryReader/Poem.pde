class Poem {
  String title;
  String author;
  String source;

  int numberOfLines;
  int currentLineNumber;

  int currentLineLength;
  int pastLineLength;

  String currentLine;
  int currentLinePosition;
  int currentLineWords;

  color col;

  Poem(String title, String author, String source) {
    this.title = title;
    this.author = author;
    this.source = source;
    currentLineNumber = 0;
    currentLineLength = 1;
    pastLineLength = 1;
    currentLinePosition = 0;
    currentLineWords = 0;
  }

  void reset() {
    currentLineNumber = 0;
    currentLineLength = 1;
    pastLineLength = 1;
    currentLine = "";
    currentLinePosition = 0;
    currentLineWords = 0;
    col = color(random(255), random(255), random(255));
    //col = color(random(255), 255, 255);
  }

  void setNumberOfLines(int numberOfLines) {
    this.numberOfLines = numberOfLines;
  }

  void setCurrentLineNumber(int currentLineNumber) {
    this.currentLineNumber = currentLineNumber;
  }

  void incrementCurrentLineNumber() {
    currentLineNumber++;
  }

  void setCurrentLineWords(int currentLineWords) {
    this.currentLineWords = currentLineWords;
  }

  void setCurrentLinePosition(int currentLinePosition) {
    this.currentLinePosition = currentLinePosition;
  }

  void incrementCurrentLinePosition() {
    currentLinePosition++;
  }

  void setCurrentLineLength(int currentLineLength) {
    pastLineLength = this.currentLineLength;
    this.currentLineLength = currentLineLength;
  }

  void setCurrentLine(String currentLine) {
    this.currentLine = currentLine;
    setCurrentLineLength(currentLine.length());
  }

  void setColor(color col) {
    this.col = col;
  }
  
  boolean endOfLine() {
   return currentLinePosition >= currentLineWords; 
  }

  boolean endOfPoem() {
    return currentLineNumber >= numberOfLines;
  }
}