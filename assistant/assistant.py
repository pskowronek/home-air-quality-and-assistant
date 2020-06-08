# An attempt to build continues voice recognition and commands execution
# Based on:
# - https://stackoverflow.com/questions/38090440/running-different-commands-with-different-words-in-pocketsphinx
# - https://stackoverflow.com/questions/25394329/python-voice-recognition-library-always-listen
# - https://github.com/cmusphinx/pocketsphinx/blob/master/swig/python/test/continuous_test.py
# - https://github.com/cmusphinx/pocketsphinx/blob/master/swig/python/test/decoder_test.py
# - https://thenewstack.io/off-the-shelf-hacker-open-source-voice-recognition-without-a-net/
# API:
# - https://cmusphinx.github.io/doc/python/pocketsphinx.pocketsphinx.Decoder-class.html
# Calculating sentences similarity by using Levenshtein hinted by :
# - https://towardsdatascience.com/calculating-string-similarity-in-python-276e18a7d33a


import sys
import os
import subprocess

from collections import defaultdict
from pocketsphinx.pocketsphinx import *
import pyaudio
import yaml
import Levenshtein
import sdnotify

notifier = sdnotify.SystemdNotifier()

# Load config first
config_file = open(os.path.join(os.getcwd(), 'config.yaml'), 'r')
config = yaml.load(config_file)

# Create Decoder config
pocketsphinx_config = Decoder.default_config()
pocketsphinx_config.set_string('-hmm', os.path.join(os.getcwd(), config['hmm_path']))
pocketsphinx_config.set_string('-dict', os.path.join(os.getcwd(), config['dict_path']))
pocketsphinx_config.set_string('-lm', os.path.join(os.getcwd(), config['lm_path']))
pocketsphinx_config.set_string('-kws', os.path.join(os.getcwd(), config['keyphrase_path']))

# Initialize audio
p = pyaudio.PyAudio()
stream = p.open(format=pyaudio.paInt16, channels=1, rate=16000, input=True, frames_per_buffer=1024)
stream.start_stream()

# Load invocations and commands
invocations = config['invocations']

# Process audio chunk by chunk. On keyword detected perform action and restart search
decoder = Decoder(pocketsphinx_config)
logmath = decoder.get_logmath()
# decoder.set_keyphrase('wakeup', 'BRUCE')
# decoder.set_search('wakeup')

invocation_ctx = None
in_speech_bf = False
decoder.start_utt()

# Run some initialization scripts for terminal displays
subprocess.Popen([os.path.join(os.getcwd(), config['init_exec']).communicate()


notifier.notify("READY=1")

def calc_similarity(command, sentence, hyp_str):
    if sentence == hyp_str:
        return 1000
    score = 100 - Levenshtein.distance(sentence, hyp_str)
    shoulds = command['should']
    musts = command['must']
    must_nots = command['must_not']

    for must_not in must_nots:
        if must_not in hyp_str:
            score = 0
            break
    if score == 0:
        return 0

    for must in musts:
        if not must in hyp_str:
            score = 0
            break
    if score == 0:
        return 0

    for should in shoulds:
        if should in hyp_str:
            score *= 1.2
        else:
            score *= 0.8
    return score


while True:
    notifier.notify("WATCHDOG=1")
    buf = stream.read(1024)
    if buf:
         decoder.process_raw(buf, False, False)
    else:
         print("Unable to get audio, exiting")
         break

    hyp = decoder.hyp()
    seg = decoder.seg()
    hyp_str = hyp.hypstr.lower() if hyp else None
    now_in_speech = decoder.get_in_speech()

    if now_in_speech != in_speech_bf:
        in_speech_bf = now_in_speech
        if not in_speech_bf:
            decoder.end_utt()
            if hyp_str:
                print("Heard: '%s' while being in '%s' context (score: %d, confidence: %d -> in log scale %d)" % (hyp_str, invocation_ctx, hyp.best_score, logmath.exp(hyp.prob), hyp.prob))
                if not invocation_ctx:
                    if hyp_str in invocations:
                        print("Matched invocation: '%s'" % hyp_str) 
                        invocation_ctx = hyp_str
                        subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['enter']), invocation_ctx, hyp_str]).communicate()
                    else:
                        print('Unknown invocation or wrongly heard, silently ignoring')
                else:
                    matched = False
                    score_dict = defaultdict(list)

                    commands = invocations[invocation_ctx]['commands']
                    for command in commands:
                        print("- command: '%s':" % command['name'])
                        for sentence in command['sentence']:
                            score = calc_similarity(command, sentence.lower(), hyp_str)
                            score_dict[score].append(command)
                            print("   - similarity: %d for sentence: %s" % (score, sentence))
                            if score == 1000:                                
                                print("... seems like found perfect match, ignoring the rest")
                                break
                            
                    for best in sorted(score_dict.items(), reverse=True):
                        if best[0] > 90:
                            command = best[1][0]  # here might be some randomness
                            print("The best matching command is '%s', executing: %s" % (command['name'], command['exec']))
                            subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['ack']), invocation_ctx, hyp_str]).communicate()
                            subprocess.Popen([os.path.join(os.getcwd(), command['exec']), invocation_ctx, command['name']]).communicate()
                            subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['exit']), invocation_ctx, hyp_str])
                            invocation_ctx = None
                            matched = True
                        break  # take only the first which should be the best

                    if not matched:
                        print("... not matched, ignoring")
                        subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['noop']), invocation_ctx, hyp_str]).communicate()
                        subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['exit']), invocation_ctx, hyp_str])
                        invocation_ctx = None

            decoder.start_utt()
    continue
