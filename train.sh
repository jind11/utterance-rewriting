POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -d|--model_dir)
    model_dir="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--model_name)
    model_name="$2"
    shift # past argument
    shift # past value
    ;;
    -g|--gpu)
    gpu="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

echo ${model_name}
num_train_epochs=12
if [ ${model_name} == 't5-base' ]
then
  per_device_train_batch_size=10
  per_device_eval_batch_size=12
  source_prefix="summarize: "
elif [ ${model_name} == 'bart-large' ]
then
  per_device_train_batch_size=8
  per_device_eval_batch_size=12
  source_prefix=None
elif [ ${model_name} == 'pegasus-large' ]
then
  per_device_train_batch_size=6
  per_device_eval_batch_size=10
  source_prefix=None
  num_train_epochs=8
elif [ ${model_name} == 't5-large' ]
then
  per_device_train_batch_size=1
  per_device_eval_batch_size=2
  source_prefix="summarize: "
  num_train_epochs=4
fi

DATA_DIR=./data
mkdir -p ./tmp/redo-final-${model_name}

CUDA_VISIBLE_DEVICES=${gpu} python run_summarization.py \
    --model_name_or_path ${model_dir}/${model_name} \
    --do_train \
    --do_eval \
    --train_file ${DATA_DIR}/train-for-rewriting.json \
    --validation_file ${DATA_DIR}/valid-for-rewriting.json \
    --source_prefix ${source_prefix}  \
    --text_column utterances \
    --summary_column reference \
    --output_dir ./tmp/redo-final-${model_name} \
    --overwrite_output_dir \
    --per_device_train_batch_size=${per_device_train_batch_size} \
    --per_device_eval_batch_size=${per_device_eval_batch_size} \
    --max_source_length 256 \
    --max_target_length 64 \
    --predict_with_generate \
    --num_train_epochs ${num_train_epochs} \
    --save_total_limit 1