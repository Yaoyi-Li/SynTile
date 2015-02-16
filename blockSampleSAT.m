function pattern = blockSampleSAT(G, aux, constr, blocks, curPattern, iteraN, satParam)
%Sample function with blocks.
%Parameter:
%	G			factor graph
%	aux			auxiliary variables
%	blocks		replacement blocks
%	curPattern	current pattern
%	iteraN		maximum iteration
%	satParam	vector of parameters for sampleSAT (pWalk, pFlip, T)
%Return:
%	pattern		pattern after sampled
%
%by Yaoyi Li
%Dec 19, 2014
pattern = curPattern;
[M, N] = size(pattern);
numFactor = numel(aux);

pWalk = satParam(1);
pFlip = satParam(2);
T = satParam(3);

for cntIteraN = 1:iteraN
    if mod(cntIteraN, 20) == 0
        cntIteraN
    end
	%cntIteraN
	cntFac = 1;
	facValue = zeros(6,M*N);
	for cntM = 1:M
		for cntN = 1:N
			%if pattern(cntM, cntN) ~= 0
				facValue(:,cntFac) = factorsFun(G, pattern, cntM, cntN);
				cntFac = cntFac + 1;
			%end
		end
	end


	uWalk = rand();
	if uWalk < pWalk
		%anchorPos = zeros(2,1);
		[facType, anchorPos] = selecUnsatFact(facValue, aux);
		if facType == 0
			%disp('no unsatisfied');
			return;
		end
		
		%disp('unsatisfied');
		
		
		uFlip = rand();
		if uFlip < pFlip
			for cnt = 1:1000
				randBlcType = ceil(rand()*6);
				%randBlcIdx = ceil(rand()*numel(blocks{randBlcType}));
				%[bM, bN] = size(blocks{randBlcType}{randBlcIdx});
				
                tmpBlocksSet = {};
                for cntBlc = 1:numel(blocks{randBlcType})
                    tmpBlc = blocks{randBlcType}{cntBlc};
                    if tmpBlc(1,1) == pattern(anchorPos(1), anchorPos(2))
                        tmpBlocksSet = [tmpBlocksSet, {tmpBlc}];
                    end
                end
                randBlcIdxs =  randperm(numel(tmpBlocksSet));
                if ~isempty(randBlcIdxs)
                    randBlcIdx = randBlcIdxs(1);
                    %[pattern, isReplaced] = patReplace(pattern, blocks{randBlcType}{randBlcIdx}, anchorPos, constr);
                    [pattern, isReplaced] = patReplace(pattern, tmpBlocksSet{randBlcIdx}, anchorPos, constr);
                    %isReplaced
                    if isReplaced
                        break;
                    end
                end
			end
		
		else
			randBlcType = ceil(rand()*6);
           
			if facType > 2
				randBlcType = 6;
				break;
            end
			
            for cnt = 1 : 6
                tmpBlocksSet = {};
                for cntBlc = 1:numel(blocks{randBlcType})
                    tmpBlc = blocks{randBlcType}{cntBlc};

                    [bM, bN] = size(tmpBlc);

                    if bM < facType || bN < 3 - facType
                        continue;
                    end

                    if (facType == 1 && tmpBlc(1,2) == 0) || (facType == 2 && tmpBlc(2,1) == 0 )
                        continue;
                    end

                    if tmpBlc(1,1) == pattern(anchorPos(1), anchorPos(2))
                        tmpBlocksSet = [tmpBlocksSet, {tmpBlc}];
                    end
                end
    %             randBlcIdxs =  randperm(numel(tmpBlocksSet));

                maxSatNum = 0;
                bestBlockIdx = 0;
    % 			for cntBlc = 1:numel(blocks{randBlcType})
    % 				tmpBlock = blocks{randBlcType}{cntBlc};
    % 				[bM, bN] = size(tmpBlock);
    % 				
    % 				if bM < facType || bN < 3 - facType
    % 					continue;
    % 				end
    % 			
    % 				if (facType == 1 && tmpBlock(1,2) == 0) || (facType == 2 && tmpBlock(2,1) == 0 )
    % 					continue;
    % 				end

    % 				[tmpPattern, isReplaced] = patReplace(pattern, blocks{randBlcType}{cntBlc}, anchorPos, constr);
                    %isReplaced
                for cntBlc = 1:numel(tmpBlocksSet)
                    [tmpPattern, isReplaced] = patReplace(pattern, tmpBlocksSet{cntBlc}, anchorPos, constr);
                    satNum = getSatNum(G, tmpPattern, aux, anchorPos, 0);
                    if satNum > maxSatNum
                        bestBlockIdx = cntBlc;
                        maxSatNum = satNum;
                    end
                end

                if 	bestBlockIdx > 0
                    [pattern, isReplaced] = patReplace(pattern, blocks{randBlcType}{bestBlockIdx}, anchorPos, constr);
                    if isReplaced
                        break;
                    end
                    
                else
                    randBlcType = randBlcType-1;
                    if randBlcType < 1
                        break;
                    end
                end
            end
		end
			
	else
	
		randM = 1;
		randN = 1;
		
		for cnt = 1:1000
			randM = ceil(rand()*(M-1));
			randN = ceil(rand()*(N-1));
			if pattern(randM, randN) ~= 0
				break;
			end
		end
		
		anchorPos = [randM, randN];
		
		cOld = getSatNum(G, pattern, aux, anchorPos, 0);
		
		for cnt = 1:1000
			randBlcType = ceil(rand()*6);
			randBlcIdx = ceil(rand()*numel(blocks{randBlcType}));
			[newPattern, isReplaced] = patReplace(pattern, blocks{randBlcType}{randBlcIdx}, anchorPos, constr);
			%isReplaced
			if isReplaced
				break;
			end
		end
		
		cNew = getSatNum(G, newPattern, aux, anchorPos, 0);
		
		uAccept = rand();
		
		if uAccept < min(1, exp((cNew - cOld)/T))
			pattern = newPattern;
		end
		
	end
	
