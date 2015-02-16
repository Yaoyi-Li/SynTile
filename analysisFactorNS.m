function [G, blocks, blocksByAnc] = analysisFactorNS(G, blocks, inPatt, numTile)
%Analysis the input pattern and parameters, return the factor functions and blocks.
%Parameter:
%	inPatt		input pattern
%Return:
%	G			factor graph
%	blocks		number of the Tiles
%
%By Yaoyi Li
%Jan 29, 2014

[M, N] = size(inPatt);

if isempty(G)
	block = {};

	V2 = cell(1, numTile+1);
	H2 = cell(1, numTile+1);
	V4 = cell(1, numTile+1);
	H4 = cell(1, numTile+1);

	hard = {H2, V2};
	soft = {H4, V4};

	G = {hard, soft};

end

%---hard---
%--2H--
for cntM = 1:M
	for cntN = 1:N-1
		isFound = false;		
		tmpFact = inPatt(cntM, [cntN, cntN+1]);
		anchor = tmpFact(1,1)+1;
		for cntTiles = 1:numel(G{1}{1}{anchor})
			if isequal(tmpFact, G{1}{1}{anchor}{cntTiles})
				isFound = true;
			end
		end
		if ~isFound
			G{1}{1}{anchor} = [G{1}{1}{anchor}, {tmpFact}];
		end
	end
end

%--2V--
for cntM = 1:M-1
	for cntN = 1:N
		isFound = false;		
		tmpFact = inPatt([cntM, cntM+1], cntN);
		anchor = tmpFact(1,1)+1;
		for cntTiles = 1:numel(G{1}{2}{anchor})
			if isequal(tmpFact, G{1}{2}{anchor}{cntTiles})
				isFound = true;
			end
		end
		if ~isFound
			G{1}{2}{anchor} = [G{1}{2}{anchor}, {tmpFact}];
		end
	end
end

%---soft---
%--4H--
for cntM = 1:M
	for cntN = 1:N-3
		isFound = false;		
		tmpFact = inPatt(cntM, [cntN, cntN+3]);
		anchor = tmpFact(1,1)+1;
		for cntTiles = 1:numel(G{2}{1}{anchor})
			if isequal(tmpFact, G{2}{1}{anchor}{cntTiles})
				isFound = true;
			end
		end
		if ~isFound
			G{2}{1}{anchor} = [G{2}{1}{anchor}, {tmpFact}];
		end
	end
end

%--4V--
for cntM = 1:M-3
	for cntN = 1:N
		isFound = false;		
		tmpFact = inPatt([cntM, cntM+3], cntN);
		anchor = tmpFact(1,1)+1;
		for cntTiles = 1:numel(G{2}{2}{anchor})
			if isequal(tmpFact, G{2}{2}{anchor}{cntTiles})
				isFound = true;
			end
		end
		if ~isFound
			G{2}{2}{anchor} = [G{2}{2}{anchor}, {tmpFact}];
		end
	end
end


%----blocks----
if isempty(blocks)
	B2_1 = G{1}{1};
	B2_2 = G{1}{2};
	B3_1 = cell(1, numTile+1);
	B3_2 = cell(1, numTile+1);
	B3_3 = cell(1, numTile+1);
	B4   = cell(1, numTile+1); 
	B6_1 = cell(1, numTile+1);
	B6_2 = cell(1, numTile+1);
	B9   = cell(1, numTile+1);
	B16  = cell(1, numTile+1);

	blocks = {B2_1, B2_2, B3_1, B3_2, B3_3, B4, B6_1, B6_2, B9, B16};
end

%--B3--
for cntM = 1:M-1
	for cntN = 1:N-1
		tmpBlc = inPatt([cntM, cntM+1], [cntN, cntN+1]);
		
		anchor = tmpBlc(1,1)+1;
		
		tmpBlc1 = tmpBlc;
		tmpBlc1(2,2) = 0;
		tmpBlc2 = tmpBlc;
		tmpBlc2(2,1) = 0;
		tmpBlc3 = tmpBlc;
		tmpBlc3(1,2) = 0;

		isFound = false;

		for cntBlocks = 1:numel(blocks{3}{anchor})
			if isequal(tmpBlc1, blocks{3}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{3}{anchor} = [blocks{3}{anchor}, {tmpBlc1}];
		end


		isFound = false;

		for cntBlocks = 1:numel(blocks{4}{anchor})
			if isequal(tmpBlc2, blocks{4}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{4}{anchor} = [blocks{4}{anchor}, {tmpBlc2}];
		end


		isFound = false;

		for cntBlocks = 1:numel(blocks{5}{anchor})
			if isequal(tmpBlc3, blocks{5}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{5}{anchor} = [blocks{5}{anchor}, {tmpBlc3}];
		end

	end
end

%--B4--
for cntM = 1:M-1
	for cnt = 1:N-1
		tmpBlc = inPatt([cntM, cntM+1], [cntN, cntN+1]);
		anchor = tmpBlc(1,1)+1;
		
		isFound = false;
		for cntBlocks = 1:numel(blocks{6}{anchor})
			if isequal(tmpBlc, blocks{6}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{6}{anchor} = [blocks{6}{anchor}, {tmpBlc}];
		end
	end
end

%--B6--
for cntM = 1:M-1
	for cntN = 1:N-2
		tmpBlc = inPatt(cntM:cntM+1, cntN:cntN+2);
		anchor = tmpBlc(1,1)+1;

		isFound = false;
		for cntBlocks = 1:numel(blocks{7}{anchor})
			if isequal(tmpBlc, blocks{7}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{7}{anchor} = [blocks{7}{anchor}, {tmpBlc}];
		end
	end
end

for cntM = 1:M-2
	for cntN = 1:N-1
		tmpBlc = inPatt(cntM:cntM+1, cntN:cntN+1);
		anchor = tmpBlc(1,1)+1;

		isFound = false;
		for cntBlocks = 1:numel(blocks{8}{anchor})
			if isequal(tmpBlc, blocks{8}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{8}{anchor} = [blocks{8}{anchor}, {tmpBlc}];
		end
	end
end

%--B9--
for cntM = 1:M-2
	for cntN = 1:N-2
		tmpBlc = inPatt(cntM:cntM+2, cntN:cntN+2);
		anchor = tmpBlc(1,1)+1;

		isFound = false;
		for cntBlocks = 1:numel(blocks{9}{anchor})
			if isequal(tmpBlc, blocks{9}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{9}{anchor} = [blocks{9}{anchor}, {tmpBlc}];
		end
	end
end

%--B16--
for cntM = 1:M-3
	for cntN = 1:N-3
		tmpBlc = inPatt(cntM:cntM+3, cntN:cntN+3);
		anchor = tmpBlc(1,1)+1;

		isFound = false;
		for cntBlocks = 1:numel(blocks{10}{anchor})
			if isequal(tmpBlc, blocks{10}{anchor}{cntBlocks})
				isFound = true;
			end
		end
		if ~isFound
			blocks{10}{anchor} = [blocks{10}{anchor}, {tmpBlc}];
		end
	end
end


blocksByAnc = cell(1, numTile+1);
for cntAnc = 1:numTile+1
	for cntType = 1:10
		blocksByAnc{cntAnc} = [blocksByAnc{cntAnc}, blocks{cntType}{cntAnc}];
	end
end
