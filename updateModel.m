function updateModel( parameters, classes, demand, resources, N, Z )

for i = 0:resources.size-1
    processorName(i+1) = java.lang.String(char(resources.get(i)));
end

for i = 1:size(parameters,1)
    switch parameters{i,1}
        case 'LQNFile'
            LQNFileName = parameters{i,2};
        case 'PCMProcessorScaleFile'
            PCMRateFileName = parameters{i,2};
        case 'PCMDemandFile'
            PCMDemandFileName = parameters{i,2};
        case 'ClassMapFile'
            classMapFileName = parameters{i,2};
        case 'ResourceMapFile'
            resourceMapFileName = parameters{i,2}; 
        case 'PCMUsageModelFile'
            PCMUsageModelFile = parameters{i,2}; 
    end
end

LQNupdater = javaObject('imperial.modaclouds.fg.modelUpdater.LQNUpdate');

for i = 1:length(classes)
    classes_java(i) = java.lang.String(classes{1,i});
    demand_java(i) = java.lang.String(num2str(demand(i)));
end

jobClass = classes_java
jobDemand = demand_java

LQNupdater.updateFile(LQNFileName, processorName, classes_java, demand_java, classMapFileName, resourceMapFileName, num2str(sum(N)), num2str(sum(Z)));

PCMupdater = javaObject('imperial.modaclouds.fg.modelUpdater.PCMUpdate');
PCMupdater.updatePCMModels(PCMRateFileName, PCMDemandFileName, PCMUsageModelFile, LQNFileName, processorName, classes , num2str(sum(N)), num2str(sum(Z)), classMapFileName, resourceMapFileName);

end