function txt_slove(file_name)

Setup;
file_name=strcat('/home/xhzhou/inhouse/mat/',file_name);
parfor i=1:22
   txt_read(file_name,i);
end

end
