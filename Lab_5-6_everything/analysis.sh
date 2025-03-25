#!/bin/bash

# Define parameter options
n_values=(1 auto)
parallel_threads_values=(1 auto)
dist_values=(load no)

# Output file
output_file="out.txt"
> "$output_file"  # Clear the output file before starting

# Iterate over parameter combinations
for n in "${n_values[@]}"; do
    for parallel_threads in "${parallel_threads_values[@]}"; do
        for dist in "${dist_values[@]}"; do
            for i in {1..3}; do
                echo "Running pytest with -n=$n, --parallel-threads=$parallel_threads, --dist=$dist (Run #$i)" | tee -a "$output_file"
                pytest -n "$n" --dist "$dist" --parallel-threads "$parallel_threads" tests/ &>> "$output_file"
                echo "------------------------------" >> "$output_file"
            done
        done
    done
done

echo "All tests completed. Results saved in $output_file"
