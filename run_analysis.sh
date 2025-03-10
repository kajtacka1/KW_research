#!/bin/bash
# run_analysis.sh - Helper script for working with keyword clustering tool

# Check if help flag is provided
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "Helper script for keyword clustering tool"
  echo ""
  echo "Usage:"
  echo "  ./run_analysis.sh <mode> <input_file> <output_file> <collection_name> [additional_params]"
  echo ""
  echo "Modes:"
  echo "  new      - New analysis and save to DB"
  echo "  load     - Load from DB without reclustering"
  echo "  exp      - Experiment without saving to DB"
  echo ""
  echo "Examples:"
  echo "  ./run_analysis.sh new ./data/keywords.csv ./output/results.xlsx projekt_nazev"
  echo "  ./run_analysis.sh load ./data/keywords.csv ./output/loaded.xlsx projekt_nazev"
  echo "  ./run_analysis.sh exp ./data/keywords.csv ./output/experiment.xlsx \"--min-cluster-size 5\""
  exit 0
fi

# Check for required arguments
if [ $# -lt 4 ]; then
  echo "Error: Insufficient arguments"
  echo "Use --help for usage information"
  exit 1
fi

# Parse arguments
MODE=$1
INPUT_FILE=$2
OUTPUT_FILE=$3
COLLECTION_NAME=$4
ADDITIONAL_PARAMS=${5:-""}

# Current date in YYYYMMDD format
DATE=$(date +%Y%m%d)

# Ensure output directory exists
mkdir -p $(dirname "$OUTPUT_FILE")

# Execute based on mode
case $MODE in
  "new")
    # New analysis with DB save
    echo "Running new analysis and saving to DB collection '$COLLECTION_NAME'..."
    python main.py --input-file "$INPUT_FILE" --output-file "$OUTPUT_FILE" --use-advanced-clustering --save-to-vector-db --vector-db-collection "$COLLECTION_NAME" $ADDITIONAL_PARAMS
    ;;
    
  "load")
    # Load from DB
    echo "Loading data from DB collection '$COLLECTION_NAME'..."
    python main.py --input-file "$INPUT_FILE" --output-file "$OUTPUT_FILE" --load-from-vector-db --vector-db-collection "$COLLECTION_NAME" $ADDITIONAL_PARAMS
    ;;
    
  "exp")
    # Experiment without DB save
    echo "Running experimental analysis without saving to DB..."
    python main.py --input-file "$INPUT_FILE" --output-file "$OUTPUT_FILE" --use-advanced-clustering $ADDITIONAL_PARAMS
    ;;
    
  *)
    echo "Error: Unknown mode '$MODE'"
    echo "Valid modes: new, load, exp"
    echo "Use --help for usage information"
    exit 1
    ;;
esac

# Check if command was successful
if [ $? -eq 0 ]; then
  echo "Analysis completed successfully!"
  echo "Results saved to: $OUTPUT_FILE"
else
  echo "Analysis failed!"
fi