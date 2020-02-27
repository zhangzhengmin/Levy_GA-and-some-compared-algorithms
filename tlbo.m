%
% Project Title: TLBO in MATLAB
%
% Developer: ZZM in HUST
%
% Contact Info:hust_zzm@hust.edu.cn
%

clc;
clear;
close all;

%% Problem Definition--------------------------------------------
% Problem parameters introduction and formation
[num, txt, job_info]=xlsread('..\Data\job_info 12.xls');% the information of jobs£¡£¡£¡£¡£¡
job_number=cell2mat(job_info(:,1));
machine_number=12;%please put in the machine number£¡£¡£¡£¡£¡
for i=1:length(job_number)
    job_info{i,3}=str2num(job_info{i,3});
end
job_quantity=max(job_number);%total number of jobs
job_position=find(~isnan(job_number));
job_position=[job_position;length(job_number)+1]';
for i=1:job_quantity
    job{i}=cell2mat(job_info(job_position(i):job_position(i+1)-1,2))';
end
job_time=cell2mat(job_info(:,4))';

% TLBO Parameters
MaxIt = 1000;        % Maximum Number of Iterations
nPop = 6;           % Population Size
searching_times=6;               % Times of NS
teaching_factor=0.6; % Teacher's participation in students' learning process
selfstudy_factor=3;

%% Initialization -------------------------------------------------
% routing allocation
population=zeros(nPop,length(job_number)*2);
for i=1:nPop
    len=length(job{1});
    for j=1:job_quantity-1
        len=len+length(job{j+1});
        Pop=zeros(1,len);
        j_pos=sort(randperm(len,length(job{j+1})));
        Pop(j_pos)=job{j+1};
        if j==1
            Pop(Pop==0)=job{j};
        else
            Pop(Pop==0)=final_pop;
        end
        final_pop=Pop;
        j=j+1;
    end
    %machine allocation
    for m=1:len
        final_pop(len+m)=job_info{m,3}(randperm(length(job_info{m,3}),1));
    end
    population(i,:)=final_pop;
    i=i+1;
end
% Objective Function
result=zeros(nPop,1);
for i=1:nPop
    x=population(i,:);
    result(i,1)=processingtime(x,job_position,machine_number,job_time);
    %complete time for each individual
end

tstart=tic;

%% TLBO Main Loop---------------------------------------------
for it=1:MaxIt
    % Select Teacher
    [best_result,best_index]= min(result);
    teacher=population(best_index,:);
    
    %Select Student
    student=population;
    student(best_index,:)=[];
    student_result=result;
    student_result(best_index,:)=[];
    
    %Self-study.
    [best_result,teacher]=self_study(teacher,searching_times,len,job_info,job_position,machine_number,job_time,best_result,selfstudy_factor);
    
    % Learning Phase
    for i=1:length(student(:,1))
        s=student(i,:);
        s_new=teaching(teacher,s,len,teaching_factor);
        x=s_new;
        s_result=processingtime(x,job_position,machine_number,job_time);
        if s_result<student_result(i,:)
            student(i,:)=s_new;
            student_result(i,:)=s_result;
        end
    end
    
    %New population
    population=[teacher;student];
    result=[best_result;student_result];
    
    % Select
    [best_result,best_index]= min(result);
    
    % Store Record for Current Iteration
    Best(it) = best_result;
    Mean(it)=sum(result(:,1))/nPop;
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Result= ' num2str(Best(it))]);
    disp(['Iteration ' num2str(it) ': Mean='  num2str(Mean(it))]);
    
    tused = toc(tstart);
    if tused > 60
        break;
    end
end

%% Results----------------------------------------------

figure(1);
plot(Best, 'LineWidth', 2);
%semilogy(Best, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Result');
grid on;

figure(2);
plot(Mean, 'LineWidth', 2);
%semilogy(Best, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Mean Result');
grid on;


%best=population(best_index,:);

best=teacher;
gant(best,len,machine_number,best_result,job_position,job_time);