function image = rebuildByMat(tileSets, mat)
%Rebuild the image by the index matrix of the design
%Parameter:
%	tileDir		the directory of tiles
%	mat			the index matrix of the design
%Return
%	image		the image rebuilded
%
%by Yaoyi Li
%Dec 17, 2014

%tileNameArray = dir([tileDir,'/*.jpg']);
%numTile = numel(tileNameArray);
%tileSets = cell(1,numTile);

%for cnt = 1:numTile
%	tmpTile = imread([tileDir,'/',num2str(cnt),'.jpg']);
%	if size(tmpTile,3)>1
%		tmpTile = rgb2gray(tmpTile);
%	end
%	tileSets{cnt} = tmpTile;
%end

[M,N] = size(tileSets{1});

[matM, matN] = size(mat);
image = zeros(matM*M, matN*N);

for cntM = 1:matM
	for cntN = 1:matN
		if mat(cntM, cntN) == 0
			image((cntM-1)*M+1:cntM*M, (cntN-1)*N+1:cntN*N) = 255*ones(M,N);
		else
			%[tmpM,tmpN] = size(tileSets{mat(cntM,cntN)});
			%image((cntM-1)*M+1:(cntM-1)*M+tmpM, (cntN-1)*N+1:(cntN-1)*N+tmpN) = tileSets{mat(cntM,cntN)};
			image((cntM-1)*M+1:cntM*M, (cntN-1)*N+1:cntN*N) = tileSets{mat(cntM,cntN)};
		end
	end
end

image = uint8(image);

%imwrite(image,'tmpDesign.jpg');
%imshow(image);