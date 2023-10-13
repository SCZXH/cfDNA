% addpath(genpath(pwd));

current_path=pwd;
lo=strfind(current_path,'/');
parent_path=current_path(1,1:(lo(end)-1));
addpath(genpath(parent_path));
