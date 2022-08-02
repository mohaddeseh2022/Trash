function [nitchcount,Ma1,Ma2,Ma3,inSpC,inSpCRnd,Indp,IndpRnd,SpC,SpCRnd,count,endofu]=FitSh1(Sbuffer,SRnd,popSize,knum,jnum,sig,BlockValue,rnd,trainD,Sflag)
S=load('temp_global_parallel');
RAND_END=S.RAND_END;
Ma1=0;
Ma2=0;
Ma3=0;
SpC{50}=[];
SpCRnd{50}=[];
inSpC{50,1000}=[];
inSpCRnd{50,1000}=[];
buffe1{50}=[];
Indp{5000}=[];
IndpRnd{5000}=[];
inSpC{1}{1}=0; %dummy
inSpCRnd{1}{1}=0; %dummy
SpC{1}=Sbuffer{1};
buffe1{1}=SpC{1};
SpCRnd{1}=SRnd{1};
last=1;
endofu=1;
Indp{1}=0;
IndpRnd{1}=0;
cri=0;
preC1=0;

t=1;
nitchcount=zeros(1,popSize);
%savedj=zeros(1,knum);
count=zeros(1,knum);
buffer2{20,popSize}=[];
buffer3{20,20}=[];
buffer4{20,20}=[];
buffer1{20,knum}=[];
varnumber = size(trainD,2)-1;
Y = trainD(:,varnumber+1);
[p1,p2]=size(trainD);
%trnD= trainD(1:20:p1,:); %5
%trnD=trainD;
for i=2:popSize
    p = randperm(p1,floor(p1));
    trnD= trainD(p,:);
    buffer2{jnum}{i}=Sbuffer{i};
    if jnum>1
        [buffer2,~]=CalccoefficientFinal(BlockValue,jnum,i,buffer2);
        Sbuffer{i}=buffer2{jnum}{i};
    end
    [ReSbufferi, ~]=run_verComb(buffer2{jnum}{i},1,trnD,rnd{i},RAND_END);
    premax=0;
    premin=100000;
    flag=0;
    flag2=0;
    u=1;
    while u<=endofu
        buffer1{jnum}{u}=SpC{u};
        if jnum>1
            [buffer1,~]=CalccoefficientFinal(BlockValue,jnum,u,buffer1);
        end
        [ReSpCu, ~]=run_verComb(buffer1{jnum}{u},1,trnD,rnd{u},RAND_END);
        
        diu=abs(corr(ReSbufferi,ReSpCu)); %distcorr
        
        if endofu<=knum
            if (diu>sig && Sflag==1)
                if (diu>premax && Sflag==1)
                    savedu=u;
                    premax=diu;
                end
                flag=1;
            end
        end
        u=u+1;
    end
    if flag==1
        count(savedu)=count(savedu)+1;
        inSpC{savedu}{count(savedu)}=Sbuffer{i};
        inSpCRnd{savedu}{count(savedu)}=SRnd{i};
    end
    
    if endofu<knum
        if (flag==0 && Sflag==1)
            NanT=isnan(diu);
%             if jnum==1
%                 A=0.7; %sig-0.4;     %0.1
%             else
%                 A=0.5;
%             end
            
            
%             if ( endofu==knum ||NanT==1) %( endofu==knum || (diu<sig && diu>sig-A)||NanT==1) 
%                 endof=endofu;
%                 Indp{t}=Sbuffer{i};
%                 IndpRnd{t}=SRnd{i};
%                 t=t+1;
%                 
%             end
            
            if  (endofu<knum && diu<sig && NanT==0) %(endofu<knum && diu<sig-A && NanT==0) 
                endofu=endofu+1;
                last=last+1;
                SpC{last}=Sbuffer{i};
                SpCRnd{last}=SRnd{i};
            end
            
        end
    end
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

