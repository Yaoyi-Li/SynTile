function [G, blocks] = analysisFactor(G, blocks, inPatt)
%Analysis the input pattern and parameters, return the factor functions and blocks.
%Parameter:
%	inPatt		input pattern
%Return:
%	G			factor graph
%	blocks		number of the Tiles
%
%By Yaoyi Li
%Dec 16, 2014



[M, N] = size(inPatt);

if isempty(G)

	blocks = {};

	V2 = {};
	H2 = {};
	V4 = {};
	H4 = {};

	hard = {H2,V2};
	soft = {H4,V4};

	G = {hard,soft};
end

%---hard--- 
%--2H--
for cntM = 1:M
	for cntN = 1:N-1
		isFound = 0;
		for cntTiles = 1:numel(G{1}{1})
			if isequal(inPatt(cntM,[cntN,cntN+1]),G{1}{1}{cntTiles})
				isFound = 1;
			end
		end
		if ~isFound
			G{1}{1} = [G{1}{1},{inPatt(cntM,[cntN,cntN+1])}];
		end
	end
end

%--2V--
for cntM = 1:M-1
	for cntN = 1:N
		isFound = 0;
		for cntTiles = 1:numel(G{1}{2})
			if isequal(inPatt([cntM, cntM+1],cntN),G{1}{2}{cntTiles})
				isFound = 1;
			end
		end
		if ~isFound
			G{1}{2} = [G{1}{2},{inPatt([cntM, cntM+1],cntN)}];
		end
	end
end

%---soft---
%--4H--
for cntM = 1:M
	for cntN = 1:N-3
		isFound = 0;
		for cntTiles = 1:numel(G{2}{1})
			if isequal(inPatt(cntM,cntN:cntN+3),G{2}{1}{cntTiles})
				isFound = 1;
			end
		end
		if ~isFound
			G{2}{1} = [G{2}{1},{inPatt(cntM,cntN:cntN+3)}];
		end
	end
end

%--4V--
for cntM = 1:M-3
	for cntN = 1:N
		isFound = 0;
		for cntTiles = 1:numel(G{2}{2})
			if isequal(inPatt(cntM:cntM+3,cntN),G{2}{2}{cntTiles})
				isFound = 1;
			end
		end
		if ~isFound
			G{2}{2} = [G{2}{2},{inPatt(cntM:cntM+3,cntN)}];
		end
	end
end


%----blocks----
if isempty(blocks)
    B2 = [G{1}{1},G{1}{2}];
    B3 = {};
    B4 = {};
    B5 = {};
    B6 = {};
    B7 = {};

    blocks = {B2,B3,B4,B5,B6,B7};
end

B3record = {};
    
%--B3--
for cntM = 1:M-1
	for cntN = 1:N-1
		isFound = 0;
		tmpBlocks = inPatt([cntM,cntM+1],[cntN,cntN+1]);
		for cntBlocks = 1:numel(B3record)
			if isequal(tmpBlocks, B3record{cntBlocks})
				isFound = 1;
			end
		end
		if ~isFound
			B3record = [B3record,{tmpBlocks}];
			tmpB31 = tmpBlocks;
			tmpB31(1,2) = 0;
			tmpB32 = tmpBlocks;
			tmpB32(2,2) = 0;
			tmpB33 = tmpBlocks;
			tmpB33(2,1) = 0;
			blocks{2} = [blocks{2},{tmpB33},{tmpB32},{tmpB31}];
		end
	end
end

%--B4--
for cntM = 1:M-1
	for cntN = 1:N-1
		isFound = 0;
		tmpBlocks = inPatt([cntM,cntM+1],[cntN,cntN+1]);
		for cntBlocks = 1:numel(blocks{3})
			if isequal(tmpBlocks, blocks{3}{cntBlocks})
				isFound = 1;
			end
		end
		if ~isFound
			blocks{3} = [blocks{3},{tmpBlocks}];
		end
	end
end

%--B5--
for cntM = 1:M-1
	for cntN = 1:N-2
		isFound = 0;
		tmpBlocks = inPatt(cntM:cntM+1,cntN:cntN+2);
		for cntBlocks = 1:numel(blocks{4})
			if isequal(tmpBlocks, blocks{4}{cntBlocks})
				isFound = 1;
			end
		end
		if ~isFound
			blocks{4} = [blocks{4},{tmpBlocks}];
		end
	end
end

for cntM = 1:M-2
	for cntN = 1:N-1
		isFound = 0;
		tmpBlocks = inPatt(cntM:cntM+2,cntN:cntN+1);
		for cntBlocks = 1:numel(blocks{4})
			if isequal(tmpBlocks, blocks{4}{cntBlocks})
				isFound = 1;
			end
		end
		if ~isFound
			blocks{4} = [blocks{4},{tmpBlocks}];
		end
	end
end

%--B6--
for cntM = 1:M-2
	for cntN = 1:N-2
		isFound = 0;
		tmpBlocks = inPatt(cntM:cntM+2,cntN:cntN+2);
		for cntBlocks = 1:numel(blocks{5})
			if isequal(tmpBlocks, blocks{5}{cntBlocks})
				isFound = 1;
			end
		end
		if ~isFound
			blocks{5} = [blocks{5},{tmpBlocks}];
		end
	end
end

%--B7--
for cntM = 1:M-3
	for cntN = 1:N-3
		isFound = 0;
		tmpBlocks = inPatt(cntM:cntM+3,cntN:cntN+3);
		for cntBlocks = 1:numel(blocks{6})
			if isequal(tmpBlocks, blocks{6}{cntBlocks})
				isFound = 1;
			end
		end
		if ~isFound
			blocks{6} = [blocks{6},{tmpBlocks}];
		end
	end
end


