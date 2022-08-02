
%Code written by Mohaddesh Koosha

myFolder = 'C:\Users\kosha\Desktop\TData\G1'; %path to database
filePattern = fullfile(myFolder, '*.xlsx'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
length=10; %length=lenght of the database; i.e. number of files. 
for k = 1:length
    baseFileName = theFiles(k).name;
    fullFileName = fullfile('C:\Users\kosha\Desktop\TData\G1', baseFileName);
    ntimer=2; %number of runs +1
    popSize_num=1;
    pop_base_size=1024;
    for popSizecount=1:1:popSize_num
    popSize=floor(popSizecount*pop_base_size/8);
    for timer=2:ntimer
        clearvars -global -except fileID MfileID
          Dat=xlsread(fullFileName);
          [R1,C1]=size(Dat);

        % Store global variables to be reused in parallel workers
        global ADD SUB MUL DIV FSET_START FSET_END RAND_START Var_START RAND_END BLOCK_START BLOCK_END
        ADD = 1;
        SUB = 2;
        MUL = 3;
        DIV = 4;
        FSET_START = ADD;
        FSET_END = DIV;
        RAND_START=5+(C1-1);
        RAND_END=5+(C1-1);
        Var_START=5;
        BLOCK_START=RAND_END+1;
        BLOCK_END=BLOCK_START+9;
        
        save('temp_global_parallel','ADD','SUB','MUL','DIV','FSET_START','FSET_END','RAND_START','RAND_END','Var_START','BLOCK_START','BLOCK_END');
        gen=100;
        
        p = randperm(R1,floor(R1/2));
        trainD=Dat(p,:);
        Dat(p,:)=[];
        [R1,C1]=size(Dat);
        p = randperm(R1,floor(R1/2));
        validD=Dat(p,:);
        Dat(p,:)=[];
        testD=Dat;
      
        
        varnumber = size(trainD,2)-1;
        
   
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Preprocess data
        Xtrn = trainD(:,1:end-1);
        Xtst = testD(:,1:end-1);
        Xvld = validD(:,1:end-1);
        
        Ytrn = trainD(:,end);
        Ytst = testD(:,end);
        Yvld = validD(:,end);
        
        [Xtrn, mux, d] = normalize(Xtrn);
        [Ytrn, muy] = center(Ytrn);
        n = length(Ytst);
        m=length(Yvld);
        Xtst = (Xtst-ones(n,1)*mux)./(ones(n,1)*d);
        Ytst = Ytst-muy;
        Xvld = (Xvld-ones(m,1)*mux)./(ones(m,1)*d);
        Yvld = Yvld-muy;
        
        trainD=[Xtrn Ytrn];
        validD=[Xvld Yvld];
        testD=[Xtst Ytst];
        % Real world data (UCI data in Delego research) is normal by itself, hence, no need to normalize them
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
        tprim=0;
        j=1;
        OrgknumA=18;  %number of parallel processors
        
        poprandom1 = initialPopStGP_ver3(popSize,trainD,1);
        poprandom2 = initialPopStGP_ver3(popSize,trainD,2);
        poprandom3 = initialPopStGP_ver3(popSize,trainD,3);
        poprandom4 = initialPopStGP_ver3(popSize,trainD,4);
        poprandom5 = initialPopStGP_ver3(popSize,trainD,5);
        poprandom6 = initialPopStGP_ver3(popSize,trainD,6);
        poprandom7 = initialPopStGP_ver3(popSize,trainD,7);
        poprandom8 = initialPopStGP_ver3(popSize,trainD,8);
        
        
        pop=poprandom1;
        u=1;
        buffer{8*popSize} = [];
        rnd{8*popSize}=[];
        for h=1:(8*popSize)
            buffer{h}=pop.indiv(u).value;
            rnd{h}=pop.indiv(u).rand;
            u=u+1;
            switch(h)
                case popSize
                    clear pop
                    pop=poprandom2;
                    u=1;
                case (2*popSize)
                    clear pop
                    pop=poprandom3;
                    u=1;
                case (3*popSize)
                    clear pop
                    pop=poprandom4;
                    u=1;
                case (4*popSize)
                    clear pop
                    pop=poprandom5;
                    u=1;
                case (5*popSize)
                    clear pop
                    pop=poprandom6;
                    u=1;
                case (6*popSize)
                    clear pop
                    pop=poprandom7;
                    u=1;
                case (7*popSize)
                    clear pop
                    pop=poprandom8;
                    u=1;
            end
        end
        
        tic
        %sig=2^(j+1);
        sig=0.70; %semantic threshold
        popSiz=8*popSize;
        sortflag=1;
        [buffer,rnd,popSS,Eflag]=EliminateSimilar(buffer,rnd,popSiz,trainD,validD,1,1,1,j,2);
        % popSS=popSiz;
        [Buff,Rnd,Scount,popS,SMI1,endofu]=f1(buffer,rnd,popSS,tprim,trainD,validD,OrgknumA,varnumber,1,j,sig,sortflag,1)
        
        y=0;
        for h=1:endofu
            %if Scount(h)~=0
            y=y+1;
            Buf{1}{y}=Buff{h}{Scount(h)+1}
            Rn{1}{y}=Rnd{h}{Scount(h)+1};
            %end
        end
        
        [Blvariance1,Blmean1]= BlockVar(Buf,1,y,trainD,Rn,varnumber,1,1,1);
        [weights1,TrainErr1,TestErr1,ValidErr1,T1,FTrcor1,FTscor1]=Combination(Buf,Rn,endofu,trainD,validD,testD,1);
       
       
        knumA=endofu;
        clear pop
        delete(gcp)
        parpool('local',knumA)
        jnum = Composite();
        FBlk=Composite();
        FCoeff=Composite();
        flag=Composite();
        
        spmd (endofu) 
            
            switch(labindex)
                case 1
                    flag=0;
                    if Scount(1)+1>0
                      flag=1;
                      [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(1)+1,Buff{1},Rnd{1},gen,trainD,validD,testD,1,Buf,Rn,endofu,1);
                    end
                case 2
                    flag=0;
                    if Scount(2)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(2)+1,Buff{2},Rnd{2},gen,trainD,validD,testD,2,Buf,Rn,endofu,1);
                    end
                case 3
                    flag=0;
                    if Scount(3)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(3)+1,Buff{3},Rnd{3},gen,trainD,validD,testD,3,Buf,Rn,endofu,1);
                    end
                case 4
                    flag=0;
                    if Scount(4)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(4)+1,Buff{4},Rnd{4},gen,trainD,validD,testD,4,Buf,Rn,endofu,1);
                    end
                case 5
                    flag=0;
                    if Scount(5)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(5)+1,Buff{5},Rnd{5},gen,trainD,validD,testD,5,Buf,Rn,endofu,5);
                       
                    end
                case 6
                    flag=0;
                    if Scount(6)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(6)+1,Buff{6},Rnd{6},gen,trainD,validD,testD,6,Buf,Rn,endofu,6);
                       
                    end
                case 7
                    flag=0;
                    if Scount(7)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(7)+1,Buff{7},Rnd{7},gen,trainD,validD,testD,7,Buf,Rn,endofu,7);
                       
                    end
                case 8
                    flag=0;
                    if Scount(8)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(8)+1,Buff{8},Rnd{8},gen,trainD,validD,testD,8,Buf,Rn,endofu,8);
                       
                    end
                case 9
                    flag=0;
                    if Scount(9)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(9)+1,Buff{9},Rnd{9},gen,trainD,validD,testD,1,Buf,Rn,endofu,9);
                       
                    end
                case 10
                    flag=0;
                    if Scount(10)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(10)+1,Buff{10},Rnd{10},gen,trainD,validD,testD,2,Buf,Rn,endofu,10);
                      
                    end
                case 11
                    flag=0;
                    if Scount(11)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(11)+1,Buff{11},Rnd{11},gen,trainD,validD,testD,3,Buf,Rn,endofu,11);
                       
                    end
                case 12
                    flag=0;
                    if Scount(12)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(12)+1,Buff{12},Rnd{12},gen,trainD,validD,testD,4,Buf,Rn,endofu,12);
                     
                    end
                case 13
                    flag=0;
                    if Scount(13)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(13)+1,Buff{13},Rnd{13},gen,trainD,validD,testD,5,Buf,Rn,endofu,13);
                       
                    end
                case 14
                    flag=0;
                    if Scount(14)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(14)+1,Buff{14},Rnd{14},gen,trainD,validD,testD,6,Buf,Rn,endofu,14);
                       
                    end
                case 15
                    flag=0;
                    if Scount(15)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(15)+1,Buff{15},Rnd{15},gen,trainD,validD,testD,7,Buf,Rn,endofu,15);
                        
                    end
                case 16
                    flag=0;
                    if Scount(16)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(16)+1,Buff{16},Rnd{16},gen,trainD,validD,testD,8,Buf,Rn,endofu,16);
                       
                    end
                case 17
                    flag=0;
                    if Scount(17)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(17)+1,Buff{17},Rnd{17},gen,trainD,validD,testD,1,Buf,Rn,endofu,17);
                       
                    end
                case 18
                    flag=0;
                    if Scount(18)+1>0
                        flag=1;
                        [FBlk,FCoeff,jnum,MI1,res,res1,BV,BR]=MainFunc(Scount(18)+1,Buff{18},Rnd{18},gen,trainD,validD,testD,2,Buf,Rn,endofu,18);
                        
                    end
            end
        end
        Sjnum=zeros(knumA,1);
        for i=1:knumA
            if (flag{i}==1 )
                Sjnum(i)=jnum{i};
            end
        end
        
        p0=res;
       % p1=res1;
