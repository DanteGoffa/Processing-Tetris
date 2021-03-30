class imageProd
{
  PImage m_image;
  int m_score;
  boolean m_sold, m_selected;
  
  imageProd(PImage imag, int score)
  {
     m_image = imag;
     m_score = score;
     m_sold = false;
     m_selected = false;
  }
  
  void buyProd(int score)
  {
    if(!m_sold)
    {
       if(score >= m_score)
       {
         m_sold = true;
       }
       else
       {
         println("too expensive"); 
       }
    }
  }
  
  boolean sold()
  {
    return m_sold;
  }
  
  PImage getImage()
  {
    return m_image; 
  }
  
  int getScore()
  {
    return m_score; 
  }
  
  void setSelected()
  {
     m_selected = !m_selected;
  }
  
  boolean getSelected()
  {
    return m_selected; 
  }
}