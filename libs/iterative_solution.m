function search = iterative_solution(mcm,search)



opts = detectImportOptions(mcm.output_old)
opts.VariableNames{1}='Coh'; % set the name of the first colume
stall=readtable(mcm.output_old,opts); % read in all the information




% set point zero as the maximum value
north0=stall.North(1);
east0=stall.East(1);
depth0=stall.Depth(1);



if mcm.iterative==1

% calculate pdf for each direction based on distance from point zero
%north PDF
north0_i=stall.North-north0
muN=mean(north0_i)
sigmaN=std(north0_i)
north_pdf=pdf('Normal',north0_i,muN,sigmaN)
[maxPDFn idn]=max(north_pdf)
maxDisN=abs(2*north0_i(idn))
maxn=north0_i(idn)
newNorth=north0+maxn

%east PDF
east0_i=stall.East-east0
muE=mean(east0_i)
sigmaE=std(east0_i)
east_pdf=pdf('Normal',east0_i,muE,sigmaE)
[maxPDFe ide]=max(east_pdf)
maxDisE=abs(2*east0_i(ide))
maxe=east0_i(ide)
newEast=east0+maxe

%depth PDF
depth0_i=stall.Depth-depth0
muD=mean(depth0_i)
sigmaD=std(depth0_i)
depth_pdf=pdf('Normal',depth0_i,muD,sigmaD)
[maxPDFd idd]=max(depth_pdf)    
maxDisD=abs(2*depth0_i(idd))
maxd=depth0_i(idd)
newDepth=depth0+maxd

if mcm.itN==2


if maxDisN~=0
    search.north=[(newNorth-maxDisN) (newNorth+maxDisN)]
% elseif maxDisE~=0 && maxDisE < maxDisD
%      search.north=[(newNorth-maxDisE) (newNorth+maxDisE)]
% elseif maxDisD~=0   
%     search.north=[(newNorth-maxDisD) (newNorth+maxDisD)]
else
    search.north=[(newNorth-search.dn) (newNorth+search.dn)]
end


if maxDisE~=0
    search.east=[(newEast-maxDisE) (newEast+maxDisE)]
% elseif maxDisN~=0 && maxDisN < maxDisD
%      search.east=[(newEast-maxDisN) (newEast+maxDisN)]
% elseif maxDisD~=0     
%     search.east=[(newEast-maxDisD) (newEast+maxDisD)]
else
     search.east=[(newEast-search.de) (newEast+search.de)]
end

if maxDisD~=0
    search.depth=[(newDepth-maxDisD) (newDepth+maxDisD)]
    if search.depth(1)<0 
        search.depth(1)=0 
    end    
% elseif maxDisN~=0 && maxDisN < maxDisE
%      search.depth=[(newDepth-maxDisN) (newDepth+maxDisN)]
% elseif maxDisE~=0     
%     search.depth=[(newDepth-maxDisE) (newDepth+maxDisE)]
else
   search.depth=[(0) (newDepth+(search.dd*2))]
end

if maxDisN>maxDisE && maxDisN>maxDisD 
    maxSide=2*maxDisN
elseif maxDisE>maxDisN && maxDisE>maxDisD 
    maxSide=2*maxDisE
elseif maxDisD~=0
    maxSide=2*maxDisD
else
    maxSide=2*search.dn
end




el_size=maxSide/10

if el_size>search.dn
    el_size=search.dn/2
end

search.dn=el_size; % spatial interval of source imaging points in the North direction, in meter
search.de=el_size; % spatial interval of source imaging points in the East direction, in meter
search.dd=el_size; % spatial interval of source imaging points in the Depth direction, in meter

elseif mcm.itN==3

    itN2Name = extractBefore(mcm.output,'_3.txt')
    itN2Name = append(itN2Name,'_2.mat')  
    load(itN2Name,'-mat','search')

if maxDisN~=0
    search.north=[(newNorth-maxDisN) (newNorth+maxDisN)]
else
    search.north=[(newNorth-search.dn) (newNorth+search.dn)]
end


if maxDisE~=0
    search.east=[(newEast-maxDisE) (newEast+maxDisE)]
else
     search.east=[(newEast-search.de) (newEast+search.de)]
end


if maxDisD~=0
    search.depth=[(newDepth-maxDisD) (newDepth+maxDisD)]
    if search.depth(1)<0 
        search.depth(1)=0 
    end    
else
   search.depth=[(0) (newDepth+(search.dd*2))]
end


if maxDisN>maxDisE && maxDisN>maxDisD 
    maxSide=2*maxDisN
elseif maxDisE>maxDisN 
    maxSide=2*maxDisE
