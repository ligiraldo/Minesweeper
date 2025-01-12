import de.bezier.guido.*;

import de.bezier.guido.*;
private final static int NUM_ROWS = 10;
private final static int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int totalMines = 5;
private int thingsClicked = 0;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    
    
    setMines();
}
public void setMines()
{

    for(int i = 0; i < totalMines; i++){
          int r = (int)(Math.random()*NUM_ROWS);
          int c = (int)(Math.random()*NUM_COLS);
          if(!mines.contains(buttons[r][c])){
              mines.add(buttons[r][c]);
           }
           else i--;
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    if(thingsClicked == (NUM_COLS * NUM_ROWS) - totalMines){
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        if(mines.contains(buttons[i][j])){
          buttons[i][j].clicked = true;
        }
      }
    }
    stroke(255,0,0);
    textSize(50);
}
public void displayWinningMessage()
{
  stroke(0,255,0);
  textSize(50);
}
public boolean isValid(int r, int c)
{
  if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
    return true;
  }
  else return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
      for(int i = row-1 ; i <= row+1; i++){
    for(int j = col-1; j <= col+1; j++){
      if(isValid(i, j) == true && mines.contains(buttons[i][j]) && (row != i|| col != j)){
        numMines++;
      }
    }
  }
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
    public void mousePressed () 
    {
      clicked = true;
      if(isWon() == false){
        if(mouseButton == LEFT && mines.contains(this) == false){
          thingsClicked++;
        }
       if(mouseButton == RIGHT){
         flagged = !flagged;
         if(flagged == false){
           clicked = false;
         }
       }
       else if(mines.contains(this)){
         displayLosingMessage();
         System.out.println("You Lose");
       }
       else if(countMines(myRow, myCol) > 0){
         setLabel(countMines(myRow, myCol));
       }
       else{
          for(int i = myRow-1 ; i <= myRow+1; i++){
            for(int j = myCol-1; j <= myCol+1; j++){
              if(isValid(i, j) && buttons[i][j].clicked == false){
                myLabel = "";
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
