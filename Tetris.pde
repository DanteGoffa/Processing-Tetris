final int rows = 20;
final int cols = 10;

//grid where everything has being displayed on
int[][] grid = new int[cols][rows];

//a variable for the current shape you are controlling.
shape s;

int blockWidth;

//The needed variables for counting 1 second.
int count = 1;
int modulo = 61;

//Boolean which control the windows
boolean playing = false;
boolean shop = false;

//Booleans for controlling tetris
boolean down = false;
boolean newShape = false;

//your (beginning) score
int score = 0;

//Needed variables for the images in the game.
imageProd[][] images;
PImage[][] bImages;
PImage background;
float amountImages;
int imageRows = 4;
int resizeHeight = 200;
int resizeWidth = 100;
float spacing;

void setup()
{
  size(500, 1000);

  //amount of images that fit in the X-axis
  amountImages = (width / 100);

  //Calculating the spacing between each picture.
  spacing = resizeWidth / amountImages;

  //initiating image array. First one is for the thumbnails and second one is a collection with the big sized backgrounds.
  images = new imageProd[int(amountImages)][imageRows];
  bImages = new PImage[int(amountImages)][imageRows];

  //loading the thumbnail images with their needed parameters.
  images[0][0] = new imageProd(loadImage("1.jpg"), 1000);
  images[1][0] = new imageProd(loadImage("2.jpg"), 2000);
  images[2][0] = new imageProd(loadImage("3.png"), 3000);
  images[3][0] = new imageProd(loadImage("4.png"), 4000);
  images[0][1] = new imageProd(loadImage("5.jpg"), 5000);
  images[1][1] = new imageProd(loadImage("6.jpg"), 6000);
  images[2][1] = new imageProd(loadImage("7.jpg"), 7000);
  images[3][1] = new imageProd(loadImage("8.jpg"), 8000);
  images[0][2] = new imageProd(loadImage("15.jpg"), 9000);
  images[1][2] = new imageProd(loadImage("10.jpg"), 10000);
  images[2][2] = new imageProd(loadImage("11.jpg"), 11000);
  images[3][2] = new imageProd(loadImage("16.jpg"), 12000);
  images[0][3] = new imageProd(loadImage("13.jpg"), 13000);
  images[1][3] = new imageProd(loadImage("14.jpg"), 14000);
  images[2][3] = new imageProd(loadImage("9.png"), 15000);
  images[3][3] = new imageProd(loadImage("12.jpg"), 20000);

  //Loading the big sized backgrounds.
  bImages[0][0] = loadImage("b1.jpg");
  bImages[1][0] = loadImage("b2.jpg");
  bImages[2][0] = loadImage("b3.png");
  bImages[3][0] = loadImage("b4.png");
  bImages[0][1] = loadImage("b5.jpg");
  bImages[1][1] = loadImage("b6.jpg");
  bImages[2][1] = loadImage("b7.jpg");
  bImages[3][1] = loadImage("b8.jpg");
  bImages[0][2] = loadImage("b15.jpg");
  bImages[1][2] = loadImage("b10.jpg");
  bImages[2][2] = loadImage("b11.jpg");
  bImages[3][2] = loadImage("b16.jpg");
  bImages[0][3] = loadImage("b13.jpg");
  bImages[1][3] = loadImage("b14.jpg");
  bImages[2][3] = loadImage("b9.png");
  bImages[3][3] = loadImage("b12.jpg");

  //start with a shape when game is turned on
  addShape();

  //Calculate the width of each block according to the window's width.
  blockWidth = width / cols;
}

