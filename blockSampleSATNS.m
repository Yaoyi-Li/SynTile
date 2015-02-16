function [pattern, satNum] = blockSampleSATNS(G, aux, constr, blocks, blocksByAnc, numTile, curPattern, iteraN, satParam)
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
%Jan 30, 2015

pattern = curPattern;
[M, N] = size(pattern);
numFactor = numel(aux);

pWalk = satParam(1);
pFlip = satParam(2);
pSmooth = satParam(3);
T = satParam(4);


blocksPool = {};
for cntBlc = 1:numel(blocksByAnc)
	blocksPool = [blocksPool, blocksByAnc{cntBlc}];
end


for cntIteraN = 1:iteraN
	%if mod(cntIteraN, 100) == 0
	%	cntIteraN
	%end

	facValue = zeros(M, N, 4);
	for cntM = 1:M
		for cntN = 1:N
			facValue(cntM, cntN, :) = factorsFunNS(G, pattern, cntM, cntN);
		end
	end

	uWalk = rand();
	if uWalk < pWalk
		[facType, anchorPos] = selecUnsatFact(facValue, aux);
		if facType == 0
			satNum = 0-getSatNum(G, pattern, aux, [1,1], 1);
			return;
		end
				
		uSmooth = rand();
		if uSmooth < pSmooth
		
			if facType == 1 && anchorPos(2) > 1
				
				anchor = pattern(anchorPos(1),anchorPos(2)-1)+1;
				maxSatNum = 0;
				bestBlockIdx = 0;
				
				newAnchorPos = [anchorPos(1), anchorPos(2)-1];
				
				for cntBlc = randperm(numel(blocks{7}{anchor}))
					[tmpPattern, isReplaced] = patReplace(pattern, blocks{7}{anchor}{cntBlc}, newAnchorPos, constr);
					satNum = getSatNum(G, tmpPattern, aux, newAnchorPos, 0);
					if satNum > maxSatNum
			            bestBlockIdx = cntBlc;
			            maxSatNum = satNum;
					end
			    end
			
				if bestBlockIdx > 0 && maxSatNum >= getSatNum(G, pattern, aux, newAnchorPos, 0);
			        [pattern, isReplaced] = patReplace(pattern, blocks{7}{anchor}{bestBlockIdx}, newAnchorPos, constr);
					continue;
				%else
				%	if rand() < 0.1
				%		pattern(anchorPos(1),anchorPos(2)-1) = ceil(rand()*numTile);
				%		continue;
				%	end
				end
			end
			
			if facType == 2 && anchorPos(1) > 1
				
				anchor = pattern(anchorPos(1)-1,anchorPos(2))+1;
				maxSatNum = 0;
				bestBlockIdx = 0;
				
				newAnchorPos = [anchorPos(1)-1, anchorPos(2)];
				
				for cntBlc = randperm(numel(blocks{8}{anchor}))
					[tmpPattern, isReplaced] = patReplace(pattern, blocks{8}{anchor}{cntBlc}, newAnchorPos, constr);
					satNum = getSatNum(G, tmpPattern, aux, newAnchorPos, 0);
					if satNum > maxSatNum
						bestBlockIdx = cntBlc;
			            maxSatNum = satNum;
					end
			    end
			
				if bestBlockIdx > 0 && maxSatNum >= getSatNum(G, pattern, aux, newAnchorPos, 0);
			        [pattern, isReplaced] = patReplace(pattern, blocks{8}{anchor}{bestBlockIdx}, newAnchorPos, constr);
					continue;
				%else
				%	if rand() < 0.1
				%		pattern(anchorPos(1),anchorPos(2)-1) = ceil(rand()*numTile);
				%		continue;
				%	end
				end
			end
					
		end		
		
		
		
		anchor = pattern(anchorPos(1), anchorPos(2))+1;
		
		
		if facType == 1 && pattern(anchorPos(1),anchorPos(2)+1) == 0
			anchorPos(2) = anchorPos(2)-1;
			anchor = pattern(anchorPos(1), anchorPos(2))+1;
		elseif facType == 2 && pattern(anchorPos(1)+1,anchorPos(2)) == 0
			anchorPos(1) = anchorPos(1)-1;
			anchor = pattern(anchorPos(1), anchorPos(2))+1;
		end
			
		uFlip = rand();
		if uFlip < pFlip
			if isempty(blocksByAnc{anchor})
				pattern(anchorPos(1), anchorPos(2)) = ceil(rand()*numTile+1e-5);
			else
				randBlcIdxs = randperm(numel(blocksByAnc{anchor}));
				randBlcIdx = randBlcIdxs(1);
				[pattern, isReplaced] = patReplace(pattern, blocksByAnc{anchor}{randBlcIdx}, anchorPos, constr);
				
			end
		
		else
			blcPoolIdx = [];
			switch facType
				case 1
					blcPoolIdx = [1, 3, 4, 6, 7, 8, 9, 10];
				case 2
					blcPoolIdx = [2, 3, 5, 6, 7, 8, 9, 10];
				otherwise
					blcPoolIdx = [10];
			end
			
			
			tmpBlocksSet = {};
			for cntBlcIdx = blcPoolIdx
				tmpBlocksSet = [tmpBlocksSet, blocks{cntBlcIdx}{anchor}];
			end
			
			maxSatNum = 0;
			bestBlocksIdx = 0;
			
			for cntBlc = randperm(numel(tmpBlocksSet))
				[tmpPattern, isReplaced] = patReplace(pattern, tmpBlocksSet{cntBlc}, anchorPos, constr);
				satNum = getSatNum(G, tmpPattern, aux, anchorPos, 0);
				if satNum > maxSatNum
                    bestBlockIdx = cntBlc;
                    maxSatNum = satNum;
				end
            end
		
			if bestBlockIdx > 0
                [pattern, isReplaced] = patReplace(pattern, tmpBlocksSet{bestBlockIdx}, anchorPos, constr);
			end
			
		end
	
	else
				
		for  cntAnc = 1:1000			
			randM = ceil(rand()*(M-1));
			randN = ceil(rand()*(N-1));
			if pattern(randM, randN) > 0
				break;
			end
			if cntAnc == 1000
				randM = floor(M/2);
				randN = floor(N/2);
			end
		end
		
		anchorPos = [randM, randN];
		%anchor = pattern(randM, randN)+1;
		
		cOld = getSatNum(G, pattern, aux, anchorPos, 0);
		
		%loopTimes = ceil(rand()*numel(blocksByAnc{anchor})+1e-5);
		loopTimes = ceil(rand()*numel(blocksPool));
		newPattern = zeros(M, N);
		for cntBlc = loopTimes:-1:1
			%[newPattern, isReplaced] = patReplace(pattern, blocksByAnc{anchor}{cntBlc}, anchorPos, constr);
			[newPattern, isReplaced] = patReplace(pattern, blocksPool{cntBlc}, anchorPos, constr);
			if isReplaced
				%disp('mutated.');
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

