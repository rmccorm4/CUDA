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

#define N 1'000'000'000

int main()
{
	std::vector<float> test1(N, 3); 
	std::vector<float> test2(N, 7); 
	std::transform(test1.begin(), test1.end(), test2.begin(), test1.begin(), std::plus<float>());
	return 0;
}
