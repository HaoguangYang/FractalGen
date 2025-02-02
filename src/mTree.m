function [methodinfo,structs,enuminfo,ThunkLibName]=mTree
%MTREE Create structures to define interfaces found in 'tree'.

%This function was generated by loadlibrary.m parser version  on Sun Jun 28 12:10:17 2015
%perl options:'tree.i -outfile=mTree.m -thunkfile=Tree_thunk_pcwin64.c -header=tree.h'
ival={cell(1,0)}; % change 0 to the actual number of functions to preallocate the data.
structs=[];enuminfo=[];fcnNum=1;
fcns=struct('name',ival,'calltype',ival,'LHS',ival,'RHS',ival,'alias',ival,'thunkname', ival);
MfilePath=fileparts(mfilename('fullpath'));
ThunkLibName=fullfile(MfilePath,'Tree_thunk_pcwin64');
% void tree ( int *, float *, float *, float *); 
fcns.thunkname{fcnNum}='voidvoidPtrvoidPtrvoidPtrvoidPtrThunk';fcns.name{fcnNum}='tree'; fcns.calltype{fcnNum}='Thunk'; fcns.LHS{fcnNum}=[]; fcns.RHS{fcnNum}={'int32Ptr', 'singlePtr', 'singlePtr', 'singlePtr'};fcnNum=fcnNum+1;
methodinfo=fcns;