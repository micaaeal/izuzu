//
//  main.c
//  aTan2AngleTest
//
//  Created by Adawat Chanchua on 10/2/55 BE.
//  Copyright (c) 2555 Adawat Chanchua. All rights reserved.
//

#include <stdio.h>
#include <math.h>

float GetRadianFromXY(float x, float y)
{
    float radian    = 0.0f;

        radian  = atan2f( y, x );
    
    
    return radian;
}

int main(int argc, const char * argv[])
{
    // insert code here...
    printf("Hello, arctan to angle!\n");
    
    float x         = -192;
    float y         = 9;
    float radian    = GetRadianFromXY(x, y);
    float angle     = radian * 180.0f / M_PI;
    printf ("angle: %f", angle);
    printf ("\n");
    
    /* // Quardrand #01
    for (int i=0; i<10; ++i)
    {
     float x         = 1.0f - (float)i/10.0f;
     float y         = (float)i/10.0f;
     float radian    = GetRadianFromXY(x, y);
     float angle     = radian * 180.0f / M_PI;
    }
    /**/
    
    /* // Quardrand #02
    printf ("----\n");
    for (int i=0; i<10; ++i)
    {
        float x         = -1.0f * (float)i/10.0f;
        float y         = 1.0f - (float)i/10.0f;

//        printf ("(x,y): (%f,%f)", x, y);
//        printf ("\n");
        
        float radian    = GetRadianFromXY(x, y);
        float angle     = radian * 180.0f / M_PI;
        
        printf ("angle: %f", angle);
        printf ("\n");
    }
    /**/
     
    /* // Quardrand #03
     printf ("----\n");
    for (int i=0; i<10; ++i)
    {
        float x         = -1.0f + (float)i/10.0f;
        float y         = (-1.0f) * (float)i/10.0f;
        
        //printf ("(x,y): (%f,%f)", x, y);
        //printf ("\n");
        
        float radian    = GetRadianFromXY(x, y);
        float angle     = radian * 180.0f / M_PI;
        
        printf ("angle: %f", angle);
        printf ("\n");
    }
    /**/
    
    /* // Quardrand #04
     printf ("----\n");
    for (int i=0; i<10; ++i)
    {
        float x         = (float)i/10.0f;
        float y         = (-1.0f) + (float)i/10.0f;
        
//        printf ("(x,y): (%f,%f)", x, y);
//        printf ("\n");
        
        float radian    = GetRadianFromXY(x, y);
        float angle     = radian * 180.0f / M_PI;
        
        printf ("angle: %f", angle);
        printf ("\n");
    }
    /**/
    
    return 0;
}

