%function [sift fishsif]=getVideoSiftFV(mp4_fname, no_img,indx, w,code,gmm)

 %indx=[3 8 17 33 50 62 79 93 101 109 119];
% clear all;
% clc;
 no_img=2500;
 x=1:no_img;
 indx=downsample(x,5);
 code='1.2';
 w='360';
 mp4_fname='images';
sift=cell(size(indx,2),1);
%kd=16;
%nc=12;
%gmm=[8 16];
gmm=[16 32];
kd=gmm(1);
nc=gmm(2);
path='C:\Users\Nandeep\Documents\Prasanna\images' ;
%path=strcat(path2,mp4_fname,'_',w,'_',code);
%%
c=1;
my_cell=cell(500,1);
for i = 1 :5: no_img
     str = strcat(path,'\image',int2str(i),'.png');      
    img = imread(str);    
    my_cell{c,1}=img;   
    c=c+1;
end 
if (1)
    run('C:\Users\Nandeep\Documents\Prasanna\Thesis\vlfeat-0.9.20\toolbox\vl_setup.m');
end
%load C:\Users\Nandeep\Documents\Prasanna\cdvs_sift_aggregation_test_data;
%load('C:\Users\laksh\Documents\Thesis\cos_pca.mat');

%%
%scaling to 480p
my_cell1=cell(500,1);
numrows=280;
numcols=340;
c=1;
for i=1:5:no_img
    my_cell1{c,1} = imresize(my_cell{c,1},[numrows numcols]);
    c=c+1;
end

load('C:\Users\Nandeep\Documents\Prasanna\Thesis\cos_pca.mat');
load('C:\Users\Nandeep\Documents\Prasanna\Thesis\sift_test.mat');

%%
gmm=[24 32];
kd=gmm(1);
nc=gmm(2);
fishsif=[];
c=1;

peak_thresh=3;
[m1, cov1,pr1] = getgmm1(kd,nc);
for  i=1:5:no_img
    I=single(rgb2gray(my_cell{c,1}));
    [f d] = vl_sift(I,'PeakThresh', peak_thresh);
    d=d';    
    %if (c<(size(indx,2)+1) && (i==indx(c))) %sift generated for frames indicated in indx 
        %sift{c,1}=d;
        c=c+1;
        sifpr=double(d)*Cos(:,1:kd);   
        x=vl_fisher(sifpr',m1,cov1,pr1);
        fishsif=cat(1,fishsif,single(reshape(x,1,numel(x ))));
   % end
    
end
%%
m=20;
[s]=getFVSamples(fishsif, m);
c=2;
s1(1)=s(1);
for i=2:size(s,2)
    if s(i)>s(i-1)
        s1(c)=s(i);
        c=c+1;
    end
end
%%
[n d]=size(fishsif);
%fv=zeros(size(s1,2),d);
c=1;
for i=1:500
    if s1(c)==i
        fv(c,:)=fishsif(i,:);
        c=c+1;
    end
end 
 
[kd,nc]=size(fv);
%[kd,nc]=size(fishsif);
H=zeros(kd,nc);
H1=zeros(kd,nc);
H(find(fv>0))=1;
%H(find(fishsif>0))=1;
[l]=getFrameHashDistance(H,m);
D=pdist2(H,H1,'hamming');
h_dist = sum(D(: ) );



%%

% end