satNum = getSatNum(G, pattern, aux, [1,1], 1);



function [facType, anchorPos] = selecUnsatFact(facValue, aux)

randSelec = randperm(2);
facType = 0;
unsatPos = [0,0];
anchorPos = [1,1];

%for cntM = 1:size(facValue, 1)
%	for cnrN = 1:size(facValue, 2)
for cntM = randperm(size(facValue, 1))
	for cntN = randperm(size(facValue, 2))
		for rdFac = randSelec
			if aux(cntM, cntN, rdFac) >= 0 && facValue(cntM, cntN, rdFac) <= aux(cntM, cntN, rdFac)
				facType = rdFac;
				anchorPos = [cntM, cntN];
				return;
			end
		end
	end
end


function satNum = getSatNum(G, pattern, aux, anchorPos, satNumType)
%	satNumType			0 for local, 1 for global

[M, N] = size(pattern);

satNum = 0;

if satNumType == 0
	startM = max(anchorPos(1)-3, 1);
	startN = max(anchorPos(2)-3, 1);
	endM = min(anchorPos(1)+3, M);
	endN = min(anchorPos(2)+3, N);

	facValue = zeros(endM-startM+1, endN-startN+1, 4);
	for cntM = startM:endM
		for cntN = startN:endN
			tmpValue = factorsFunNS(G, pattern, cntM, cntN);
			tmpAux = aux(cntM, cntN, :);
			satNum = satNum + sum(tmpValue > tmpAux(:));
		end
	end
else
	facValue = zeros(M, N, 4);

	for cntM = 1:M
		for cntN = 1:N

			tmpValue = factorsFunNS(G, pattern, cntM, cntN);
			tmpAux = aux(cntM, cntN, :);
			satNum = satNum + sum(tmpValue > tmpAux(:));
		end
	end
end