end


function [facType, anchorPos] = selecUnsatFact(facValue, aux)

randSelec = randperm(2);
facType = 0;
unsatPos = zeros(2,1);
anchorPos = [1,1];
%fac = size(facValue,2)

for cntFac = 1:size(facValue,2)
	for cntConst = randSelec
		%cntConst
		%au = aux(cntConst+2, cntFac)
		%fa = facValue(cntConst+2, cntFac)
		if aux(cntConst+2, cntFac) >= 0 && facValue(cntConst+2, cntFac) <= aux(cntConst+2, cntFac)
			facType = cntConst;
			anchorPos = facValue([1,2], cntFac);
			%anchorPosM = anchorPos(1);
			%anchorPosN = anchorPos(2);
			return;
		end
	end
end


function satNum = getSatNum(G, pattern, aux, anchorPos, satNumType)
%	satNumType		0 for local, 1 for global

[M, N] = size(pattern);

satNum = 0;

if satNumType == 0
	startM = max(anchorPos(1)-3, 1);
	startN = max(anchorPos(2)-3, 1);
	endM = min(anchorPos(1)+3, M);
	endN = min(anchorPos(2)+3, N);
	
	facValue = zeros(6,(endM - startM + 1)*(endN - startN + 1));

	for cntM = startM : endM
		for cntN = startN : endN
			tmpValue = factorsFun(G, pattern, cntM, cntN);
			satNum = satNum + sum(tmpValue(3:6) > aux(3:6,(cntM-1)*N+cntN));
		end
	end

else
	facValue = zeros(6, M*N);

	for cntM = 1 : M
		for cntN = 1 : N
			tmpValue = factorsFun(G, pattern, cntM, cntN);
			satNum = satNum + sum(tmpValue(3:6) > aux(3:6,(cntM-1)*N+cntN));
		end
	end	
end