elseif maxDisD~=0
    maxSide=2*maxDisD
else
    maxSide=2*search.dn
end

if maxDisN<=maxDisE && maxDisN<=maxDisD && maxDisN~=0
    minSide=2*maxDisN
elseif maxDisE<=maxDisN && maxDisE<=maxDisD && maxDisE~=0
    minSide=2*maxDisE
elseif maxDisD<=maxDisN && maxDisD<=maxDisE && maxDisD~=0
    minSide=2*maxDisD
else
    minSide=2*search.dn
end



if minSide==maxSide
    el_size=minSide/10
else  
    if  minSide==search.dn*4
         el_size=minSide/8
    else
        el_size=minSide/4
    end
end

if el_size>search.dn
    el_size=search.dn/2
end


search.dn=el_size; % spatial interval of source imaging points in the North direction, in meter
search.de=el_size; % spatial interval of source imaging points in the East direction, in meter
search.dd=el_size; % spatial interval of source imaging points in the Depth direction, in meter


elseif mcm.itN==4

    itN2Name = extractBefore(mcm.output,'_4.txt')
    itN2Name = append(itN2Name,'_3.mat')  
    load(itN2Name,'-mat','search')

if maxDisN~=0
    search.north=[(newNorth-maxDisN) (newNorth+maxDisN)]
else
    search.north=[(newNorth-search.dn) (newNorth+search.dn)]
end


if maxDisE~=0
    search.east=[(newEast-maxDisE) (newEast+maxDisE)]
else
     search.east=[(newEast-search.de) (newEast+search.de)]
end


if maxDisD~=0
    search.depth=[(newDepth-maxDisD) (newDepth+maxDisD)]
    if search.depth(1)<0 
        search.depth(1)=0 
    end    
else
   search.depth=[(0) (newDepth+(search.dd*2))]
end


if maxDisN>maxDisE && maxDisN>maxDisD 
    maxSide=2*maxDisN
elseif maxDisE>maxDisN 
    maxSide=2*maxDisE
elseif maxDisD~=0
    maxSide=2*maxDisD
else
    maxSide=2*search.dn
end

if maxDisN<=maxDisE && maxDisN<=maxDisD && maxDisN~=0
    minSide=2*maxDisN
elseif maxDisE<=maxDisN && maxDisE<=maxDisD && maxDisE~=0
    minSide=2*maxDisE
elseif maxDisD<=maxDisN && maxDisD<=maxDisE && maxDisD~=0
    minSide=2*maxDisD
else
    minSide=2*search.dn
end





if minSide==maxSide
    el_size=minSide/10
else  
    if  minSide==search.dn*4
         el_size=minSide/8
    else
        el_size=minSide/4
    end
end
if el_size>search.dn
    el_size=search.dn/2
end




search.dn=el_size; % spatial interval of source imaging points in the North direction, in meter
search.de=el_size; % spatial interval of source imaging points in the East direction, in meter
search.dd=el_size; % spatial interval of source imaging points in the Depth direction, in meter


end

else %Geometrical approach
  
    if mcm.itN==2

    maxSideN=(search.north(2)-search.north(1))/4
    maxSideE=(search.east(2)-search.east(1))/4
    maxSideD=(search.depth(2)-search.depth(1))/4
    
    
    elseif mcm.itN==3
    itN2Name = extractBefore(mcm.output,'_3.txt')
    itN2Name = append(itN2Name,'_2.mat')  
    load(itN2Name,'-mat','search')
        
    maxSideN=(search.north(2)-search.north(1))/4
    maxSideE=(search.east(2)-search.east(1))/4
    maxSideD=(search.depth(2)-search.depth(1))/4    
        
    end
    
    
    if depth0-maxSideD < 0
         minD=0
        maxD=maxSideD*2
    else
        minD=depth0-maxSideD
        maxD=depth0+maxSideD
    end
    
    search.north=[(north0-maxSideN) (north0+maxSideN)]
     search.east=[(east0-maxSideE) (east0+maxSideE)]
     search.depth=[(minD) (maxD)] 
    
    
     %el_size=maxSideN/5
     el_size=100

search.dn=el_size; % spatial interval of source imaging points in the North direction, in meter
search.de=el_size; % spatial interval of source imaging points in the East direction, in meter
search.dd=el_size; % spatial interval of source imaging points in the Depth direction, in meter
    maxDisN=0
    maxDisE=0
    maxDisD=0
    


end



newName = extractBefore(mcm.output,'.txt')
newName = append(newName,'.mat')

save(newName,'search','maxDisN','maxDisE','maxDisD','-mat')







end


