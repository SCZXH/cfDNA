function CRAG_enrichment(data_name)
current_path=pwd;
lo=strfind(current_path,'/');
parent_path=current_path(1,1:(lo(end)-1));
addpath(genpath(parent_path));



Hotspot_TSS(data_name);

%%Plot the hotspot pattern around CTCF. The output was saved in
%%'result_n/' as 'CTCF_plot.fig/pdf'
Hotspot_CTCF(data_name);

%%%%%%%%%Calculate the overlap number of hotspots for each chromHMM, which
%%%%%%%would laters used to chromHMM enrichment
%%%%%The output was saved in 'result_n/' as 'enri.mat'
Hotspot_enrichment(data_name);

%%%%%%%%%Calculate the overlap number of random hotspots for each chromHMM, which
%%%%%%%would laters used to chromHMM enrichment
%%%%%The output was saved in 'result_n/' as 'enri_randm.mat'
Hotspot_rand_enrichment(data_name);

%%%%%%%Use fisher exact test to test do the chromHMM enrichment, based on
%%%%%%%the overlap value of the hotspots with each chromHMM, and the overlap value of the random hotspots with each chromHMM
%%%%%%%The output was saved in 'result_n/' as 'Enrichment_plot.fig'
Hotspot_enrichment_fisher(data_name);



end