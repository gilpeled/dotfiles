# Senior AI Research Engineer Take home task \- singing voice analysis

## Instructions

1. Build a classifier to **classify singer age** from audio singing performances.  
   * Use the partial DAMP-S-AG dataset (details below).  
   * Classify age in coarse buckets.  
   * **Use deep learning**. Build your model from scratch, define and justify your architecture.   
     In particular, do not use an existing audio model or pretrained weights.  
   * Train the model and evaluate its performance.  
2. Run several iterations to improve your solution’s performance.  
   * We recommend: don’t focus on exhaustive hyperparameter sweeps or marginal performance gains \- the goal is to showcase your thinking, not an actual state-of-the-art classifier. There isn't enough data here to train to 99% accuracy anyway, 50% is a good stretch goal.  
3. Compare the performance of your iterations. Explain the differences.   
4. Explain how you could further improve results using other approaches.

## Meta instructions

1. Your submission should include:  
   * **All your code**, notebooks, etc. \- a git repo or a zip file, whatever is convenient. Don’t worry too much about it looking nice, as long as it is sufficiently readable.  
   * **A PDF or .md file log** of the experiments you ran, your considerations over the exercise, and your answers to the open questions above.  
   * **Model evaluation results**.  
2. We estimate the needed work time at around **4 hours**.  
3. Feel free to **use your favorite coding agent**. If your access to personal LLM inference is limited, an OpenRouter API key has been provided for you in the e-mail containing these instructions (see OpenRouter appendix for usage).  
4. Don’t worry too much over the model results. Your process is more interesting in this exercise.  
5. Don’t use any datasets other than DAMP-S-AG.  
6. For training, we suggest using free GPUs on Lightning AI Studio (see the Lightning AI Studio/Google Colab appendix for a quick-start) or any other solution you are comfortable with.  
7. If anything is unclear about the exercise, please feel comfortable to reach out to us and ask.

# Dataset

[DAMP-S-AG](https://zenodo.org/records/3596940) is a dataset from 2015 of singing recordings: the full data set includes 17582 solo performances of different singers on the Smule karaoke app, all singing the same song: Amazing Grace.

**Important:** for this exercise, use the provided subset of \~**10% of the dataset,** for faster iteration. You may assume all tracks in the partial dataset are sampled at 22050Hz.

`!pip install gdown`  
`!gdown "https://drive.google.com/uc?id=1RJoGI5ONV9v1V8sK8E2bJKtg-GTRF85j" -O ./DAMP-S-AG-partial.zip`  
`!unzip ./DAMP-S-AG-partial.zip -d ./DAMP-S-AG-partial`

The provided table `amazing_grace.tsv` contains metadata such as country, gender, age, account id etc. covering the partial dataset.

# OpenRouter appendix

You have been provided with an API key for LLM inference on [openrouter.ai](http://openrouter.ai). This provides you with access to frontier AI models in all harnesses that allow you to Bring Your Own Key.  
If you use `claude-code`, you can utilize the API key by following [the openrouter docs](https://openrouter.ai/docs/guides/coding-agents/claude-code-integration#step-2-connect-claude-to-openrouter).  
If you use `opencode`, authenticate using `opencode auth login -p OpenRouter`

# Lightning AI Studio/Google Colab appendix

**Lightning AI Studio** provides a machine with T4 GPU you can connect to using VSCode/Cursor or SSH. Disk contents are persistent, installations are not (`sudo apt install ffmpeg`, `uv tool install hf` etc.). The free tier provides 22 hours of GPU usage, but requires phone number verification.

**Google Colab** provides free access to machines with T4 GPU, but only the **ipynb** notebook file is persistent. Access via VSCode/Cursor is supported via the Google Colab VSCode extension, and a terminal is available in Google Colab itself (bottom left corner).

If you wish to work on either platform via the built-in terminal or SSH, here is a quick-start bash script to get you set up with `claude-code`, `opencode`, the [openrouter.ai](http://openrouter.ai) API key and a GitHub personal access token \- [Lightning AI Studio/Google Colab Shell Setup](https://docs.google.com/document/d/e/2PACX-1vRXBo7A87jKX6bfus326UrXJd5HcqIHeF9uN0ZIy26opl-CmMacCdtwMxiZ0Z-T0F5X3c9q047h_i07/pub).