%
% Project Title: TLBO in MATLAB
% 
% Developer: ZZM in HUST
% 
% Contact Info:hust_zzm@hust.edu.cn
%

function z = processingtime(x, job_position,machine_number,job_time)

tc=zeros(1,machine_number);
ts=zeros(1,length(job_position)-1);

for j=1:length(x)/2
   machine_loc=x(length(x)/2+j);
   job_loc=length(find(job_position<=x(j)));
   if any(x(j)==job_position)
       tc(machine_loc)=tc(machine_loc)+job_time(x(j));
       ts(job_loc)=tc(machine_loc);
   else
       if tc(machine_loc)>= ts(job_loc)
           tc(machine_loc)=tc(machine_loc)+job_time(x(j));
       else
           tc(machine_loc)=ts(job_loc)+job_time(x(j));
       end
       ts(job_loc)=tc(machine_loc);
   end
end
z=max(tc);
end