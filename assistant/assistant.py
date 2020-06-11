# -*- coding: utf-8 -*-

"""
An attempt to build continues voice recognition and commands execution

Based on:
 - https://stackoverflow.com/questions/38090440/running-different-commands-with-different-words-in-pocketsphinx
 - https://stackoverflow.com/questions/25394329/python-voice-recognition-library-always-listen
 - https://github.com/cmusphinx/pocketsphinx/blob/master/swig/python/test/continuous_test.py
 - https://github.com/cmusphinx/pocketsphinx/blob/master/swig/python/test/decoder_test.py
 - https://thenewstack.io/off-the-shelf-hacker-open-source-voice-recognition-without-a-net/
API:
 - https://cmusphinx.github.io/doc/python/pocketsphinx.pocketsphinx.Decoder-class.html
Calculating sentences similarity by using Levenshtein hinted by :
 - https://towardsdatascience.com/calculating-string-similarity-in-python-276e18a7d33a
"""

from collections import defaultdict
from pocketsphinx.pocketsphinx import Decoder
import os
import pyaudio
import Levenshtein
import logging
import logging.handlers
import sdnotify
import subprocess
import sys
import time
import yaml



def main():
    """ A main method to that does simple matching of sentences and executes scripts
    """

    notifier = sdnotify.SystemdNotifier()

    # Load config first
    config_file = open(os.path.join(os.getcwd(), 'config.yaml'), 'r')
    config = yaml.load(config_file)

    interaction_timeout = int(config['interaction_timeout'])

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

    invocation_ctx = None
    in_speech_bf = False

    # Run some initialization scripts for terminal displays
    subprocess.Popen([os.path.join(os.getcwd(), config['init_exec'])]).communicate()

    decoder.start_utt()
    notifier.notify("READY=1")
    
    interaction_time = None

    while True:
        notifier.notify("WATCHDOG=1")
        buf = stream.read(1024, exception_on_overflow = False)
        if buf:
            decoder.process_raw(buf, False, False)
        else:
            logging.error("Unable to get audio, exiting")
            break

        hyp = decoder.hyp()
        # seg = decoder.seg()
        hyp_str = hyp.hypstr.lower() if hyp else None
        now_in_speech = decoder.get_in_speech()

        if now_in_speech != in_speech_bf:
            in_speech_bf = now_in_speech
            if not in_speech_bf:
                decoder.end_utt()
                if hyp_str:
                    logging.info("Heard: '%s' while being in '%s' context (score: %d, confidence: %d -> in log scale %d)" %
                                 (hyp_str, invocation_ctx, hyp.best_score, logmath.exp(hyp.prob), hyp.prob))

                    if not invocation_ctx:
                        if hyp_str in invocations:
                            logging.info("Matched invocation: '%s'" % hyp_str) 
                            invocation_ctx = hyp_str
                            subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['enter']),
                                             invocations[invocation_ctx]['voice_params'], invocation_ctx, hyp_str]).communicate()
                            interaction_time = time.time()
                        else:
                            logging.debug('Unknown invocation or wrongly heard, silently ignoring')
                    else:
                        matched = False
                        score_dict = defaultdict(list)

                        commands = invocations[invocation_ctx]['commands']
                        for command in commands:
                            logging.info("- command: '%s':" % command['name'])
                            for sentence in command['sentence']:
                                score = calc_similarity(command, sentence.lower(), hyp_str)
                                score_dict[score].append(command)
                                logging.debug("   - similarity: %d for sentence: %s" % (score, sentence))
                                if score == 1000:
                                    logging.debug("... seems like found perfect match, ignoring the rest")
                                    break

                        for best in sorted(score_dict.items(), reverse=True):
                            if best[0] > 90:
                                command = best[1][0]  # here might be some randomness
                                logging.info("The best matching command is '%s', executing: %s" % (command['name'], command['exec']))
                                subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['ack']),
                                                 invocations[invocation_ctx]['voice_params'], invocation_ctx, hyp_str]).communicate()
                                subprocess.Popen([os.path.join(os.getcwd(), command['exec']),
                                                 invocations[invocation_ctx]['voice_params'], invocation_ctx, command['name']]).communicate()
                                subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['exit']),
                                                 invocations[invocation_ctx]['voice_params'], invocation_ctx, hyp_str])
                                invocation_ctx = None
                                matched = True
                            break  # take only the first which should be the best

                        if not matched:
                            logging.info("... not matched, ignoring")
                            subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['noop']),
                                              invocations[invocation_ctx]['voice_params'], invocation_ctx, hyp_str]).communicate()

                decoder.start_utt()

        if invocation_ctx and interaction_time and time.time() > interaction_time + interaction_timeout:
            logging.info("The invocation context has just timed out, returning to listen for invocation word.")
            subprocess.Popen([os.path.join(os.getcwd(), invocations[invocation_ctx]['exit']),
                              invocations[invocation_ctx]['voice_params'], invocation_ctx])
            invocation_ctx = None
            interaction_time = None


def calc_similarity(command, sentence, hyp_str):
    """ The function to calculate similarity of provided hyp_str against reference sentence

    Args:
        command (dict):     A command that contains matching parameters
        sentence (string):  A sentences from command above to compare against
        hyp_str (string):   A heard sentence to compare with sentence above

    Returns:
        int: the score how much the sentence is similar to reference sentence, 0 means no similarity whatsoever
    """
    if sentence == hyp_str:
        return 1000
    score = 100 - Levenshtein.distance(sentence, hyp_str)
    shoulds = command['should']
    musts = command['must']
    must_nots = command['must_not']

    hyp_words = hyp_str.split()
    if must_nots:
        for must_not in must_nots:
            if must_not in hyp_words:
                score = 0
                break
        if score == 0:
            return 0

    if musts:
        for must in musts:
            if must not in hyp_words:
                score = 0
                break
        if score == 0:
            return 0

    if shoulds:
        for should in shoulds:
            if should in hyp_words:
                score *= 1.2
            else:
                score *= 0.8
    return score


def init_logging():
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    handler = logging.StreamHandler(sys.stdout)
    logger.addHandler(handler)

    log_address = '/var/run/syslog' if sys.platform == 'darwin' else '/dev/log'
    formatter = logging.Formatter('EPaper: %(message)s')
    handler = logging.handlers.SysLogHandler(address=log_address)
    handler.setFormatter(formatter)


if __name__ == '__main__':
    init_logging()
    try:
        main()
    except Exception as e:
        logging.exception(e)
        raise

