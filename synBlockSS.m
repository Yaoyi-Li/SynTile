function [O, KLdivList, satNumList, symList] = synBlockSS(G, blocks, blocksByAnc, constr, iteraN, tileSets, KLpre, horRelat, verRelat)
%Parameter:
%	G			factor graph
%	blocks		replacement blocks
%	constr		constraint matrix
%	numTile		number of tiles
%	iteraN		maximum iteration
%Return:
%	O			cell of patterns
%
%by Yaoyi Li
%Dec 19, 2014


newDesignDir = './newDesigns';

numTile = numel(tileSets);

designTileNum = 2*sum(sum(constr));

pWlakOrig = 0.8;
pFlipOrig = 0.1;
pSmoothOrig = 0;
TOrig = 0.25;

pWlak = pWlakOrig;
pFlip = pFlipOrig;
pSmooth = pSmoothOrig;
T = TOrig;

[M, N] = size(constr);

curO = ceil(rand(M, N)*numTile);
curO = (curO&constr).*curO;
curO = (curO&(constr+1)).*curO;
O = {curO};

KLdivList = zeros(1,iteraN);
satNumList = zeros(1,iteraN+1);
symList = zeros(1,iteraN+1);
satDecr = 0;
for cnt = 1:iteraN
	numSites = sum(sum(constr~=0));
	%miu = zeros(6,numSites);
	%facValue = zeros(6,numSites);
	miu = zeros(M, N, 4);
	tmpFacValue = zeros(4, 1);
	
	cntFac = 1;
	%curO = O{cnt};
	for cntM = 1:M
		for cntN = 1:N
			%if curO(cntM, cntN) ~= 0
				%miu(1,cntFac) = factorFun(G, curO, '2H', cntM, cntN);
				%miu(2,cntFac) = factorFun(G, curO, '2V', cntM, cntN);
				%miu(3,cntFac) = factorFun(G, curO, '4H', cntM, cntN);
				%miu(4,cntFac) = factorFun(G, curO, '4V', cntM, cntN);
				
				%facValue(:,cntFac) = factorsFun(G, curO, cntM, cntN);
				tmpFacValue = factorsFunNS(G, curO, cntM, cntN);
				%miu(:,cntFac) = [1;1;rand(4,1)+1e-5].*facValue(:,cntFac);
				miu(cntM, cntN, :) = (rand(4,1)+1e-5).*tmpFacValue;
				%cntFac = cntFac + 1;
			%end
		end
	end
	
	%newO = blockSampleSAT(G, miu, constr, blocks, curO, 1000, [0.8, 0.1, 0.25]);
	tic
	[curO, satNum] = blockSampleSATNS(G, miu, constr, blocks, blocksByAnc, numTile, curO, designTileNum, [pWlak, pFlip, pSmooth, T]);
	toc
	%disp('one finished');
	%curO = newO;
    
    %newDesign = rebuildByMat(tileSets, curO);
	
	%imwrite(newDesign,['./tmp.jpg']);
	
	symList(cnt+1) = patSymAnaly(curO, horRelat, verRelat);
	
	
	disp(['symNum is ',num2str(symList(cnt+1))]);
	
	KLdiv = klDivergence(KLpre, curO)
	KLdivList(cnt) = KLdiv;
	KLdivMin = KLdiv;
	%choseConst = min(0.5+0.5*exp(-(satNum - satNumList(cnt))/10), 0.95);
	%for cntKLdiv = cnt:-1:1
	%	if KLdivList(cntKLdiv) < KLdivMin*choseConst
	%		KLdivMin = KLdivList(cntKLdiv)
	%		curO = O{cntKLdiv+1};
	%	end
	%end
	
	
	disp(['satNum is ',num2str(satNum)]);
	satNumList(cnt+1) = satNum;
	if satNum <= satNumList(cnt)
		%if symList(cnt+1) > symList(cnt)
		%	O = [O,curO];
		%	satDecr = 0;
		%	disp('Local optimum. Resample.');
		%	curO = ceil(rand(M, N)*numTile);
		%	curO = (curO&constr).*curO;
		%	continue;
		%end
		
		satDecr = satDecr + 1;
		T = T*2;
		pWlak = pWlak + 0.5*(1-pWlak);
		pFlip = pFlip*0.75;
		pSmooth = pSmooth+0.5*(1-pSmooth);
	else
		%satDecr = max(0,satDecr - 1);
		T = TOrig;
		pWlak = pWlakOrig;
		pFlip = pFlipOrig;
		pSmooth = pSmoothOrig;
	end
	
	
	
	newDesign = rebuildByMat(tileSets, curO);
	imwrite(newDesign,['./tmp.jpg']);
	imwrite(newDesign,[newDesignDir,'/newDesign',num2str(cnt),'.jpg']);
	
	
	if satNum < 0
		O = [O,curO];
		satDecr = 0;
		disp('Global optimum. Resample.');
		curO = ceil(rand(M, N)*numTile);
		curO = (curO&constr).*curO;
		continue;
	end
	
	if satDecr >= 2
		O = [O,curO];
		satDecr = 0;
		disp('Local optimum. Resample.');
		curO = ceil(rand(M, N)*numTile);
		curO = (curO&constr).*curO;
		continue;
	end
	
	
	O = [O,curO];
	
end
% O = {O{6:end}};
