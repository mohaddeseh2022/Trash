function [OUTBuff,OUTCoeff,j,MShD,Sp0,MShDprime,BlockValue,BlockRnd]=MainFunc(popSize,buffer,rnd,gen,trainD,validD,testD,paramet,~,~,Orgendofu,alpha)
S=load('temp_global_parallel');
icount=0;
FinalRing2=0;
popSize1=popSize;
FSET_END=S.FSET_END;
RAND_END=S.RAND_END;
Var_START=S.Var_START;
BLOCK_START=S.BLOCK_START;
Scount=popSize;
varnumber = size(trainD,2)-1;

% persistent M 
% if isempty(M)
%     M=0;
% end
% M=M+1;

[p0,p1,p11,p2,p22,p3,p33,p4,p44]=Standard_Prob(buffer,popSize);
p0bar=p0;
p1bar=p1;
p11bar=p11;
p2bar=p2;
p22bar=p22;
p3bar=p3;
p33bar=p33;
p4bar=p4;
p44bar=p44;
%%%%%%
Sp0bar=p0;
Sp1bar=p1;
Sp11bar=p11;
Sp2bar=p2;
Sp22bar=p22;
Sp3bar=p3;
Sp33bar=p33;
Sp4bar=p4;
Sp44bar=p44;
%%%%%%%%%%
Sp0(1,:)=p0;
Sp1(1, :,:)=p1;
u=0;
for w=1:popSize
    u=u+1;
    Sbuffer{u}=buffer{w};
    Srnd{u}=rnd{w};
end
%%%%%%%%%%%%
SpopSize=popSize;
Sbuf=buffer;
Srn=rnd;
%%%%%%%%%%%


FinalRing=0;

Y = trainD(:,varnumber+1);
BSPlusJ=BLOCK_START+9;
nodesize=zeros(1,10);
BMI=zeros(1,20);
Coeff{20,10}=[];
Coeff1{20,10}=[];
F1Block{20,10}=[];
FBlock{20,10}=[];
BlockValue{20,10}=[];
BlockRnd{20,10}=[];
Block_result{20,10}=[];

for k=1:popSize
    Bbuffer{k}=buffer{k};
    Brnd{k}=rnd{k};
end
%%%%%%%%%%%
SBbuffer=Bbuffer;
SBrnd=Brnd;
%%%%%%%%%%%
preBuffpr{20,50}=[];
[rowsize,colsize]=size(trainD);
Ra = randperm(rowsize,floor(rowsize));
trD= trainD(Ra,:);
[preRe,~] = run_ver3(buffer{popSize},1,trD,rnd{popSize});
premcorind=1;
preBuffpr{1}{premcorind}=buffer{popSize};

for alphcount=1:1
    alphval=1.2;%(0.1)*(10^alphcount);
    clear Nbuffer
    clear Nrnd
p0bar=Sp0bar;
p1bar=Sp1bar;
p11bar=Sp11bar;
p2bar=Sp2bar;
p22bar=Sp22bar;
p3bar=Sp3bar;
p33bar=Sp33bar;
p4bar=Sp4bar;
p44bar=Sp44bar;
buffer=Sbuf;
rnd=Srn;  
Bbuffer=SBbuffer;
Brnd=SBrnd;
Sbuffer=SBbuffer;
Srnd=SBrnd;
popSize=SpopSize;
for j=1:2
    
    clear SigmaCorr
    clear fitind
    clear fit
    clear fit1
    clear savedu
    i = 0;
    tprime=9;
    while i < gen
        
        i=i+1;
        if ((i>1 && j==1) || j>1)
            Ra = randperm(rowsize,floor(rowsize));
            trD= trainD(Ra,:);
        end
        NumberOFJ=j
        NumberOFI=i
        
        clear poprandom
        if ((i>1 && j==1) || (i>0 && j>1))
            clear buffer
            clear rnd
        end
        
        
        if i==1 && j==1
            tprim=0; %tprime;
        end
        % if i==1
        % popSizep=400;
        % else
        % popSizep=floor(400/i);
        % end
        
        if (j==1 && i>1)
