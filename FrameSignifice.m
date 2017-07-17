
function [s]=getFVSamples(fishsif, m)
dbg=1;
%if dbg
    %Thumbnails = 'C:\Users\Nandeep\Documents\Prasanna\thumbfiles';
    n_frame=500;
    %m=350;
    %x = getVideoSignature(Thumbnails, n_frame);
  load('C:\Users\Nandeep\Documents\Prasanna\fishsif.mat');
    x=fishsif;
   
%end 
 
% var: 
[n, kd]=size(x);
% compute frame significance value
fs = zeros(1,n); fs(2:end) = diag(pdist2(x(1:end-1,:), x(2:end, :)));
 m=20;
cfs = cumsum(fs);
step_size = sum(fs)/(m-1); 
s(1) = 1; % always select the first frame. 
% subsequence frames were uniformly sampled from cumulative fs function
for k=1:m-1
    offs = find(cfs>=step_size*k);
    s(k+1) = offs(1);
end
figure;
plot(fs);hold on; grid on;
figure;
plot(cfs, '-r');
return;
