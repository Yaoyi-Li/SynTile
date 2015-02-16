function	[G, blocks] = mergeFact(G, newG, blocks, newBlocks);
%
%by Yaoyi Li
%Jan 14, 2015


G{1}{1} = [G{1}{1}, newG{1}{1}];
G{1}{2} = [G{1}{2}, newG{1}{2}];
G{2}{1} = [G{2}{1}, newG{2}{1}];
G{2}{2} = [G{2}{2}, newG{2}{2}];

for cntBlcType = 1 : numel(newBlocks)
	blocks{cntBlcType} = [blocks{cntBlcType}, newBlocks{cntBlcType}];
	
end
