function [demand, N, Z] = estimation( method,parameters,resources,category_list,reportDataFolder)

warmUp = 0;
nCPU = 1;
maxTime = 1000;
sampleSize = 100;
tol = 10^-3;
supportedMethods = {'ci','minps','erps','gql','ubr','ubo'};

for i = 1:size(parameters,1)
    switch parameters{i,1}
        case 'warmUp'
            warmUp = str2double(parameters{i,2});
        case 'nCPU'
            nCPU = str2double(parameters{i,2});
        case 'maxTime'
            maxTime = str2double(parameters{i,2});
        case 'sampleSize'
            sampleSize = str2double(parameters{i,2});
        case 'tol'
            tol = str2double(parameters{i,2});
    end
end

demand = -1;

for i = 0:resources.size-1
    pair = resources.get(i);
    load(strcat(pair,'_ResponseInfo','_data.mat'),'data')
    
    if strcmp(method,'automatic')
        method = chooseMethod(data);
    end
    
    try
        method = validatestring(method,supportedMethods);
    catch
        method = chooseMethod(data);
        warning('Unexpected method. No demand generated. Will automatically choose one.');
    end
    
    switch method
        case 'ci'
            demand = ci(data,nCPU,warmUp);
        case 'minps'
            demand = main_MINPS(data, warmUp+1, sampleSize, nCPU);
        case 'erps'
            demand = main_ERPS(data, warmUp+1, sampleSize, nCPU);
        case 'gql'
            demand = gibbs(data,nCPU,tol);
        case 'ubr'
            demand = ubr(data,nCPU);
        case 'ubo'
            demand = ubo(data,maxTime);
    end
    
    [ N, N0 ] = estimateN( data );
    Z = estimateZ( data, N, N0 );
    
    generateJsonFile(resources.get(i),demand,N,Z,category_list,reportDataFolder);
end

end