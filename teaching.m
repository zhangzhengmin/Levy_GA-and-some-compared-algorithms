%
% Project Title: TLBO in MATLAB
%
% Developer: ZZM in HUST
%
% Contact Info:hust_zzm@hust.edu.cn
%


function a=teaching(teacher,s,len,teaching_factor)
a=zeros(1,len*2);
for j=1:len
    if rand(1)<teaching_factor
        for k=1 : len
            if ismember(teacher(k),a(1,1:len))
            else
                a(j)=teacher(k);
                a(j+len)=teacher(k+len);
                break;
            end
        end
    else
        for q=1 : len
            if ismember(s(q),a(1,1:len))
            else
                a(j)=s(q);
                a(j+len)=s(q+len);
                break;
            end
        end
    end
end
end