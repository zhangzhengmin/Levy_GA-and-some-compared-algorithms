%
% Project Title: TLBO in MATLAB
%
% Developer: ZZM in HUST
%
% Contact Info:hust_zzm@hust.edu.cn
%

function [] = gant(best,len,machine_number,best_result,job_position,job_time)


figure(3)
axis([0,best_result+1,0,machine_number+0.5]);%x-axis range+y-axis range
set(gca,'xtick',0:4:best_result+1) ;%x-axis growth
set(gca,'ytick',0:1:machine_number+0.5) ;%y-axis growth
xlabel('加工时间'),ylabel('机器号');%name
title('最佳调度甘特图');%title
n_task_nb = len;%total tasks

%start time of each tasks
tc=zeros(1,machine_number);
ts=zeros(1,length(job_position)-1);
n_start_time=zeros(1,len);
n_job_id=zeros(1,len);

for j=1:len
    machine_loc=best(len+j);
    job_loc=length(find(job_position<=best(j)));
    n_job_id(1,j)=job_loc;
    
    if any(best(j)==job_position)
        tc(machine_loc)=tc(machine_loc)+job_time(best(j));
        ts(job_loc)=tc(machine_loc);
        n_start_time(1,j)=tc(machine_loc)-job_time(best(j));
    else
        if tc(machine_loc)>= ts(job_loc)
            tc(machine_loc)=tc(machine_loc)+job_time(best(j));
        else
            tc(machine_loc)=ts(job_loc)+job_time(best(j));
        end
        n_start_time(1,j)=tc(machine_loc)-job_time(best(j));
        ts(job_loc)=tc(machine_loc);
    end
end

%duration time of every task
n_duration_time =job_time(best(1:len));
%y
n_bay_start=best(1,len+1:2*len);
%temp data space for every rectangle
rec=[0,0,0,0];
%color
color=['r','g','b','c','m','y','r','g','b','c','m','y','r','g','b','c','m','y'];

for i =1:n_task_nb
    rec(1) = n_start_time(i);%x-axis
    rec(2) = n_bay_start(i)-0.3;  %y-axis
    rec(3) = n_duration_time(i);  %length
    rec(4) = 0.6;
    txt=sprintf('p(%d,%d)=%d',n_bay_start(i),n_job_id(i),n_duration_time(i));
    rectangle('Position',rec,'LineWidth',0.2,'LineStyle','-','FaceColor',color(n_job_id(i)));%draw every rectangle
    text(n_start_time(i)+0.2,(n_bay_start(i)),txt,'FontWeight','Bold','FontSize',8);%label the id of every task 
end