function pre_processing(filename)


tic
fileID = fopen(filename);
C = textscan(fileID,'%s');
fclose(fileID);
celldisp(C)
numfiles = numel(C{1});
mydata = cell(1, numfiles);
load('Time_coor.mat')
ts=0.01
t=(0:0.01:(0.01*4500))

nfft=4501;
Fs=1/ts;
f=(0:nfft/2-1)*Fs/nfft;


for ki = 1:numfiles
    
  myfilename = char(C{1}{ki});
  load(myfilename);  

[k j]=size(zdata)


max_freq(k,3)=0

i=1

parfor i=1:k

tyrn=ndata(i,:)
tyre=edata(i,:)
tyrz=zdata(i,:)

tyr1F=fft((tyrz-mean(tyrz)),nfft)
tyr1F=abs((tyr1F(1:nfft/2)).^2)
[vz,kz] = sort(tyr1F, 'descend')

n=1

domFz=f(kz(n))

    while domFz>20
         domFz=f(kz(n+1))
         n=n+1
    end

tyr1Fn=fft((tyrn-mean(tyrn)),nfft)
tyr1Fn=abs((tyr1Fn(1:nfft/2)).^2) 
[vn,kn] = sort(tyr1Fn, 'descend')

n=1

domFn=f(kn(n))

    while domFn>20
         domFn=f(kn(n+1))
         n=n+1
    end




tyr1Fe=fft((tyre-mean(tyre)),nfft)
tyr1Fe=abs((tyr1Fe(1:nfft/2)).^2)
[ve,ke] = sort(tyr1Fe, 'descend')

n=1

domFe=f(ke(n))

    while domFe>20
        domFe=f(ke(n+1))
        n=n+1
    end



max_freq(i,:)=[domFz, domFn, domFe]


end


Time=power_spec(ndata, edata, zdata, max_freq) 

% calculate time differences from the station with the earliest arrival
[Tmin id]=min(Time.pwinm)
[Tmins ids]=min(Time.swinm)

Rdifpm=Time.pwinm-Tmin % Recorded minimum times minous the earliest arival from nearest station for P wave
Rdifsm=Time.swinm-Tmins  % Recorded minimum times minous the earliest arival from nearest station for S wave
RdifpM=Time.pwinM-Tmin % Recorded maximum times minous the earliest arival from nearest station for P wave
RdifsM=Time.swinM-Tmins  % Recorded maximum times minous the earliest arival from nearest station for S wave

[sr sc]=size(stat.travelp)


    travelp=stat.travelp
    travels=stat.travels
% Calculate theoretical travel time differeences
parfor i=1:sc
    %for j=1:sr
         Tdifp(:,i)=travelp(:,i)-travelp(:,id) %theoretical grid travel time differences with the station with minimum arrival for P
         Tdifs(:,i)=travels(:,i)-travels(:,ids) %theoretical grid travel time differences with the station with minimum arrival for S
    %end
end

% Filter data for overlapping times for P anzd S
for i=1:sc
    flrP=find(Tdifp(:,i)>Rdifpm(i) & Tdifp(:,i)<RdifpM(i))
    flrS=find(Tdifs(:,i)>Rdifsm(i) & Tdifs(:,i)<RdifsM(i))
     my_field = strcat('v',num2str(i));
    FlrPS.(my_field)=flrP
    FlrPS1.(my_field)=flrS
    clear flrP flrS
end



[vip, vis]=loc_filt(FlrPS, FlrPS1, sc)





if isempty(vip) 
    northM=0
northm=0

eastM=0
eastm=0

depthM=0
depthm=0
locp=0
else
    [j k]=size(vip)
    parfor i=1:j
    locp(i,:)=soup(vip(i),:)
    end


northM=max(locp(:,1))
northm=min(locp(:,1))

eastM=max(locp(:,2))
eastm=min(locp(:,2))

depthM=max(locp(:,3))
depthm=min(locp(:,3))
end




if isempty(vis) 
    northMs=0
northms=0

eastMs=0
eastms=0

depthMs=0
depthms=0
locs=0
else
    [j k]=size(vis)
parfor i=1:j
    locs(i,:)=soup(vis(i),:)
end


northMs=max(locs(:,1))
northms=min(locs(:,1))

eastMs=max(locs(:,2))
eastms=min(locs(:,2))

depthMs=max(locs(:,3))
depthms=min(locs(:,3))
end
newName = sprintf('p4re_%s',myfilename)



save(newName,'Time','FlrPS','FlrPS1','northM','northm','eastM','eastm','depthM','depthm','locp','northMs','northms','eastMs','eastms','depthMs','depthms','locs')
clear 'Time' 'FlrPS' 'FlrPS1' 'northM' 'northm' 'eastM' 'eastm' 'depthM' 'depthm' 'locp' 'northMs' 'northms' 'eastMs' 'eastms' 'depthMs' 'depthms' 'locs'  
end
toc