void draw()
{
  background(0);

  //The code needed for every frame when playing Tetris.
  if (playing)
  {
    background(100);

    if (background != null)
    {
      image(background, 0, 0);
    }

    if (down)
    {
      modulo = 5;
    } else
    {
      modulo = 61;
    }

    if (count % modulo == 0)
    {    
      clearPresence();

      s.setPosY();

      count = 0;
    }

    if (newShape) 
    {
      addShape();
      checkKill();
    }

    checkHit();

    updateGrid();

    drawGrid();
    ++count;
  }

  //The code needed for every frame when in the shop.
  else if (shop)
  {    
    for (int i = 0; i < imageRows; ++i)
    {
      for (int j = 0; j < amountImages - 1; ++j)
      {
        if (!images[j][i].sold())
        {
          tint(255, 126);
        }

        pushMatrix();

        int x = int((mouseX - spacing / 2.0) / (resizeWidth + spacing));
        int y = int((mouseY - spacing / 2.0) / (resizeHeight + spacing));

        translate( spacing + ((resizeWidth + spacing) * j), spacing + ((resizeHeight + spacing) * i));

        if (x == j && y == i)
        {
          //translate(- (spacing + ((resizeWidth + spacing) * j)), - spacing + ((resizeHeight + spacing) * i));
          scale(1.05);
        }       

        if (images[j][i].getSelected())
        {
          rect(-5, -5, resizeWidth + 10, resizeHeight + 10);
        }

        image(images[j][i].getImage(), 0, 0);

        popMatrix();

        tint(255, 255);

        if (!images[j][i].sold())
        {
          textAlign(CENTER);
          textSize(20);
          text(images[j][i].getScore(), spacing + ((resizeWidth + spacing) * j) + (resizeWidth / 2), spacing + ((resizeHeight + spacing) * i) + (resizeHeight / 2));
        }
      }
    }
  }


  //Code needed for every frame when at the start screen.
  else if (!playing && !shop)
  {
    fill(255);

    textAlign(CENTER);
    textSize(50);
    text("PLAY", width / 2, height / 2);

    text("SHOP", width / 2, height - (height / 3));

    hovered();
  }


  if (shop)
  {
    textSize(20);
  }

  fill(255);
  textAlign(RIGHT);
  text(score, width - 5, 50);
}

//makes shapes stop if they hit another block or the ground
void checkHit()
{  
  if (s.getPosY() + s.getRows() < rows)
  {    
    //for each column
    for (int i = 0; i < s.getCols(); i++)
    {        
      boolean shapeStarted = false;
      boolean shapeEnded = false;

      //step through each row of that column

      for (int j = 0; j < s.getRows(); j++)
      {
        //if the square at that position == end of the shape in that column OR it is the end of the shape

        if  (j == s.getRows() - 1 && (s.getObject()[j][i] != 0))
        {
          if (grid[s.getPosX() + i]
            [s.getPosY() + j + 1] != 0) 
          {
            newShape = true;
          }
        } else if ((s.getObject()[j][i] == 0 && shapeStarted))
        {
          //if (s.getPosY() + s.getRows() < Rows)
          //{
          if (grid[s.getPosX() + i][s.getPosY() + j] != 0 && !shapeEnded) 
          {
            newShape = true;
          } else
          {
            shapeEnded = true;
          }
          //  }
        } else if (s.getObject()[j][i] != 0)
        {
          shapeStarted = true;
        }
      }
    }
  }
  if (s.getPosY() + s.getRows() == rows)
  {
    newShape = true;
  }
}

//Draws the full grid with all the blocks in it.
void drawGrid()
{
  for (int i = 0; i < cols; ++i)
  {
    for (int j = 0; j < rows; ++j)
    {
      switch(grid[i][j])
      {
      case 0: 
        noFill();
        break;
      case 1: 
        fill(200, 0, 0);
        break;
      case 2: 
        fill(0, 200, 0);
        break;
      case 3: 
        fill(0, 0, 200);
        break;
      case 4: 
        fill(0, 240, 240);
        break;
      case 5: 
        fill(240, 160, 0);
        break;
      case 6: 
        fill(240, 240, 0);
        break;
      case 7: 
        fill(160, 0, 240);
        break;
      }

      rect(blockWidth * i, blockWidth * j, blockWidth, blockWidth);
    }
  }
}

//Inserts the (controlable) shape into the big grid. So everytime it moves, the grid is updates with the data from the small shape grid.
void updateGrid()
{ 
  for (int i = 0; i < s.getCols(); ++i)
  {
    for (int j = 0; j < s.getRows(); ++j)
    {       
      if (s.getObject()[j][i] != 0)
      {
        grid[s.getPosX() + i][s.getPosY() + j] = s.getObject()[j][i];
      }
    }
  }

  if (newShape && s.getPosY() == 0)
  {
    newShape = false;
  }
}

