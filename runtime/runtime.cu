#include <stdio.h>

int main() {
	int runtime;
	int driver;

	cudaError_t runtime_err = cudaRuntimeGetVersion(&runtime);
	cudaError_t driver_err = cudaRuntimeGetVersion(&driver);

	printf("Runtime Version: %d. %s\n", runtime, cudaGetErrorString(runtime_err));
	printf("Driver Version: %d. %s\n", driver, cudaGetErrorString(driver_err));
}