%         SMI=MI1;
%         SMIprime=res1;
        

% for i=1:endofu
%     SMI=[MI1{i}];
%     hold off
%     figure(i)
%     for alphcount=1:1
%         plot(1:gen,SMI(alphcount,:))
%         hold on
%     end
% end
% 
% for i=1:endofu
%     SMIprime=[res1{i}];
%     hold off
%     figure(i+endofu)
%     for alphcount=1:1
%         plot(1:gen,SMIprime(alphcount,:))
%         hold on
%     end
% end


        k=0;
        dummyj=1;
        FBl{dummyj,knumA}=[];
        FCoe{dummyj,knumA}=[];
        for i=1:knumA
            if (flag{i}==1)
                k=k+1;
                FBl{dummyj}{k}=FBlk{i};
                FCoe{dummyj}{k}=FCoeff{i};
            end
        end
        nu=k;
        [weights,TrainErr,TestErr,ValidErr,T,FTrcorM,FTscorM]=Combination(FBl,FCoe,nu,trainD,validD,testD,dummyj);
        [Blvariance,Blmean]= BlockVar(FBl,dummyj,nu,trainD,FCoe,varnumber,1,1,1);
        n=size(trainD,1);
      
        
        k=1;
        for i=1:knumA
            if (flag{i}==1)
                BlockValue{k}=BV{i};
                BlockRnd{k}=BR{i};
                k=k+1;
            end
        end
        
       
        [TrErr,FTrcor,TsErr,FTscor]=Basis_funcs_validplus(FBl,FCoe,nu,trainD,validD,testD,varnumber);

        Stime=toc;
     
        [TrErr1,FTrcorpre,TsErr1,FTscorpre]=Basis_funcs_validplus(Buf,Rn,endofu,trainD,validD,testD,varnumber);
        
        MaxCor_bef=FTrcor1;
        maxSjnum=max(Sjnum);
        
        %fileID = fopen('printfile.txt','w');
        
        save('MyMatfile','TrErr','TsErr','TrainErr','TestErr','maxSjnum','Stime','TrainErr1','TestErr1','TrErr1','TsErr1','MaxCor_bef','endofu','Blvariance','gen','FTrcor','FTscor','FTrcorpre','FTscorpre')
        S(timer)=load('MyMatfile');
        % fprintf(fileID,'%s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f \n','TrErr=',TrErr,'TsErr=',TsErr,'TrainErr=',TrainErr, 'TestErr=',TestErr,'maxSjnum=',maxSjnum,'Stime=',Stime,'TrainErr1=', TrainErr1, 'TestErr1=',TestErr1,'TrErr1=',TrErr1,'TsErr1=',TsErr1,'MaxCor_bef=',MaxCor_bef,'milo=',milo,'endofu=',endofu,'gen=',gen, 'FTrcor=',FTrcor,'FTscor=',FTscor,'FTrcorpre=',FTrcorpre,'FTscorpre=',FTscorpre );
        % type('printfile.txt')
        delete('temp_global_parallel.mat');
        MTrErr(1)=0;
        MTsErr(1)=0;
        MTrErr1(1)=0;
        MTsErr1(1)=0;
        MFTrcor(1)=0;
        MFTscor(1)=0;
        MFTrcorpre(1)=0;
        MFTscorpre(1)=0;
        MStime(1)=0;
        
        MTrErr(timer)=abs(TrErr)+MTrErr(timer-1);
        MTsErr(timer)=abs(TsErr)+MTsErr(timer-1);
        MTrErr1(timer)=abs(TrErr1)+MTrErr1(timer-1);
        MTsErr1(timer)=abs(TsErr1)+MTsErr1(timer-1);
        MStime(timer)=Stime+MStime(timer-1);
        MFTrcor(timer)=(FTrcor).^2+ MFTrcor(timer-1);
        MFTscor(timer)=(FTscor).^2+ MFTscor(timer-1);
        MFTrcorpre(timer)=(FTrcorpre).^2+ MFTrcorpre(timer-1);
        MFTscorpre(timer)=(FTscorpre).^2+ MFTscorpre(timer-1);
        V_MFTscor(timer-1)= MFTscor(timer)-MFTscor(timer-1);
        V_MTsErr(timer-1)= MTsErr(timer)-MTsErr(timer-1);
    end  %endfor timer
    
   % MfileID = fopen('Mprintfile.txt','w');
    fprintf(MfileID,'%s \n',baseFileName);
    fprintf(MfileID,'%s %2f \n','popSize=',popSize);
    fprintf(MfileID,'%s %2f \n','popSS=',popSS);
    fprintf(MfileID,'%s %2f \n','sumofscount=',sum(Scount));
    fprintf(MfileID,'%s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f %s %2f\n','MTrErr=',MTrErr(timer)/(ntimer-1),'MTsErr=',MTsErr(timer)/(ntimer-1), 'MStime=',MStime(timer)/(ntimer-1),'MTrErr1=',MTrErr1(timer)/(ntimer-1),'MTsErr1=',MTsErr1(timer)/(ntimer-1),'MFTrcor=',MFTrcor(timer)/(ntimer-1),'MFTscor=',MFTscor(timer)/(ntimer-1),'MFTrcorpre=',MFTrcorpre(timer)/(ntimer-1),'MFTscorpre=',MFTscorpre(timer)/(ntimer-1),'Var_MFTscor=' , var(V_MFTscor),'Var_MTsErr=', var(V_MTsErr));
    type('Mprintfile.txt')
  end  %endfor popSize
end   %endfor k files