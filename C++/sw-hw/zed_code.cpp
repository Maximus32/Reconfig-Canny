//David Watts
//Reconfig final project

//This code is meant to run on the Arm processors inside the ZED board.
//Our final project needs OpenCV do to image processing to generate FPGA
//inputs. To generate these inputs, we run OpenCV code on our personal computer
//to generate a csv file which contains the inputs needed for the FPGA. This code
//reads those inputs in, executes the canny algorithm on the FPGA, then prints the 
//results to another csv file which will be used to print the image back on our personal
//computer.

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <string>
#include "Timer.h"

#include "Board.h"
#include <cstdlib>
#include <cassert>
#include <cstdio>


#define ADDR_WIDTH 21
#define MAX_SIZE (1<<ADDR_WIDTH)
#define MEM_IN_ADDR 0
#define MEM_OUT_ADDR 0
#define ROWS_ADDR ((1<<MMAP_ADDR_WIDTH)-5) //store the number of rows here
#define COLS_ADDR ((1<<MMAP_ADDR_WIDTH)-4) //store the number of cols here
#define GO_ADDR ((1<<MMAP_ADDR_WIDTH)-3)
#define SIZE_ADDR ((1<<MMAP_ADDR_WIDTH)-2) //size will equal rows*cols
#define DONE_ADDR ((1<<MMAP_ADDR_WIDTH)-1)

using namespace std;

int main(int argc, char* argv[]){


	if(argc != 2){
		cerr << "Usage: " << argv[0] << " bitfile" << endl;
		return -1;
	}

	ifstream inputFile;
	inputFile.open("test_csv.csv");


	if(!inputFile.is_open()){
		cout << "\nError opening csv file!" << endl;
		return -1;
	}

	string::size_type sz;
	string in_string, in_string1, in_string2;


	//first three values in csv file are rows, cols, and time of algorithm
	getline(inputFile, in_string, ','); //read in the number of rows value (max = 1080)
	unsigned num_rows = unsigned(stoi(in_string, &sz, 10)); 

	getline(inputFile, in_string, ','); //read in the number of cols value (max = 1920)
	unsigned num_cols = unsigned(stoi(in_string, &sz, 10)); //convert string to int

	getline(inputFile, in_string, '\n'); //read in the time it took to generate the hw inputs
	double hw_input_gen_time = atof(in_string.c_str()); //convert string to double 

	//cout << "\nThe inputs are: " << num_rows << ", " << num_cols << ", " << hw_input_gen_time << endl;

	int32_t my_count = 0; //need a 32 bit counter here b/c max size is 1920*1080
	unsigned data_size = (unsigned)(num_rows * num_cols);
	//int32_t hw_inputs[data_size];

	unsigned *hw_inputs, *hwOutput;
	hw_inputs = new unsigned[data_size];

	//here we want to save two 16 bit values put together into a 32 bit block (31:16 | 15:0)
	//while(inputFile.good()){
	while(getline(inputFile, in_string1, ',')){
		//getline(inputFile, in_string1, ',');
		int16_t temp_int1 = (int16_t)stoi(in_string1, &sz, 10); //convert input string to integer value
		//get the next column's value
		getline(inputFile, in_string2, '\n'); //instead of looking for a comma, new line character
		int16_t temp_int2 = (int16_t)stoi(in_string2, &sz, 10); //convert input string to integer value
		
		hw_inputs[my_count] = ((temp_int1 & 0xffff) << 16) | (temp_int2 & 0xffff);
		//for debugging
		my_count++;
	}

	//debugging
	//cout << "\nCount was: " << my_count << endl;
	//cout << hw_inputs[1] << endl;

	inputFile.close();


	//******** At this point hw_inputs contains each pixel's gradient magnitude and angle. so pixel0 = hw_inputs[0]
	//to find where a pixel is located in a typical image matrix: pixel(r,c) = hw_input[r*num_rows + c*num_cols]

	//setup clock frequencies
	vector<float> clocks(Board::NUM_FPGA_CLOCKS);
	clocks[0] = 100.0;
	clocks[1] = 0.0;
	clocks[2] = 0.0;
	clocks[3] = 0.0;

	//initialize board
	Board *board;
	try{
		board = new Board(argv[1], clocks);
	}
	catch(...){
		exit(-1);
	}

	unsigned size = (data_size);
	hwOutput = new unsigned[size];
	assert(hwOutput != NULL);

	//declare the timers
	Timer writeTime, readTime, waitTime;

	//write values to the FPGA
	writeTime.start();
	board->write(hw_inputs, MEM_IN_ADDR, data_size);
	board->write(&num_rows, ROWS_ADDR, 1);
	board->write(&num_cols, COLS_ADDR, 1);
	board->write(&size, SIZE_ADDR, 1);

	unsigned go = 1;
	unsigned done = 0;
	//assert go = 1 to begin the transfer

	board->write(&go, GO_ADDR, 1);
	writeTime.stop();

	waitTime.start(); //begin the timer to see how long the algorithm takes in hardware

	while(!done){
		board->read(&done, DONE_ADDR, 1);
	}

	waitTime.stop(); //algorithm has completed

	readTime.start(); //start the timer for reading the results back
	board->read(hwOutput, MEM_OUT_ADDR, size);
	readTime.stop();


	double transferTime = writeTime.elapsedTime() + readTime.elapsedTime();
	double hwWithInputGenTime = waitTime.elapsedTime() + hw_input_gen_time;


	ofstream outputFile;


    outputFile.open("hw_outputs.csv"); //open the csv file

    unsigned outputLength = (num_rows - 2) * (num_cols - 2);
    
    outputFile << num_rows-2 << "," << num_cols-2 << "," << transferTime << "," << hwWithInputGenTime << endl;

    for(int i = 0; i < outputLength; i++){
    		
    		outputFile << hwOutput[i] << "\n" << endl;
    		 	
    }

    outputFile.close();


	delete hwOutput;
	delete hw_inputs;

	return 0;

}