//Clears the spaces where the shape has BEEN. so without this, there would be trails behind the shapes.
void clearPresence()
{
  if (!newShape || (count % modulo) != 0)
  {
    for (int i = 0; i < s.getCols(); ++i)
    {
      for (int j = 0; j < s.getRows(); ++j)
      {
        if (s.getObject()[j][i] != 0)
        {
          grid[s.getPosX() + i][s.getPosY() + j] = 0;
        }
      }
    }
  }
}

//Adds a new controlable shape to the game
void addShape()
{
  int randomnum = int(random(7));
  s = new shape(randomnum, int(random(1, 8)));

  for (int i = 0; i < s.getCols(); ++i)
  {
    for (int j = 0; j < s.getRows(); ++j)
    {       
      if (s.getObject()[j][i] != 0)
      {
        if (grid[s.getPosX() + i][s.getPosY() + j] != 0)
        {
          playing = false;
        }
      }
    }
  }

  if (newShape && s.getPosY() == 0)
  {
    newShape = false;
  }
}

//Checks if you made a full line which will then be removed if true. When the line is removed, all the lines above will be put one step down.
void checkKill()
{  
  for (int i = 0; i < rows; ++i)
  {
    int counta = 0;

    for (int j = 0; j < cols; ++j)
    {
      if (grid[j][i] != 0)
      {
        ++counta;
      }
    }

    if (counta == cols)
    {
      score += 1000;

      for (int j = 0; j < cols; ++j)
      {
        grid[j][i] = 0;
      }

      for (int z = i; z > 1; --z)
      {
        for (int j = 0; j < cols; ++j)
        {
          grid[j][z] = grid[j][z - 1];
        }
      }

      for (int j = 0; j < cols; ++j)
      {
        grid[j][0] = 0;
      }
    }


    counta = 0;
  }
}

//Checks the left side of the shape for collision.
boolean isLeft()
{
  //for each column
  for (int i = 0; i < s.getRows(); i++)
  {        
    boolean shapeStarted = false;
    boolean shapeEnded = false;
    println("ROW" + i);
    //step through each column of that row

    for (int j = s.getCols() - 1; j >= 0; --j)
    {
      println("COLUMN" + j);
      //if the square at that position == end of the shape in that column OR it is the end of the shape

      if  (j == 0 && (s.getObject()[i][j] != 0))
      {
        if (s.getPosX() > 0)
        {
          if (grid[s.getPosX() - 1][s.getPosY() + i] != 0) 
          {
            println("CASE 1");
            return false;
          }
        }
      } else if ((s.getObject()[i][j] == 0 && shapeStarted))
      {
        println("SHAPE STARTED");
        if (grid[s.getPosX() + j][s.getPosY() + i] != 0 && !shapeEnded) 
        {
          println("CASE 2");

          return false;
        } else
        {
          println("END OF SHAPE");
          shapeEnded = true;
        }
      } else if (s.getObject()[i][j] != 0)
      {
        shapeStarted = true;
      }
    }
  }
  if (!(s.getPosX() != 0 && s.getPosY() + s.getRows() != rows))
  {
    println("CASE 3");

    return false;
  }

  return true;
}

//Checks the right side of the shape for collision.
boolean isRight()
{
  if (s.getPosX() + s.getCols() < cols - 1)
  {
    //for each column
    for (int i = 0; i < s.getRows(); i++)
    {        
      boolean shapeStarted = false;
      boolean shapeEnded = false;
      println("ROW" + i);
      //step through each column of that row

      for (int j = 0; j < s.getCols(); ++j)
      {
        println("COLUMN" + j);
        //if the square at that position == end of the shape in that column OR it is the end of the shape

        if  (j == s.getCols() - 1 && (s.getObject()[i][j] != 0))
        {
          if (s.getPosX() + s.getCols() < cols)
          {
            if (grid[s.getPosX() + s.getCols()][s.getPosY() + i] != 0) 
            {
              println("CASE 1");
              return false;
            }
          }
        } else if ((s.getObject()[i][j] == 0 && shapeStarted))
        {
          println("SHAPE STARTED");
          if (grid[s.getPosX() + j][s.getPosY() + i] != 0 && !shapeEnded) 
          {
            println("CASE 2");

            return false;
          } else
          {
            println("END OF SHAPE");
            shapeEnded = true;
          }
        } else if (s.getObject()[i][j] != 0)
        {
          shapeStarted = true;
        }
      }
    }
  }
  if (!(s.getPosX() != cols - s.getCols() && s.getPosY() + s.getRows() != rows))
  {
    println("CASE 3");

    return false;
  }

  return true;
}

