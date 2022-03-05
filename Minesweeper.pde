import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();
private final static int NUM_MINES = NUM_ROWS*1;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  while (mines.size() < NUM_MINES) {
    setMines();
  }

  setMines();
}
public void setMines()
{
  int mR = (int)(Math.random()*NUM_ROWS);
  int mC = (int)(Math.random()*NUM_COLS);
  if (isValid(mR, mC)) {
    if (!mines.contains(buttons[mR][mC])) {
      mines.add(buttons[mR][mC]);
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  int clicked = 0;
  for (int r =0; r< NUM_ROWS; r++) {
    for (int c=0; c< NUM_COLS; c++) {
      if (buttons[r][c].clicked== false) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  int x = 0;
  String loseMessage = "YOU LOSE";
  for (int c = 5; c < 13; c++) {
    buttons[10][c].setLabel(loseMessage.substring(x, x+1));
    x++;
  }
}
public void displayWinningMessage()
{
  int x = 0;
  String winMessage = "YOU WIN";
  for (int c = 5; c < 12; c++) {
    buttons[10][c].setLabel(winMessage.substring(x, x+1));
    x++;
  }
}
public boolean isValid(int r, int c)
{
  if (r < NUM_ROWS && r >= 0) {
    if (c < NUM_COLS && c >= 0) {
      return true;
    }
  }
  return false;
}
public int countMines(int row, int col) {
  int numMines = 0;
  //your code here
  for (int i = -1; i < 2; i++) {
    for (int j=-1; j < 2; j++) {
      if ((i==0 && j==0) == false) {
        if (isValid(row+i, col+j) && mines.contains(buttons[row+i][col+j])) {
          numMines++;
        }
      }
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;

    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false) {
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(""+countMines(myRow, myCol));
    } else {
      for (int row=0; row<3; row++) {

        if (isValid(myRow-1+row, myCol+1) && buttons[myRow-1+row][myCol+1].clicked == false) {
          buttons[myRow-1+row][myCol+1].mousePressed();
        }

        if (isValid(myRow-1+row, myCol-1) && buttons[myRow-1+row][myCol-1].clicked == false) {
          buttons[myRow-1+row][myCol-1].mousePressed();
        }
      }

      if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false) {
        buttons[myRow-1][myCol].mousePressed();
      }
      if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false) {
        buttons[myRow+1][myCol].mousePressed();
      }
    }
  }
  public void draw ()
  {    
    if (flagged) {
      fill(0);
    } else if ( clicked && mines.contains(this) ) {
      fill(255, 0, 0);
      for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
          if (mines.contains(buttons[i][j])) {
            buttons[i][j].clicked = true;
          }
        }
      }
    } else if (clicked) {
      fill(200);
    } else {
      fill( 100 );
    }

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
