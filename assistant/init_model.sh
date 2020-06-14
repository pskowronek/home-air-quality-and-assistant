#!/bin/bash

# A script to:
# - upload keyphrase.list to pocketsphinx project (lmtool) to build model for offline use
# - download US English acoustic model and extract it to model/hmm"
# Basically, it (re)generates lexical & language models for words in keyphrases.list for offline use
# and downloads acoustic models for US English.


HMM_DEB="http://ftp.de.debian.org/debian/pool/main/p/pocketsphinx/pocketsphinx-hmm-en-hub4wsj_0.8-5_all.deb"
PATH_IN_DEB="/usr/share/pocketsphinx/model/hmm/en_US/hub4wsj_sc_8k"
LM_TOOL="http://www.speech.cs.cmu.edu/cgi-bin/tools/lmtool/run"
cd "$(dirname "$0")" 

echo "This script is about to (re)initialize lex & lang + acoustic model:"
echo " - upload keyphrase.list to pocketsphinx project (lmtool) to build model for offline use"
echo " - download US English acoustic model and extract it to model/hmm"
echo "Please make sure you have update keyphrase.list updated to contain all the words from config.yml"
echo ""
echo "If you prefer to do it manually then go to http://www.speech.cs.cmu.edu/tools/lmtool-new.html,"
echo "and upload keyphrase.list file. After that you need to download generated TGZ and extract it "
echo "into model folder. Afterwards you need to remember to update config.yaml to reflect correct names for 'lm' and 'dic'."
echo "Then you need to download deb file with acoustic model from:"
echo "$HMM_DEB"
echo "and extract contents of this DEB file from this path: $PATH_IN_DEB to model/hmm."
echo "You may also install this DEB package, but then you need to provide correct path in config.yaml."
echo ""

read -p "Do you want to contiune with the automatic procedure? (Y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 0
fi

tmpDir=$(mktemp -d -t ci-XXXXXXXXXX)

echo "Uploading invocation.list & keyphrase.list to www.speech.cs.cmu.edu..."
tmpList=$(mktemp $tmpDir/allkeyphrase.XXXXXX.list) 
cat invocation.list >> $tmpList
echo "" >> $tmpList
cat keyphrase.list >> $tmpList

URL=$(curl -F 'formtype=simple' -F "corpus=@$tmpList" -s -L "$LM_TOOL" | grep -o 'a href="[^\"]*' | grep -Eo '(http|https)://[^\"]+')

# ' <- to fix mcedit syntax highlighting

echo "The generated model file is available here: $URL"

tmpTgz=$(mktemp $tmpDir/assistant-model.XXXXXX.tgz)
tmpDeb=$(mktemp $tmpDir/assistant-acoustic.XXXXXX.deb)
tmpLmTool=$tmpDir/output
tmpDebExt=$tmpDir/deb_extracted
rm -rf model
mkdir -p model/hmm

echo "Going to download and extract TGZ to model directory to $tmpLmTool..."
curl $URL --output $tmpTgz

mkdir $tmpDir/output
tar zxvf $tmpTgz -C $tmpLmTool

echo "Going to rename all the files to lmtool.* and move them to model directory..."
for file in $tmpLmTool/* ; do filename="${file%.*}" ; extension="${file##*.}" ; mv "$file" "model/lmtool.${extension}" ; done

echo "Going to download acoustic model from $HMM_DEB to $tmpDeb..."
curl $HMM_DEB --output $tmpDeb
cd $tmpDir
ar x $tmpDeb
mkdir $tmpDebExt
tar xvf data.tar.xz -C $tmpDebExt
cd -

echo "Going to move acoustic model to model/hmm..."
mv $tmpDebExt$PATH_IN_DEB/* model/hmm
rm $tmpDeb

echo "Done"