%             dummy=1;
%             popSizep=100;
%             poprandomsize=popSize+tprim+floor(popSizep/i);
%             poprandom = initialPopStGP_ver3(poprandomsize-popSize-tprim+1,trainD,1);
       poprandomsize=popSize+tprim;
        elseif (j>1 && i==1)
            tprim=0;
            popSizep=200; %500
            popSize=popSizep;
            poprandom = initialPopStGP_Final(popSizep,trainD,BlockValue,newnum,BSPlusJ,Coeff,j,1);%%10 instead of num %10 instead of 10*(j-1)
        elseif (j>1 && i>1)
            popSizep=200;
            poprandomsize=popSize+tprim+floor(popSizep/i);
            poprandom = initialPopStGP_Final(poprandomsize-popSize-tprim+1,trainD,BlockValue,newnum,BSPlusJ,Coeff,j,1);%%10 instead of num %10 instead of 10*(j-1)
        end
        
       
        % k=1;
        % if i>1
        % for h=savedtprim+savedpopSize:savedtprim+savedpopSize+popSizep
        %     popmodel.indiv(h).value=poprandom.indiv(k).value;
        %     popmodel.indiv(h).rand=poprandom.indiv(k).rand;
        %     k=k+1;
        % end
        % popSize=savedpopSize+popSizep;
        % end
        
        if (i==1 && j>1)
            clear popmodel
            popmodel=poprandom;
            %h=1;
