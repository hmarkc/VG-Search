#!/bin/bash

export CONFIG=recipes/Qwen-2.5-Math-1.5B-Instruct/beam_search.yaml
export PRM=Skywork/Skywork-o1-Open-PRM-Qwen-2.5-7B
export OUTPUT_DIR=./output/maximal_granularity

# Check if the directories exist, if not create them
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating OUTPUT_DIR: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi


n=4
g_list=(1 2 3 4)
num_iterations_list=(12 6 4 3)

echo "Running test_time_compute.py with different g values"

for j in {0..3}
do  
    g=${g_list[$j]}
    num_iterations=${num_iterations_list[$j]}
    echo "Running test_time_compute.py with n=$n, g=$g, num_iterations=$num_iterations"
    dir_path="$OUTPUT_DIR/Qwen-2.5-Math-1.5B-Instruct-Skywork-o1-7B-PRM-n${n}-g${g}-I-${num_iterations}"
    # Check if the directory exists, if not create it
    if [ ! -d "$dir_path" ]; then
        mkdir -p "$dir_path"
        echo "Directory $dir_path created."
    else
        echo "Directory $dir_path already exists."
    fi
    LOG_FILE="$dir_path/log.log"

    python scripts/test_time_compute.py $CONFIG \
        --n=$n \
        --num_samples=500 \
        --prm_path=$PRM \
        --output_dir=$dir_path \
        --seed=0 \
        --lookahead=0 \
        --num_iterations=$num_iterations \
        --g=$g \
        --beam_width=4 > "$LOG_FILE" 2>&1

    echo "Test Time Compute completed for n=$n, g=$g, num_iterations=$num_iterations. Check $LOG_FILE for details."
done


