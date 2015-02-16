function [tileSets, numTile, inPatt, numDesign, constr] = dataReader(tileDir, designDir, constrPath)
%Parameter:
%
%Return:
%
%by Yaoyi Li
%Jan 10, 2015



tileNameArray = dir([tileDir,'/*.jpg']);
numTile = numel(tileNameArray);
tileSets = cell(1,numTile);

for cnt = 1:numTile
	tmpTile = imread([tileDir,'/',num2str(cnt),'.jpg']);
	if size(tmpTile,3)>1
		tmpTile = rgb2gray(tmpTile);
	end
	tileSets{cnt} = tmpTile;
end


designNameArray = dir([designDir,'/design*.txt']);
numDesign = numel(designNameArray);
inPatt = cell(1,numDesign);

for cnt = 1:numDesign
	tmpDesign = load([designDir,'/design',num2str(cnt),'.txt']);
	inPatt{cnt} = tmpDesign;
end

constr = load(constrPath);
