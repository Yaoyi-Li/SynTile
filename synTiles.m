%The Matlab implementation of the paper Synthesis of Tiled Patterns using Factors Graphs
%
%by Yaoyi Li
%Jan 10, 2015

close all;
clear;
clc;

rand('seed', 0);

iteraN = 30;

tileDir = './facade';
designDir = './design';
newDesignDir = './newDesigns';
constrPath = './constrain.txt';

[tileSets, numTile, inPatt, numDesign, constr] = dataReader(tileDir, designDir, constrPath);


%[G, blocks] = analysisFactor(inPatt{1});
G = {};
blocks = {};

for cntIn = 2:numDesign
	%[newG, newBlocks] = analysisFactor(inPatt{cntIn});
	
	%[G, blocks] = analysisFactor(G, blocks, inPatt{cntIn});
	
	[G, blocks, blocksByAnc] = analysisFactorNS(G, blocks, inPatt{cntIn}, numTile);
	%[G, blocks] = mergeFact(G, newG, blocks, newBlocks);
	%disp('merged');
end

KLpre = klPreprocee(inPatt, G);
[horRelat, verRelat] = symAnaly(tileSets);


disp('preprocessing finished');



[newDesignSets, KLdivList, satNumList, symList] = synBlockSS(G, blocks, blocksByAnc, constr, iteraN, tileSets, KLpre, horRelat, verRelat);

%for cntDesign = 1:numel(newDesignSets)
%	newDesign = rebuildByMat(tileSets, newDesignSets{cntDesign});
%	%KLd = klDivergence(newDesign)
%	imwrite(newDesign,[newDesignDir,'/newDesigns',num2str(cntDesign),'.jpg']);
%end

bestDesign = choseBestDesign(newDesignSets, KLdivList, satNumList, symList);
bestDesign = rebuildByMat(tileSets, bestDesign);
imwrite(bestDesign,['./bestDesign.jpg']);