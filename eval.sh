POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -g|--gpu)
    gpu="$2"
    shift # past argument
    shift # past value
    ;;
    -m|--model)
    model="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--eval_set)
    eval_set="$2"
    shift # past argument
    shift # past value
    ;;
esac
done

arrIN=(${model//-/ })
model_type="${arrIN[-2]}-${arrIN[-1]}"
echo ${model_type}
if [ ${model_type} == 't5-base' ]
then
  per_device_eval_batch_size=32
  source_prefix="summarize: "
elif [ ${model_type} == 'bart-large' ]
then
  per_device_eval_batch_size=12
  source_prefix=None
elif [ ${model_type} == 'pegasus-large' ]
then
  per_device_eval_batch_size=10
  source_prefix=None
elif [ ${model_type} == 't5-large' ]
then
  per_device_eval_batch_size=12
  source_prefix="summarize: "
fi

CUDA_VISIBLE_DEVICES=${gpu} python run_summarization.py \
    --model_name_or_path ./models/${model} \
    --do_predict \
    --train_file ${eval_set}.json \
    --validation_file ${eval_set}.json \
    --test_file ${eval_set}.json \
    --source_prefix ${source_prefix} \
    --text_column utterances \
    --summary_column reference \
    --output_dir ./ \
    --overwrite_output_dir \
    --per_device_train_batch_size=4 \
    --per_device_eval_batch_size=${per_device_eval_batch_size} \
    --max_source_length 256 \
    --max_target_length 64 \
    --predict_with_generate \
    --num_train_epochs 4 \
    --save_total_limit 1 \
    --num_beams 5

mv ./generated_predictions.txt ./${eval_set}-${model}-rewritten.txt
