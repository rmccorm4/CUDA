#include <iostream>
#include <thrust/device_vector.h>

// Thrust Library for C++ CUDA code
#include <thrust/count.h>
#include <thrust/random.h>
#include <thrust/reduce.h>
#include <thrust/transform.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/complex.h>
#include <thrust/functional.h>
#include <thrust/device_ptr.h>
#include <cuda.h>

#define NUM_CLASSES 10


__global__ void softmax(float* softmax_layer, int NUM_THREADS)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;

	if ( index < NUM_THREADS )
	{

		float max = softmax_layer[index*NUM_CLASSES + 0];
		for (int i = 1; i < NUM_CLASSES; i++)
		{
			if (softmax_layer[index*NUM_CLASSES + i] > max)
			{
				max = softmax_layer[index*NUM_CLASSES + i];
			}
		}

		float sum = 0.0f;
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			// Subtract max from every element in vector and write it to softmax_layer output
			softmax_layer[index*NUM_CLASSES + i] -= max;
			// Cuda fast e^x function (expf)
			softmax_layer[index*NUM_CLASSES + i] = __expf(softmax_layer[index*NUM_CLASSES + i]); 
			// Accumulate sum of e^x_i's
			sum += softmax_layer[index*NUM_CLASSES + i];
		}
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			// Divide every element by sum
			softmax_layer[index*NUM_CLASSES + i] /= sum;
		}
		printf("Thread: %d \t Sum: %f \t Max: %f\n", index, sum, max);

	}
}

void print_results(float* pd_softmax, int NUM_THREADS)
{
	
}

int main()
{
	int NUM_THREADS = 1;
	thrust::device_vector<float> device_softmax_layer(NUM_THREADS*NUM_CLASSES);
	// Fill with 0 ... 9
	thrust::sequence(device_softmax_layer.begin(), device_softmax_layer.end());
	float* pd_softmax = thrust::raw_pointer_cast(device_softmax_layer.data());

	std::cout << "NUM THREADS: " << NUM_THREADS << std::endl;
	// Before
	for (int t = 0; t < NUM_THREADS; t++)
	{
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			std::cout << device_softmax_layer[t*NUM_CLASSES + i] << " ";
		}
		std::cout << std::endl;
	}

	softmax<<<NUM_THREADS, 1>>>(pd_softmax, NUM_THREADS);

	// After
	for (int t = 0; t < NUM_THREADS; t++)
	{
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			std::cout << device_softmax_layer[t*NUM_CLASSES + i] << " ";
		}
		std::cout << std::endl;
	}

	thrust::fill(device_softmax_layer.begin(), device_softmax_layer.end(), 9);

	std::cout << "NUM THREADS: " << NUM_THREADS << std::endl;
	// Before
	for (int t = 0; t < NUM_THREADS; t++)
	{
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			std::cout << device_softmax_layer[t*NUM_CLASSES + i] << " ";
		}
		std::cout << std::endl;
	}

	softmax<<<NUM_THREADS, 1>>>(pd_softmax, NUM_THREADS);

	// After
	for (int t = 0; t < NUM_THREADS; t++)
	{
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			std::cout << device_softmax_layer[t*NUM_CLASSES + i] << " ";
		}
		std::cout << std::endl;
	}

	thrust::sequence(device_softmax_layer.begin(), device_softmax_layer.end(), 0, 2);

	std::cout << "NUM THREADS: " << NUM_THREADS << std::endl;
	// Before
	for (int t = 0; t < NUM_THREADS; t++)
	{
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			std::cout << device_softmax_layer[t*NUM_CLASSES + i] << " ";
		}
		std::cout << std::endl;
	}

	softmax<<<NUM_THREADS, 1>>>(pd_softmax, NUM_THREADS);

	// After
	for (int t = 0; t < NUM_THREADS; t++)
	{
		for (int i = 0; i < NUM_CLASSES; i++)
		{
			std::cout << device_softmax_layer[t*NUM_CLASSES + i] << " ";
		}
		std::cout << std::endl;
	}

}
