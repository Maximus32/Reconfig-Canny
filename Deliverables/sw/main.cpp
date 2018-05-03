//  Modified April 2018 by David Watts for Reconfigurable computing final project
//
//  main.cpp
//  Canny Edge Detector
//
//  Created by Hasan Akgün on 21/03/14.
//  Copyright (c) 2014 Hasan Akgün. All rights reserved.
//



#include <iostream>
#define _USE_MATH_DEFINES
#include <cmath>
#include <vector>
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "canny.h"

using namespace cv;
using namespace std;

int main(int argc, char** argv)
{
    //cv::String filePath = "index2.jpeg"; //Filepath of input image
    if(argc != 2){
    	cerr << "\nUsage: ./runFile imageName.jpeg" << endl;
    	return -1;
    }

    String filePath = argv[1];

    cout << "\n\n" << filePath << endl;

    canny cny(filePath);
        
    return 0;
}