%             for r=popSize+1:popSize+tprim
%             popmodel.indiv{r}.value=sortedpop.indiv(h).value;
%             popmodel.indiv{r}.rand=sortedpop.indiv(h).rand;
%             h=h+1;
%             end
        end
        
        clear popsortmodel
        clear sortedpop
       
        
        if ((i>1 && j==1) || (i>0 && j>1))
            for h=1:popSize+tprim
                buffer{h}=popmodel.indiv(h).value;
                rnd{h}=popmodel.indiv(h).rand;
            end
            r=1;
            for h=popSize+tprim+1:poprandomsize
                buffer{h}=poprandom.indiv(r).value;
                rnd{h}=poprandom.indiv(r).rand;
                r=r+1;
            end
           popSize=poprandomsize-tprim;  
        end
       
        
        %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        popSizeprime=popSize+tprim;
        knum=25;
        sig=0.9; %0.85 for G1
        clear Re
        clear diu
        clear dCor
        sortflag=0;
        Sflag=1;
        
        if (j==1)
            [~,~,~,~,~,~,~,~,~,~,UMI]=MutualInf_ver3(buffer,rnd,popSize+tprim,varnumber,validD,trainD,0,0,0);
        else
            
            [~,~,~,~,~,~,~,~,~,~,UMI]=MutualInf_Final(buffer,rnd,popSize+tprim,varnumber,validD,trainD,0,BlockValue,BSPlusJ,Coeff,j,0,0,Block_result);
        end
        fitnss=UMI;
        
        if (j==1 && i<=1)
            alph=alphval; %alph=0.9999;  
            %[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_method1(buffer,rnd,popSize,varnumber,trainD,fitnss);
            [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1_method1(buffer,rnd,popSize+tprim,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,gen,i,alph,fitnss);
        elseif (j==1 && i>1)
            alph=alphval; %alph=0.85;%0.3 was very bad
            [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_ver3_1_method1(buffer,rnd,popSize+tprim,varnumber,trainD,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,gen,i,alph,fitnss);
        elseif (j~=1 && i<=1)
            BSPlus=BSPlusJ;
            alph=alphval;%alph=0.9999
            p0bar=(1/FSET_END)*ones(1,FSET_END);
            p1bar=(1/BSPlus)*ones(BSPlusJ,FSET_END);
            p11bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,BSPlusJ);
            p2bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END);
            p22bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END,BSPlusJ);
            p3bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END,FSET_END);
            p33bar=(1/BSPlus)*ones(BSPlusJ,FSET_END,FSET_END,FSET_END,BSPlusJ);
            p4bar=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END);
            p44bar=zeros(BSPlusJ,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ);
            p4bar(Var_START:BSPlusJ,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END)=1/(BSPlus-Var_START+1)*ones(BSPlusJ-Var_START+1,FSET_END,FSET_END,FSET_END,FSET_END);
            p44bar(Var_START:BSPlusJ,1:FSET_END,1:FSET_END,1:FSET_END,1:FSET_END,Var_START:BSPlusJ)=1/(BSPlus-Var_START+1)*ones(BSPlusJ-Var_START+1,FSET_END,FSET_END,FSET_END,FSET_END,BSPlusJ-Var_START+1);
       
            %[MI,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final_method1(buffer,rnd,popSize,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,Block_result,fitnss)
            [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1_method1(buffer,rnd,popSize+tprim,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,gen,i,alph,fitnss);
        elseif (j~=1 && i>1)
            alph=alphval; %alph=0.85;%0.3 was very bad
            [~,p0,p1,p11,p2,p22,p3,p33,p4,p44]=prob_Final1_method1(buffer,rnd,popSize+tprim,varnumber,trainD,BlockValue,BSPlusJ,Coeff,j,p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,gen,i,alph,fitnss);
        end
      
        p0bar=p0
        p1bar=p1;
        p11bar=p11;
        p2bar=p2;
        p22bar=p22;
        p3bar=p3;
        p33bar=p33;
        p4bar=p4;
        p44bar=p44;
%         Sp0(i+1,:)=p0;
%         Sp1(i+1, :,:)=p1;

        popSize=200;%500;
        
        clear popmodel
        if j==1
            popmodel = PopEDAGP_ver3(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize,trainD);
        else
            popmodel = PopEDAGP_Final(p0bar,p1bar,p11bar,p2bar,p22bar,p3bar,p33bar,p4bar,p44bar,popSize,trainD,BlockValue,BSPlusJ,Coeff,j);
        end
        
        for k=1:popSize
            buffer{k}=popmodel.indiv(k).value;
            rnd{k}=popmodel.indiv(k).rand;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Buff{j}{k}=buffer{k};
            if j>1
                [Buffp,~]=CalccoefficientFinal(BlockValue,j,k, Buff);
                [Re(:,k), ~]=run_verComb(Buffp{j}{k},1,trD,rnd{k},RAND_END);
            else
                [Re(:,k),~] =run_ver3(Buff{j}{k},1,trD,rnd{k});
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
        end
        
        buffer{k}
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for w=1:popSize
            dCor(w)=abs(corr(Re(:,w),preRe));
        end
        dCor(isnan(dCor))=0;
        
        [S,in]= sort(dCor);
       
        u=Scount;
          
        for w=1:popSize
            %if dCor(w)>0.1
            if w<0.25*popSize;%w<=(i/gen)*(popSize)
                u=u+1;
                Sbuffer{u}=buffer{in(w)};%buffer{w}
                Srnd{u}=rnd{w};            
            end
        end
        popSize=u;
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        clear Nbuffer
        clear Nrnd
        for k=1:popSize
            Nbuffer{k}=Sbuffer{k};
            Nrnd{k}=Srnd{k};
        end
        u=1;%*************************************
        if (i==1 && j==1)      %if i==1  tprim=0; end
            tprim=popSize1;
        elseif (i==1 && j>1)
            tprim=0; %tprim=t;
        elseif (i>1)
            tprim=t
        end
        %*****************************************
        k=popSize+tprim;
        while k>popSize
            Nbuffer{k}=Bbuffer{u};
            Nrnd{k}=Brnd{u};
            u=u+1;
            k=k-1;
        end
        
        if (i==1 && j==1)
            pervMIMax=0;
            pervMIMax2=0;
        end
        fitss=1; %dummy
        if (j==1)
            [MI1,popMI,popvalidMI,popsortmodel,sortedpop,FinalRing,pervMIMax,pervMIMax2,t,tt,~]=MutualInf_ver3(Nbuffer,Nrnd,popSize+tprim,varnumber,validD,trainD,fitss,pervMIMax,pervMIMax2);
        else
            
            [MI1,popMI,popvalidMI,popsortmodel,sortedpop,FinalRing,pervMIMax,pervMIMax2,t,tt,~]=MutualInf_Final(Nbuffer,Nrnd,popSize+tprim,varnumber,validD,trainD,fitss,BlockValue,BSPlusJ,Coeff,j,pervMIMax,pervMIMax2,Block_result);
        end
        tprim=t;
        clear Bbuffer
        clear Brnd
        if t==0
            disp('tErrrrrrrrrrrrrrrrrrrrrrrrrrrr')
        end
        for h=1:t
            Bbuffer{h}=sortedpop.indiv(h).value;
            Brnd{h}=sortedpop.indiv(h).rand;
        end
        clear buffer
        clear rnd
        
        for h=1:tt
            buffer{h}=popsortmodel.indiv(h).value;
            rnd{h}=popsortmodel.indiv(h).rand;
        end
        
        BMI(j)=MI1(1);
        if (j>1 && i>7)
            if abs(BMI(j)-BMI(j-1))<=abs(0.01*BMI(j-1)) %0.03 is efficient for G1 , G2
                FinalRing=1;
                break;
            end
        end
        
        
        sum1=0;
        sum2=0;
        sum3=0;
        num1=popSize;
        for k=1:num1
            sum1=sum1+popMI(k);
            sum2=sum2+(popMI(k).^2);
            sum3=sum3+popvalidMI(k);
        end
        MImean(i)=sum1/num1;
        MIvalidmean(i)=sum3/num1;
        EX2=sum2/num1;
        MIvar(i)=EX2-((MImean(i)).^2);
        MImax(i)=MI1(1);
        disp('************THE BEST FITNESS IN THIS GENERATION=')
        disp(MI1(1))
        MShD(alphcount,gen*(j-1)+i)=mean(MI1);
        MShDprime(alphcount,gen*(j-1)+i)=MImean(i);
%         labBarrier
%         for srcWkrIdx=1:12
%         if labindex == srcWkrIdx
%             data = MI1(1);
%             shared_data = labBroadcast(srcWkrIdx,data);
%         else
%             shared_data(srcWkrIdx) = labBroadcast(srcWkrIdx);
%         end
%         end
% MShD(gen*(j-1)+i)=mean(shared_data);
        
        if j>1
            [Sbuffer,Srnd,popS,~]=EliminateSimilar(Sbuffer,Srnd,popSize,trainD,validD,BlockValue,1,1,j,2); %i as the last input
        else
            [Sbuffer,Srnd,popS,~]=EliminateSimilar(Sbuffer,Srnd,popSize,trainD,validD,1,1,1,j,2);
        end
        popSize=popS;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for k=1:popSize
            popmodel.indiv(k).value=Sbuffer{k};
            popmodel.indiv(k).rand=Srnd{k};
        end
        u=1;
        savedtprim=tprim;
        savedpopSize=popSize;
        k=popSize+tprim;
        while k>popSize
            popmodel.indiv(k).value=Bbuffer{u};
            popmodel.indiv(k).rand=Brnd{u};
            u=u+1;
            k=k-1;
        end
        
        if j==1
            i
            sortedpop
            [testdataMI ] = TestMI_ver3( sortedpop.indiv(1).value,sortedpop.indiv(1).rand,varnumber,testD );
        else
            [testdataMI ] = TestMI_Final( sortedpop.indiv(1).value,sortedpop.indiv(1).rand,varnumber,testD,BlockValue,BSPlusJ,Coeff,j);
        end
        
        TestMI(i)=testdataMI;
        
    end
    
    %(((((((((((((((((((((inja))))))))))))))))))))))))
    
    % plot_Final(MImean,MIvalidmean,MIvar,MImax,i,j)
    % plot_Test(TestMI,i,j)
    
    if t>10
        num=10;
    else
        num=t;
    end
    
    
    num=1;
    for k=1:num
        BlockValue{j}{k}=Bbuffer{k};
        BlockRnd{j}{k}=Brnd{k};
    end
    
    newnum=num;
    if j==1
        for k=1:num
            [res,~]=run_ver3(BlockValue{j}{k},1,trainD,BlockRnd{j}{k});
            [res1,~]=run_ver3(BlockValue{j}{k},1,testD,BlockRnd{j}{k});
            Block_result{j}{k}=res;
            Block_result1{j}{k}=res1;
        end
    else
        for k=1:num
            [FBlock,nodesize(k)]=CalccoefficientFinal(BlockValue,j,k,BlockValue);
            F1Block{j}{k}=FBlock{j}{k};
            Coeff1{j}{k}=BlockRnd{j}{k};
            [res, ~]=run_verComb(F1Block{j}{k},1,trainD,Coeff1{j}{k},RAND_END);
            [res1, ~]=run_verComb(F1Block{j}{k},1,testD,Coeff1{j}{k},RAND_END);
            
            Block_result{j}{k}=res;
            Block_result1{j}{k}=res1;
        end
    end
    SBlock_result=Block_result{j}{1};
    SBlock_result1=Block_result1{j}{1};
    for k=1:num
        Coeff{j}{k}=BlockRnd{j}{k};
    end
    
    BSPlusJ=BLOCK_START+num-1;
    
    CCoeff=Coeff;
    icount=1;
    while icount<=num
        [FBlock,nodesize(icount)]=CalccoefficientFinal(BlockValue,j,icount,BlockValue);
        F1Block{j}{icount}=FBlock{j}{icount};
        Coeff1{j}{icount}=CCoeff{j}{icount};
        icount=icount+1;
    end
    clear OUTBuff
    clear OUTCoeff
    OUTBuff=F1Block{j}{1};
    OUTCoeff=Coeff1{j}{1};
    
    if FinalRing==1;
        OUTBuff=F1Block{j-1}{1};
        OUTCoeff=Coeff1{j-1}{1};
        j=j-1;
        break;
    end
    
    if FinalRing2==1
        OUTBuff=F1Block{j}{1};
        OUTCoeff=Coeff1{j}{1};
        break;
    end
    
    
    
    clear MImean
    clear MIvalidmean
    clear TestMI
    clear MIvar
    clear MImax
    
end

end


