#include <stdlib.h>
#include <netImage.h>
#include <helpers.h>

/* Apply the sharpen mask to create a new array.  Free the original
   and return the new array */
unsigned char ** sharpen_array(unsigned char **a, int rows,int cols);
/*
{
  int i,j;
  unsigned char **tmp;

  tmp = allocate_pixel_array(rows,cols);

  rows--;
  cols--;

  for( i=1; i<rows; i++)
    for( j=1; j<cols; j++ )
      tmp[i][j] = saturate( 5 * a[i][j] -
			    ((int) a[i-1][j]+a[i][j-1]+a[i][j+1]+a[i+1][j]));

  tmp[0][0] = saturate( 2*a[0][0] - a[0][1] - a[1][0]);
  tmp[0][cols] = saturate( 2*a[0][cols] - a[0][cols-1] - a[1][cols]);
  tmp[rows][0] = saturate( 2*a[rows][0] - a[rows][1] - a[rows-1][0]);
  tmp[rows][cols] = saturate( 2*a[rows][cols] - a[rows][cols-1] - a[rows-1][cols]);
  
  for(i=1;i<rows;i++)
    {    
      tmp[i][0] = saturate( 3*a[i][0] - a[i][1] - a[i-1][0] - a[i+1][0]);
      tmp[i][cols] = saturate( 3*a[i][cols] - a[i][cols] - a[i-1][cols] - a[i+1][cols]);
    }

  for(i=1;i<cols-1;i++)
    {    
      tmp[0][i] = saturate( 3*a[0][i] - a[0][i-1] - a[0][i+1] - a[1][i]);
      tmp[rows][i] = saturate( 3*a[rows][i] - a[rows][i-1] - a[rows][i+1] - a[rows-1][i]);
    }

  free_pixel_array(a,rows+1);
  return tmp;
}
*/

void sharpenImage( netImage *image)
{
  switch(image->magicNumber)
    {
    case '3':
    case '6':
      image->rgb.r=sharpen_array(image->rgb.r,image->rows,image->cols);
      image->rgb.g=sharpen_array(image->rgb.g,image->rows,image->cols);
      image->rgb.b=sharpen_array(image->rgb.b,image->rows,image->cols);
      break;
    case '2':
    case '4':
      image->gray.i=sharpen_array(image->gray.i,image->rows,image->cols);
      break;
    default:
      fprintf(stderr,"Error sharpening unknown image type\n");
      exit(1);
    }
}

  
