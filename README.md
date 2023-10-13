This package includes a tool for calling hotspots using urinary cfDNA sequencing data, extracting fragment patterns in hotspot regions (IFS), building a cancer diagnostic model (specifically, a bladder cancer diagnostic model) with machine learning, and performing cross-validation for model evaluation.

The hotspot calling package is similar to a tool we previously developed called CRAG (https://github.com/epifluidlab/CRAG). CRAG is used to identify hotspot regions in the genome using cfDNA sequencing data from plasma. In this case, to identify hotspots in urinary cfDNA sequencing data and locate regions with smaller IFS in the genome, we use a Poisson distribution test instead of the non-negative binomial test used in CRAG. Additionally, the default p-values and FDR values differ between the two methods.

As the frameworks of the two methods are quite similar, some of the following section of text is copied from https://github.com/epifluidlab/CRAG.

Install

git clone --recursive https://github.com/SCZXH/cfDNA.git

cd CRAG
pip install pysam
Download the test bam file and the required GC and mappability files
cd Basic_info
wget -c https://zenodo.org/record/3928546/files/GC.zip
wget -c https://zenodo.org/record/3928546/files/mappability.zip
wget -c https://zenodo.org/record/3928546/files/chrm_state.zip
unzip GC.zip
unzip mappability.zip
unzip chrm_state.zip
cd ../hotspots_calling
wget -c https://zenodo.org/record/3928546/files/BH01.chr22.bam
wget -c https://zenodo.org/record/3928546/files/BH01.chr22.bam.bai
Run the example test file at your bash command line to call hotspot. (link the Basic_info/ into your current working directory)
ln -s ../Basic_info
python bam_read.py -in BH01.chr22.bam -out test_dir
matlab -nodisplay -r 'CRAG test_dir 1; exit;' 	
You will get a lot of WARNING messages about no reads in chromosome since we only provided reads in chr22 at the test bam file.

You need at least 10 GB of memory to finish the test example. At our server, it costs about 10 mins at CentOS 7 with 10Gb memory and one CPU core: Intel(R) Xeon(R) CPU E5-2695 v3 @ 2.30GHz

This should produce the following files (inside test_dir/result_n/): * the hotspots (peak_all.mat, peaks.bed), * fragmentation pattern around hotspots (IFS_plot.fig, IFS_plot.pdf) * enrichment patterns (TSS_plot.fig, TSS_plot.pdf, CTCF_plot.fig, CTCF_plot.pdf, Enrichment_plot.fig, Enrichment_plot.pdf)

Installation
Prerequisites
Linux, Mac OSX, and Windows (with at least 10Gb memory for each CPU core)
Matlab 2019b
python 2.7
pysam 0.12.0.1 or above
samtools 1.9
required files
Indexed Bam file (paired-end whole-genome sequencing, recommends having at least 200 million fragments in autosomes after the samtools filtering step. If you want to call hotspots for several chrommsomes (not the whole autosome), you can provide the bam file only with the corresponding chromosomes.)
Basic_info directory Always link the Basic_info/ under your current working directory (an example is showed in Quick Start part)
GC content files (provided in zenodo.org for hg19/GRch37, download it under Basic_info directory and unzip it)
Mappability files (provided in zenodo.org for hg19/GRch37, download it under Basic_info directory and unzip it)
ChromHMM state files (provided in zenodo.org for hg19/GRch37, download it under Basic_info directory and unzip it)
Usage
Sample pre-processing and read
samtools view -bh -f 3 -F 3852 -q 30 input.bam > output.filtered.bam
samtools index output.filtered.bam
python bam_read.py -in output.filtered.bam -out result_dir


Hotspot calling
Two modes for the hotspot calling: 1 - call hotspots using IFS. 2 - call hotspots using GC bias corrected IFS. There are two choices to run the tool:

Run it directly at matlab (all the following code examples will follow this style)

CRAG('result_dir',1)
Run it at linux bash with matlab installed
matlab -nodisplay -r 'CRAG result_dir 1; exit;'
Options for hotspot calling
fdr cut-off:argument: 'fdr', a positive number between 0 to 1. default: 0.05
hotspot distance for merging: argument: 'distance', a positive integer. default: 200
whether or not do enrichment for the hotspots: argument: 'enrichment', 0 or 1. default: 1.
Example code with option specified: CRAG('result_dir',1,'distance',300,'enrichment',0)

This command will call hotspots in 'result_dir', using IFS without GC-bias correction, with fdr cut-off = 0.01. After the significant regions were detected, the regions nearby (with distance less than 300bp) were merged. And the pipeline will produce four files (two hotspot files: hotspots.bed and hotspots.mat and two files of the fragmentation pattern around hotspots (IFS_plot.fig, IFS_plot.pdf))in result_dir/result/n.


Cancer vs. healthy classification
You should run the script 'bam_read.py' to read the fragment for all the samples and write it to text files. We recommend putting all the samples from the same data set into the same folder.
cd cfDNA/classification


Obtain IFS score in each sample. 

IFS_write('../C309')

Get IFS matrix for each hotspot in each sample: get the hotspots' IFS of each sample and merge all the samples as a matrix and output the matrix:

Function:
 IFS_matrix_obtain.m
 
Parameters:
file_list:the name of an excel file (include the Suffix name), or a variable include all the the files.

input_path: The path of all the files, i.e. ./bladder

out_name: The output file name (matrix file name)
peak_type： Peak_type==1: IFS. Peak_type==2: GC bias corrected IFS.
peak_file: The sample name for the hotspots to obtain the IFS score.
For example, when we do obtain the IFS matrix of bladder samples and healthy samples, For all samples (bladder cancer samples and healthy samples), we want to get the IFS score of both the bladder hotspots and healthy hotspots. If we have the hotspots of bladder samples in Bladder/result_n/ and the hotspots of healthy samples in healthy/result_n/, we could run:
 IFS_matrix_obtain('AllSamples.xlsx','bladder','../All_matrix_IFS.mat',1,'Bladder','healthy').


Classification of all the samples using the IFS matrix for the samples, using 10 times 10-fold cross validation:
classification_CV.m
%%input_matrix: i.e.All_matrix_IFS.mat
%%the file name for the output results: i.e. class_result.mat

Parameters:
file_list:the name of an excel file (include the Suffix name), or a variable include all the the files.

input_path: The path of all the files, i.e. ./bladder

For example:
classification_CV('All_matrix_IFS.mat','class_result.mat');



License
For academic research, please refer to MIT license.
For commerical usage, please contact the authors.

Contact
Xionghui Zhou zhouxionghui6@gmail.com
