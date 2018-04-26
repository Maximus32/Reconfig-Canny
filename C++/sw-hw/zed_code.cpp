#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <string>
#include "Timer.h"

#include "Board.h"

using namespace std;

int main(int argc, char* argv[]){


	if(argc != 2){
		cerr << "Usage: " << argv[0] << " bitfile" << endl;
	}

	ifstream inputFile;
	inputFile.open("test_csv.csv");


	if(!inputFile.is_open()){
		cout << "\nError opening csv file!" << endl;
		return -1;
	}

	//debugging code
	/*
	string temp_string;
	getline(inputFile, temp_string, ',');
	cout << "\n" << temp_string << endl;

	double temp_dub = atof(temp_string.c_str());
	cout << temp_dub << endl;

	string::size_type sz;
	int16_t temp_int = (int16_t)stoi(temp_string, &sz, 10);
	cout << temp_int << endl;
	*/

	string::size_type sz;
	string in_string, in_string1, in_string2;


	//first three values in csv file are rows, cols, and time of algorithm
	getline(inputFile, in_string, ','); //read in the number of rows value (max = 1080)
	int num_rows = stoi(in_string, &sz, 10); 

	getline(inputFile, in_string, ','); //read in the number of cols value (max = 1920)
	int num_cols = stoi(in_string, &sz, 10); //convert string to int

	getline(inputFile, in_string, '\n'); //read in the time it took to generate the hw inputs
	double hw_input_gen_time = atof(in_string.c_str()); //convert string to double 

	//cout << "\nThe inputs are: " << num_rows << ", " << num_cols << ", " << hw_input_gen_time << endl;

	int32_t my_count = 0;

	int hw_inputs[num_rows * num_cols];

	//here we want to save two 16 bit values put together into a 32 bit block (31:16 | 15:0)
	//while(inputFile.good()){
	while(getline(inputFile, in_string1, ',')){
		//getline(inputFile, in_string1, ',');
		int16_t temp_int1 = (int16_t)stoi(in_string1, &sz, 10); //convert input string to integer value
		//get the next column's value
		getline(inputFile, in_string2, '\n');
		int16_t temp_int2 = (int16_t)stoi(in_string2, &sz, 10); //convert input string to integer value
		
		hw_inputs[my_count] = ((temp_int1 & 0xffff) << 16) | (temp_int2 & 0xffff);
		//for debugging
		my_count++;
	}

	//cout << "\nCount was: " << my_count << endl;

	//cout << hw_inputs[1] << endl;

	inputFile.close();


	//******** At this point hw_inputs contains each pixel's gradient magnitude and angle. so pixel0 = hw_inputs[0]
	//to find where a pixel is located in a typical image matrix: pixel(r,c) = hw_input[r*num_rows + c*num_cols]



	return 0;

}