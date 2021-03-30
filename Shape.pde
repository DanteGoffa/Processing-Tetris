class shape
{
  private int[][] m_object;
  private int[][] m_test;
  private int m_shape;
  private int m_posY = 0;
  private int m_posX = (cols / 2) - 1;
  private int m_Cols;
  private int m_Rows;
  private int m_TRows;
  private int m_TCols;
  private int m_rand;
  
   shape(int s, int r)
   {
     m_shape = s;
     m_rand = r;
     
     determineShape();
   }
     
     int getRand()
     {
        return m_rand;
     }
     
     int[][] getObject()
     {
       return m_object; 
     }
     
     int[][] getTest()
     {
       return m_test; 
     }
     
     int getPosX()
     {
       return m_posX; 
     }
     
     int getPosY()
     {
       return m_posY; 
     }
     
     int getCols()
     {
       return m_Cols; 
     }
     
     int getRows()
     {
       return m_Rows; 
     }
     
     int getTCols()
     {
       return m_TCols; 
     }
     
     int getTRows()
     {
       return m_TRows; 
     }
     
     
     void setPosY()
     {
        ++m_posY;
     }
     
     void backPosX()
     {
       --m_posX;
     }
     
     void addPosX()
     {
       ++m_posX;
     }
     
     void setRotation()
     {
      int[][] shape = new int[m_Cols][m_Rows];      
    
      //transpose
      for (int y = 0; y < m_Cols; y++)
      {
        for (int x = 0; x < m_Rows; x++)
        {
          shape[y][x] = m_object[x][y];
        }
      }
    
      //reverse
      for (int y = 0; y < m_Cols; y++)
      {
        for (int x = 0; x < m_Rows/2; x++)
        {
          int temp = shape[y][x];
          shape[y][x] = shape[y][m_Rows - x - 1];
          shape[y][m_Rows - x - 1] = temp;
        }
      }
    
      //flip height and width
      int temp = m_Cols;
      m_Cols = m_Rows;
      m_Rows = temp;
      
      m_object = shape;
     }
     
     void determineShape()
     {
        if(m_shape == 0)
         {
           int temp[][] = {
             {m_rand,0},
             {m_rand,0},
             {m_rand,m_rand} };
             
           m_Cols = 2;
           m_Rows = 3;
           
           m_object = null;
           m_object = temp;
         }
         
         else if(m_shape == 1)
         {
           int temp[][] = {
             {m_rand,m_rand,0},
             {0,m_rand,m_rand} };
             
           m_Cols = 3;
           m_Rows = 2;
           
           m_object = null;
           m_object = temp;
         }
         
         else if(m_shape == 2)
         {           
           int temp[][] = {
             {m_rand},
             {m_rand},
             {m_rand},
             {m_rand} };
           
           m_Cols = 1;
           m_Rows = 4;
           
           m_object = null;
           m_object = temp;
         }
         
         else if(m_shape == 3)
         {           
           int temp[][] = {
             {m_rand,m_rand},
             {m_rand,m_rand} };
           
           m_Cols = 2;
           m_Rows = 2;
           
           m_object = null;
           m_object = temp;
         }
         else if(m_shape == 4)
         {           
           int temp[][] = {
             {0,m_rand,0},
             {m_rand,m_rand,m_rand} };
           
           m_Cols = 3;
           m_Rows = 2;
           
           m_object = null;
           m_object = temp;
         }
         
         else if(m_shape == 5)
         {
           int temp[][] = {
             {0, m_rand},
             {0, m_rand},
             {m_rand,m_rand} };
             
           m_Cols = 2;
           m_Rows = 3;
           
           m_object = null;
           m_object = temp;
         }
         
         else if(m_shape == 6)
         {           
           int temp[][] = {
             {0,m_rand,m_rand},
             {m_rand,m_rand,0} };
           
           m_Cols = 3;
           m_Rows = 2;
           
           m_object = null;
           m_object = temp;
         }
         
         m_TCols = m_Cols;
         m_TRows = m_Rows;
     }
}