%
% Project Title: TLBO in MATLAB
%
% Developer: ZZM in HUST
%

% Contact Info:hust_zzm@hust.edu.cn
%

function [best_result, teacher] = self_study(teacher,searching_times,len,job_info,job_position,machine_number,job_time,best_result,selfstudy_factor)
teacher_copy=teacher;
teacher_pop=cell(searching_times,1);
teacher_res=zeros(searching_times,1);
for t=1:searching_times
    cross_pos=randperm(len,selfstudy_factor);
    mutation_pos=randperm(len,selfstudy_factor);
    %Cross
    for c=cross_pos
        if any(c==job_position)
            a=1;
            b=find(c+1==teacher(1,1:len));
        elseif any(c+1==job_position)
            a=find(c==teacher(1,1:len));
            b=len;
        else
            a=find(c-1==teacher(1,1:len));
            b=find(c+1==teacher(1,1:len));
        end
        old_p= find(c==teacher(1,1:len));
        old_m=teacher(1,old_p+len);
        teacher(1,old_p)=0;
        teacher(1,old_p+len)=0;
        if a==b
            p=randi([a,b],1);
        else
            p=randi([a,b-1],1);
        end
        if p==len
            teacher=[teacher(1,1:p),c,teacher(1,len+1:len+p),old_m];
        else
            teacher=[teacher(1,1:p),c,teacher(1,p+1:len),teacher(1,len+1:len+p),old_m,teacher(1,len+p+1:2*len)];
        end
        teacher(find(0==teacher(1,:)))=[];
    end
    %Mutation
    for m=mutation_pos
        teacher(m+len)=job_info{m,3}(randperm(length(job_info{m,3}),1));
    end
    teacher_pop{t,1}=teacher;
    x=teacher;
    teacher_res(t,1) = processingtime(x,job_position,machine_number,job_time);
end
if min(teacher_res)<best_result
    [best_result,best_index]=min(teacher_res);
    teacher=teacher_pop{best_index,1};
else
    teacher=teacher_copy;
end
end