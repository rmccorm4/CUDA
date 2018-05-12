#include <cmath>
#include <cassert>
#include <unistd.h>
#include <fcntl.h>
#include <cstdio>
#include <string>
#include <fstream>
#include <algorithm>
#include <random>
#include <iostream>
#include <iomanip>
#include <numeric>

// Thrust Library for C++ CUDA code
#include <thrust/transform.h>
#include <thrust/functional.h>

#define N 1'000'000'000

int main()
{
	thrust::device_vector<float> test1(N, 3); 
	thrust::device_vector<float> test2(N, 7); 
	thrust::transform(test1.begin(), test1.end(), test2.begin(), test1.begin(), thrust::plus<float>());
	return 0;
}

