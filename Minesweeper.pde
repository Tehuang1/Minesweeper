import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public boolean gameEnd = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }
    
    for(int i = 0; i < 50; i++)
    setMines();
}
public void setMines()
{
  int r = (int)(Math.random()*NUM_ROWS);
  int c = (int)(Math.random()*NUM_COLS);
  if(mines.contains(buttons[r][c]) == false)
    mines.add(buttons[r][c]);
}

public void draw ()
{
    background( 0 );
    if(isWon() == true){
      gameEnd = true;
        displayWinningMessage();
    }
}
public boolean isWon()
{
    for(int i = 0; i < NUM_ROWS; i++){
       for(int j = 0; j < NUM_COLS; j++){
          if(mines.contains(buttons[i][j]) == false && buttons[i][j].clicked == false)
            return false;
       }
    }
    return true;
}
public void displayLosingMessage()
{
 gameEnd = true;
 for(int i = 0; i < NUM_ROWS; i++){
             for(int j = 0; j < NUM_COLS; j++){
                if(isValid(i,j) && buttons[i][j].clicked == false && mines.contains(buttons[i][j])){
                buttons[i][j].clicked = true;
                }
             }
          }
 buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("Y");
 buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("O");
 buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("U");
 buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("L");
 buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("O");
 buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("S");
 buttons[NUM_ROWS/2][NUM_COLS/2+4].setLabel("E");
}
public void displayWinningMessage()
{
 buttons[NUM_ROWS/2][NUM_COLS/2-3].setLabel("Y");
 buttons[NUM_ROWS/2][NUM_COLS/2-2].setLabel("O");
 buttons[NUM_ROWS/2][NUM_COLS/2-1].setLabel("U");
 buttons[NUM_ROWS/2][NUM_COLS/2+1].setLabel("W");
 buttons[NUM_ROWS/2][NUM_COLS/2+2].setLabel("I");
 buttons[NUM_ROWS/2][NUM_COLS/2+3].setLabel("N");
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i < row+2; i++){
    for(int j = col-1; j < col+2; j++){
      if(isValid(i,j) && mines.contains(buttons[i][j]))
        numMines++;
    }
  }
  if(mines.contains(buttons[row][col]))
    numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
     if(gameEnd == false){
     clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true)
            flagged = clicked = false;
          else
            flagged = true;
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow,myCol) > 0)
          setLabel(countMines(myRow,myCol));
        else{
          for(int i = myRow-1; i < myRow+2; i++){
            for(int j = myCol-1; j < myCol+2; j++){
              if(isValid(i,j) && buttons[i][j].clicked == false){
                buttons[i][j].mousePressed();
              }
            }
          }
        }
     }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
