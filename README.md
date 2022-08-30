# utterance-rewriting
This repository releases the code and data for utterance rewriting in open-domain dialogues. More details on data and code can be referred to this paper:

```
@article{jin2022improving,
  title={Improving Bot Response Contradiction Detection via Utterance Rewriting},
  author={Jin, Di and Liu, Sijia and Liu, Yang and Hakkani-Tur, Dilek},
  journal={arXiv preprint arXiv:2207.11862},
  year={2022}
}
```

## Where to use the code?

This code implements an utterance rewriting model that can rewrite an utterance into a complete form by resolving co-references and ellipsis. For example, if we have a dialogue like:

```
User: Hello! I heard you liked to go for walks with your Corgi. I don't know much about them. What can you tell me?         
System: Well Corgis are also called Welsh Corgis, for one thing.		
User: Why is that?
```

Here we would like to rewrite the last utterance to resolve the anaphor "that", then we can use this rewriting model and the resulting rewritten utterance would be: 
```
Why are Corgis also called Welsh Corgis?
```

## How to us this code?

1. Install the packages by running:

```
pip install -r requirements.txt
```

2. First create a folder for the model parameters by running:

```
mkdir -p models
```

And then download the trained model parameters from this [Google Drive](https://drive.google.com/drive/folders/1WJQngW67dBCVdX8AhkZ0nvKticRAca2a?usp=sharing) and put them in the "models" folder. We have released two model versions: t5-large and t5-base. 

3. Run the following command to perform rewriting and the result file is put in the same folder:

```
sh ./eval.sh --eval_set data-samples --model redo-t5-large --gpu 0
```

Here the argument "eval_set" refers to the data you would like to rewrite. A sample data file "data-samples.json" has been provided. In this file, each sample to be rewritten should be one dictionary in each line and there are two important keys in the dictionary: utterances and reference. "Utterances" is the concatenation of all utterances including the context history and the last utterance to be rewritten. We have three special tokens: "\<USR\>" is put in front of the user utterance, "\<SYS\>" is put before the system utterance, and "\<CUR\>" is put before the last utterance which will be rewritten. "Reference" can be the human-written reference sentence for automatic evaluation, which can be anything if you do not have the ground truth.  
