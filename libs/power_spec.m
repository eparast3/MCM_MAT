function Time=power_spec(ndata, edata, zdata, max_freq) 
[k j]=size(zdata)
ts=0.01

Fs=1/ts;

for i=1:k

tyrn=ndata(i,1:4001)
tyre=edata(i,1:4001)
tyrz=zdata(i,1:4001)  
    
[spn,fpn,tpn]=pspectrum(tyrn,Fs,'spectrogram','FrequencyLimits',[3 30],'TimeResolution',0.1)
[spe,fpe,tpe]=pspectrum(tyre,Fs,'spectrogram','FrequencyLimits',[3 30],'TimeResolution',0.1)
[spz,fpz,tpz]=pspectrum(tyrz,Fs,'spectrogram','FrequencyLimits',[3 30],'TimeResolution',0.1)


% find the index of the frequencies above and below the dominant frequency
indn=find(fpn>max_freq(i,2)-0.25 & fpn<max_freq(i,2)+0.25)
inde=find(fpe>max_freq(i,3)-0.25 & fpe<max_freq(i,3)+0.25)
indz=find(fpz>max_freq(i,1)-0.25 & fpz<max_freq(i,1)+0.25)


[pn cn]=size(indn)
[pe ce]=size(inde)
[pz cz]=size(indz)


p=min([pn,pe,pz])


% use the dominant frequencies +- and find peaks on these rows using which
%are above aveerage value and find the maximum value too which will be
%considered as the S arrival

avN=mean(spn((indn)))
avE=mean(spe((inde)))
avZ=mean(spz((indz)))

   fs=33.3
   
    for c=1:p
       

       [Mspn(c) MtN(c)]=max(spn((indn(c)),233:500))
       % filter values above the average
       [pksN locsN]=findpeaks(spn(indn(c),200:500),1,'MinPeakDistance',33)
     
       
       pksN_dif=diff(log(pksN))     
        [j k]=max(pksN_dif)
        PtNA(c)=locsN((k))+200
       
      
       [Mspe(c)  MtE(c)]=max(spe((inde(c)),233:500))
       % filter values above the average
       [pksE locsE]=findpeaks(spe(indn(c),200:500),1,'MinPeakDistance',33)
       
       pksE_dif=diff(log(pksE))     
        [j k]=max(pksE_dif)
        PtEA(c)=locsE((k))+200
        
     
       [Mspz(c) MtZ(c)]=max(spz((indz(c)),233:500))
       % filter values above the average
       [pksZ locsZ]=findpeaks(spz(indn(c),200:500),1,'MinPeakDistance',33)
     
       
       pksZ_dif=diff(log(pksZ))     
        [j k]=max(pksZ_dif)
        PtZA(c)=locsZ((k))+200
   
 
     
    end
 
    

     % p & s arrivals

        StNa(i)=median(MtN)+233
        StEa(i)=median(MtE)+233
        StZa(i)=median(MtZ)+233

        StNat(i)=tpz(StNa(i))
        StEat(i)=tpz(StEa(i))
        StZat(i)=tpz(StZa(i))


        StChM(i)=median([StNat(i),StEat(i),StZat(i)])

         
        PtNa(i)=median(PtNA)
        PtEa(i)=median(PtEA)
        PtZa(i)=median(PtZA)

    
    
        PtNat(i)=tpz(PtNa(i))
        PtEat(i)=tpz(PtEa(i))
        PtZat(i)=tpz(PtZa(i))


        PtChM(i)=median([PtNat(i),PtEat(i),PtZat(i)])
 
% convert P and S peaks to time 

Time.pwinM(i)=PtChM(i)+1.1
Time.pwinm(i)=PtChM(i)-0.7
Time.swinM(i)=StChM(i)+1.1
Time.swinm(i)=StChM(i)-0.7
Time.maxPS(i)=Time.swinM(i)-Time.pwinm(i)



end

