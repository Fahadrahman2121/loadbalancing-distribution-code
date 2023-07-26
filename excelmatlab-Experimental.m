clc
clear
Query=0:40;
Average_sec_arrivals=2.45;
mins_between_arrivals=0:19;
Cumulative_prob=1-poisscdf(Average_sec_arrivals,mins_between_arrivals);
Cumul_Prob_Lookup=Cumulative_prob;
Time_btw_arrivals=zeros(1,length(Query));
for i=1:length(Query)
ALEA=rand(1,1);
[mini,indice] = min(abs(Cumul_Prob_Lookup-ALEA));
Time_btw_arrivals(i)=sec_between_arrivals(indice);
end
Arrival_Time=zeros(1,length(Query));
Arrival_Time(1)=Time_btw_arrivals(1);
for i=2:length(Query)
Arrival_Time(i)= Arrival_Time(i-1)+Time_btw_arrivals(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
End_shared1=zeros(1,length(Query));
End_shared2=zeros(1,length(Query));
Average_mins_cust=2.2;


End1=zeros(1,length(Query));
End2=zeros(1,length(Query));
server=zeros(1,length(Query));
Time1=zeros(1,length(Query));
Time2=zeros(1,length(Query));
start1=zeros(1,length(Query));
start2=zeros(1,length(Query));
idle1=zeros(1,length(Query));
idle2=zeros(1,length(Query));
wait=zeros(1,length(Query));

for i=2:length(Query)
ALEA1=rand(1,1);
ALEA2=rand(1,1);
   if max(End_shared1)<max(End_shared2)
    server(i)=1;
    start1(i)=max(max(End2(1:i-1)),Arrival_Time(i));
    Time1(i)=round(-1*Average_mins_cust*log(ALEA1));
    End_shared1(i)=start1(i)+Time1(i);
    start2(i)=NaN;
    Time2(i)=NaN;
    End_shared2(i)=NaN;
    idle1(i)=start1(i)-max(End_shared1(1:i-1));
    idle2(i)=NaN;
   else
    server(i)=2;
    start1(i)=NaN;
    Time1(i)=NaN;
    End_shared1(i)=NaN;
    start2(i)=max(max(End_shared2(1:i-1)),Arrival_Time(i));
    Time2(i)=fix(-1*Average_sec_cust*log(ALEA2));
    End_shared2(i)=start2(i)+Time2(i);
    idle1(i)=NaN;
    idle2(i)=start2(i)-max(End_shared2(1:i-1));
   end 
wait(i)=max(start2(i),start1(i))-Arrival_Time(i);
end
Query=Query';
Time_btw_arrivals=Time_btw_arrivals';
Arrival_Time=Arrival_Time';
server=server';
start1=start1';
Time1=Time1';
End_shared1=End_shared1';
start2=start2';
Time2=Time2';
End_shared2=End_shared2';
idle1=idle1';
idle2=idle2';
wait=wait';
%fprintf('%6s %8s %10s %12s %14s %16s %18s %20s %22s %24s %26s %28s %30s',...
%name={'Query','Time_btw_arrivals','Arrival_Time','server','start1','Time1','End_shared1',...
%'start2','Time2','End_shared2','idle1','idle2','wait'};
%res=[Query',Time_btw_arrivals',Arrival_Time',server',start1',Time1',End_shared1',...
%start2',Time2',End_shared2',idle1',idle2',wait']
T = table(Query,Time_btw_arrivals,Arrival_Time,server,start1,Time1,End_shared1,...
start2,Time2,End_shared2,idle1,idle2,wait)

Total_wait_time = sum(wait)
Max_wait_time=max(wait)
Avg_wait_time=mean(wait)

Total_Idle_time1 = sum(idle1,'omitnan')
idle_time_percent1 = Total_Idle_time1/(max(End_shared1))

Total_Idle_time2 = sum(idle2,'omitnan')
idle_time_percent2 = Total_Idle_time2/(max(End_shared2))




