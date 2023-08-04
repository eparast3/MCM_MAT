function [vip, vis]=loc_filt(FlrPS, FlrPS1, sc) 


i=1


v1l=length(FlrPS.v1)
v2l=length(FlrPS.v2)
v3l=length(FlrPS.v3)
v4l=length(FlrPS.v4)
v5l=length(FlrPS.v5)
v6l=length(FlrPS.v6)
v7l=length(FlrPS.v7)
v8l=length(FlrPS.v8)
v9l=length(FlrPS.v9)
v10l=length(FlrPS.v10)

L=[v1l v2l v3l v4l v5l v6l v7l v8l v9l v10l]
[V id]=sort(L,'descend')

for i=1:sc
   if isempty(V(i))
       k=i-2
   else
       k=sc-2
   end   
end




my_field = strcat('v',num2str(id(1)))
vip=FlrPS.(my_field)

for i=1:k
    vip=intersect(vip,FlrPS.(strcat('v',num2str(id(i+1)))))
  
end



v1l=length(FlrPS1.v1)
v2l=length(FlrPS1.v2)
v3l=length(FlrPS1.v3)
v4l=length(FlrPS1.v4)
v5l=length(FlrPS1.v5)
v6l=length(FlrPS1.v6)
v7l=length(FlrPS1.v7)
v8l=length(FlrPS1.v8)
v9l=length(FlrPS1.v9)
v10l=length(FlrPS1.v10)

L=[v1l v2l v3l v4l v5l v6l v7l v8l v9l v10l]
[V id]=sort(L,'descend')


for i=1:sc
   if isempty(V(i))
       k=i-2
   else
       k=sc-2
   end   
end

my_field = strcat('v',num2str(id(1)))
vis=FlrPS1.(my_field)

for i=1:k
    vis=intersect(vis,FlrPS1.(strcat('v',num2str(id(i+1)))))
end


% for i=1:sc    
%          PSdifT(:,i)=stat.travels(:,i)-stat.travelp(:,i) %theoretical grid travel time differences for each station for P and S      
% end

