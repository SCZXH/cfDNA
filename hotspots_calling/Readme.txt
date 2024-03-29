(1)The code is used to call hotspots based on cfDNA Fragmentation.
(2)To run the pipeline, you should provide the bam file for the cfDNA data and the index file for the bam file.
(3)To run the pipeline, both python (python 2.7, with pysam was installed) and matlab should be installed.
(4)There are two steps for our pipeline:
   (I) Run the script 'bam_read.py' to read the fragment and write it to txt files. There are two arguments for the script.
       -in: the name for the bamfile.
       -out: the folder name for output file.
       a demo to run the function is shown as follow:
       python bam_read.py -in /Users/zhoe7h/Desktop/R/BH01.filter.bam -out BH01
       After running this command, the fragment information for each chromosome (chr 1 - chr 22) were written to chrid.txt in 'BH01'
   (II) Run the matlab function 'CRAG.m' to call hotspots and do enrichment analysis for the hotspots using TSS, CTCF and chromHMM states. There are also two arguments for the script.
        data_name: The folder name for the fragmentation information, i.e. BH01.
        peak_type: 1 - call hotspots using IFS. 2 - call hotspots using GC bias corrected IFS.
        a demo to run the function is shown as follow (two ways):
        (A) Run it using matlab software directly: CRAG('BH01',1)
        (B) Run it using bash command: matlab -nodisplay -r 'CRAG BH01 1; exit;'
         After running this command, the hotspots (peak_all.mat, peaks.bed), fragmentation pattern around hotspots (IFS_plot.fig, IFS_plot.pdf), enrichment patterns (TSS_plot.fig, TSS_plot.pdf, CTCF_plot.fig, CTCF_plot.pdf, Enrichment_plot.fig,Enrichment_plot.pdf) could be obtained (in file path: BH01/result_n/).
(5)We Recommended to use high-quality autosomal reads. In our manuiscript, the fragments should be with both ends uniquely mapped, either ends with mapping quality score of 30 or greater, properly paired, and not a PCR duplicate. To obtain the high quanlity reads, you can use the command (samtools) as follow:
samtools view -bh -F 3852 -f 3 -q 30 bamfileName.bam > out.bam
Also, if you want to call hotspots for several chrommsomes (not the whole genome), you can provide the bam file with the corresponding chromosomes.

(6)#### Options for hotspot calling
```
-global p value cut-off: argument: 'global_p', a positive number between 0 to 1 ([0,1]). default: 0.00001. 
-local p value cut-off: argument: 'local_p', a positive number between 0 to 1 ([0,1]).default: 0.00001
-fdr cut-off:argument: 'fdr', a positive number between 0 to 1 ([0,1]). default: 0.01
-hotspot distance for merging: argument: 'distance', a positive integer ([1,inf)). default: 200
-whether or not do enrichment for the hotspots:  argument: 'enrichment', 0 or 1. default: 1. 
```
CRAG('result_dir',1,'local_p',0.001,'distance',300,'enrichment',0)
--Call hotspots in 'result_dir', using IFS without GC-bias correction, with global p value cut-off = 0.00001, local p value cut-off = 0.001 and fdr cut-off = 0.01. After the significant regions were detected, the regions nearby (with distance less than 300bp) were merged. And the pipeline will produce four files (two hotspot files: peak_all.mat, peaks.bed and two files of the fragmentation pattern around hotspots (IFS_plot.fig, IFS_plot.pdf)) in result_dir/result/n.

(7) The pipeline works in both Linux (mac os) and Windows. In windows, as the file path names for Windows and Linux is different, you should change the path name fromat in the code.
 
