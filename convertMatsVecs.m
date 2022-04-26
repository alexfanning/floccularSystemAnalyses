function dataOut = convertMatsVecs(dataIn,parameters,type)
%
%   Takes in concatenated blocks matrix and reorganizes it back into
%   individual block matrices.
%
%   Alex Fanning, March 2020
% *************************************************************************

% Grab data to iterate through
numBlocks = [parameters.test.numBlocks.vord, parameters.test.numBlocks.visual, parameters.test.numBlocks.gap];
blockLength = [parameters.test.numTime.vord, parameters.test.numTime.visual, parameters.test.numTime.gap];
numTime = [parameters.test.numTime.vord, parameters.test.numTime.visual, parameters.test.numTime.gap];
dataOut = cell(max(numBlocks),parameters.test.numConditions);

dataTemp = struct2cell(dataIn);

if type == 1
    
    % Convert concatenated matrix into individual block matrices
    for i = 1:parameters.test.numConditions
    
        counter = 1;
    
        for k = 1:numBlocks(i)
            
            if isempty(dataTemp{i})
                dataOut{k,i} = NaN(1/parameters.test.frequency*parameters.test.fr,length(counter:counter + blockLength(i) - 1));
            else
                dataOut{k,i} = dataTemp{i}(:,counter:counter + blockLength(i) - 1);
            end

            counter = counter + blockLength(i);
        end
    
    end

elseif type == 2
    
    % Convert concatenated vector into individual block vectors
    for i = 1:parameters.test.numConditions
        counter = 1;
    
        for k = 1:numBlocks(i)
            dataOut{k,i} = dataTemp{i}(counter:counter + blockLength(i)*parameters.test.fr - 1);
            counter = counter + blockLength(i)*parameters.test.fr;
        end
        
    end

elseif type == 3
    
    dataOut = cell(1,parameters.test.numConditions);

    % Convert individual block matrices into concatenated block matrix
    for i = 1:parameters.test.numConditions
        for k = 1:numBlocks(i)
            dataOut{i} = cat(2,dataTemp{i,1:numBlocks(i)});
        end
        
    end

elseif type == 4

    % Convert individual block vectors into individual block matrices
    for i = 1:parameters.test.numConditions
        for k = 1:numBlocks(i)
            dataOut{k,i} = reshape(dataTemp{i,k},1/parameters.test.frequency*parameters.test.fr,numTime(i));
        end

    end

elseif type == 5

    % Convert individual block matrices into individual block vectors
    for i = 1:parameters.test.numConditions
        for k = 1:numBlocks(i)
            dataOut{k,i} = cat(2, dataTemp{i,k}(:));
        end

    end

elseif type == 6

    dataOut = cell(1,parameters.test.numConditions);

    % Convert individual block vectors into concatenated blocks vector
    for i = 1:parameters.test.numConditions
        for k = 1:numBlocks(i)
            dataOut{i} = cat(1, dataTemp{i,1:numBlocks(i)});
        end

    end

end

