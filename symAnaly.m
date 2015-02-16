function [horRelat, verRelat] = symAnaly(tileSets)
%
%by Yaoyi Li
%Feb 2015

numTile = numel(tileSets);

horRelat = zeros(numTile, numTile);
verRelat = zeros(numTile, numTile);

longTile = tileSets{1};

for cntTiles = 2:numTile
	longTile = [longTile;tileSets{cntTiles}];
end

thresh = graythresh(longTile);

bwTileSets = {};

for cntTiles = 1:numTile
	bwTileSets{cntTiles} = im2bw(tileSets{cntTiles}, thresh);
end

for cntSourceTiles = 1:numTile
	%cntSourceTiles
	tileLR = fliplr(bwTileSets{cntSourceTiles});	
	tileUD = flipud(bwTileSets{cntSourceTiles});
	
	for cntObjTiles = cntSourceTiles:numTile
		horRelat(cntSourceTiles, cntObjTiles) = symEachTile(tileLR, bwTileSets{cntObjTiles});
		verRelat(cntSourceTiles, cntObjTiles) = symEachTile(tileUD, bwTileSets{cntObjTiles});
	end
end

horRelat = triu(horRelat,1)' + horRelat;
verRelat = triu(verRelat,1)' + verRelat;
