#!/bin/bash

###wig2BigWigLiftOver

DIR=wig2BigWigLiftOver
FILE=wigToBigWig
HG18=hg18.chrom.sizes
FILE1=bigWigToBedGraph
FILE2=hg18ToHg19.over.chain.gz
FILE3=liftOver
HG19=hg19.chrom.sizes
FILE4=bedGraphToBigWig 

BIGWIG=$(pwd)/$1
echo Proccesing file:
echo $BIGWIG

#check if working folder exist, if not, create

if [ ! -d ~/$DIR ]
then
mkdir ~/$DIR
fi

cd ~/$DIR

#check if wigToBigWig file exists, if not, download from http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/wigToBigWig

if [ ! -f $FILE ]
then
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/wigToBigWig
fi

chmod 755 ./wigToBigWig

#check if hg18.chrom.sizes file exists, if not, download from https://genome.ucsc.edu/goldenpath/help/hg18.chrom.sizes

if [ ! -f $HG18 ]
then
wget https://genome.ucsc.edu/goldenpath/help/hg18.chrom.sizes
fi

./wigToBigWig $1 hg18.chrom.sizes out.bw -clip

#check if bigWigToBedGraph file exists, if not, download from http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/bigWigToBedGraph

if [ ! -f $FILE1 ]
then
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/bigWigToBedGraph
fi

chmod 755 ./bigWigToBedGraph

./bigWigToBedGraph $BIGWIG out.bedGraph


#check if hg18ToHg19.over.chain.gz file exists, if not, download from http://hgdownload.cse.ucsc.edu/goldenpath/hg18/liftOver/

if [ ! -f $FILE2 ]
then
wget http://hgdownload.cse.ucsc.edu/goldenpath/hg18/liftOver/hg18ToHg19.over.chain.gz
fi

gunzip hg18ToHg19.over.chain.gz

#check if liftOver file exists, if not, download from http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/liftOver

if [ ! -f $FILE3 ]
then
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/liftOver
fi

chmod 755 ./liftOver

./liftOver -bedPlus=4 out.bedGraph hg18ToHg19.over.chain out.bedGraph.hg19 unMapped 

sort -k1,1 -k2,2n out.bedGraph.hg19 > out.bedGraph.hg19.sort

#check if hg19.chrom.sizes file exists, if not, download from https://genome.ucsc.edu/goldenpath/help/hg19.chrom.sizes

if [ ! -f $HG19 ]
then
wget https://genome.ucsc.edu/goldenpath/help/hg19.chrom.sizes
fi


#check if bedGraphToBigWig file exists, if not, download from http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/bedGraphToBigWig

if [ ! -f $FILE4 ]
then
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v287/bedGraphToBigWig
fi

chmod 755 ./bedGraphToBigWig

./bedGraphToBigWig out.bedGraph.hg19.sort hg19.chrom.sizes $BIGWIG.hg19

rm out.bedGraph
rm out.bedGraph.hg19
rm out.bedGraph.hg19.sort