//Checks if you are hovering over the buttons on the start screen.
void hovered()
{
  if (!playing && !shop)
  {    
    if (mouseX > (width / 2) - 75 && mouseX < (width / 2) + 75 && mouseY > (height / 2) - 50 && mouseY < (height / 2) + 50)
    {
      fill(255);

      textAlign(CENTER);
      textSize(50);
      rect((width / 2) - 75, (height / 2) - 50, 150, 65);

      fill(255, 0, 0);
      text("PLAY", width / 2, height / 2);
    } else if (mouseX > (width / 2) - 75 && mouseX < (width / 2) + 75 && mouseY > (height - (height / 3)) - 50 && mouseY < (height - (height / 3)) + 50)
    {
      fill(255);

      textAlign(CENTER);
      textSize(50);
      rect((width / 2) - 75, (height - (height / 3)) - 50, 150, 65);

      fill(255, 0, 0);
      text("SHOP", width / 2, height - (height / 3));
    }
  }
}

//All the keys in the game.
void keyPressed()
{
  if (keyCode == UP)
  {
    clearPresence();

    s.setRotation();

    if (s.getPosX() + s.getCols() > cols - 1)
    {
      s.backPosX();
    }

    if (s.getPosX() < 0)
    {
      s.addPosX();
    }
  } else if (keyCode == LEFT)
  {     
    if (isLeft())
    {
      clearPresence();
      s.backPosX();
    }
  } else if (keyCode == RIGHT)
  {
    if (isRight())
    {
      clearPresence();
      s.addPosX();
    }
  } else if (keyCode == DOWN)
  {
    down = true;
  } else if (keyCode == BACKSPACE)
  {
    if (playing)
    {
      playing = false;
    }

    if (shop)
    {
      shop = false;
    }
  }
}

//Small bugfix on the downbutton. With booleans the down button is more responsive by changing the modulo counter.
void keyReleased()
{
  if (keyCode == DOWN)
  {
    down = false;
  }
}

//All the code which checks your clicking in the menus.
void mousePressed()
{
  if (!playing && !shop)
  {    
    if (mouseX > (width / 2) - 75 && mouseX < (width / 2) + 75 && mouseY > (height / 2) - 50 && mouseY < (height / 2) + 50)
    {
      playing = true;

      for (int i = 0; i < cols; ++i)
      {
        for (int j = 0; j < rows; ++j)
        {
          grid[i][j] = 0;
        }
      }

      addShape();
    }

    if (mouseX > (width / 2) - 75 && mouseX < (width / 2) + 75 && mouseY > (height - (height / 3)) - 50 && mouseY < (height - (height / 3)) + 50)
    {
      shop = true;
    }
  } else if (shop)
  {
    int x = int((mouseX - spacing / 2.0) / (resizeWidth + spacing));
    int y = int((mouseY - spacing / 2.0) / (resizeHeight + spacing));

    if (!(x < 0 || x >= amountImages || y < 0 || y >= imageRows))
    {
      if (!images[x][y].sold())
      {
        images[x][y].buyProd(score);

        if (images[x][y].sold())
        {
          score -= images[x][y].getScore();
        }
      } else
      {
        background = bImages[x][y];

        for (int i = 0; i < imageRows; ++i)
        {
          for (int j = 0; j < amountImages - 1; ++j)
          {
            if (images[j][i].getSelected())
            {
              images[j][i].setSelected();
            }
          }
        }

        images[x][y].setSelected();
      }
    }
  }
}