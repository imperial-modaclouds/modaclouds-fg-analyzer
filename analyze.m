clc
clear

%load('time_single_thread_100sampleSize.mat')
load('time_single_thread_100sampleSize_noMinps.mat')
error_rate = zeros(6,5);
%time_single = mean(time,2)
for i = 1:7
    for j = 1
        if length(demand{i,j}) < length(demand{1,j})
            error_rate(i,j) = inf;
            continue
        end
        if isrow(demand{i,j})
            demand{i,j} = demand{i,j}';
        end
        error_rate(i,j) = mean(abs(demand{i,j}-demand{1,j})./demand{1,j});
    end
end
error_single = mean(error_rate,2)

load('time_single_thread_100sampleSize_noMinps.mat')
demand_old = demand;
load('time_single_thread_1000sampleSize_100M2.mat')

error_rate = zeros(6,5);
time_multi = mean(time,2)
for i = 3:6
    for j = 1
        if length(demand{i,j}) < length(demand{1,j})
            error_rate(i,j) = inf;
            continue
        end
        if isrow(demand{i,j})
            demand{i,j} = demand{i,j}';
        end
        error_rate(i,j) = mean(abs(demand{i,j}-demand_old{1,j})./demand_old{1,j});
    end
end
error_multi = mean(error_rate,2)