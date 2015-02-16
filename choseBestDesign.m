function bestDesign = choseBestDesign(newDesignSets, KLdivList, satNumList, symList)
%
%by Yaoyi Li
%Feb 2015

newDesignSets = {newDesignSets{2:end}};
satNumList = satNumList(2:end);
symList = symList(2:end);
satNumList = abs(satNumList);
normKL = (KLdivList-mean(KLdivList))/sqrt(var(KLdivList));
normSym = (symList-mean(symList))/sqrt(var(symList));

normFac = normKL.*normSym;

numDesign = numel(newDesignSets);
index = 1:numDesign;



for cnt1 = 1:numDesign-1
	for cnt2 = cnt1+1:numDesign
		if normFac(index(cnt2)) < normFac(index(cnt1))
			tmp = index(cnt2);
			index(cnt2) = index(cnt1);
			index(cnt1) = tmp;
		end
	end
end

bestIdx = index(1);
for cnt = 2:numDesign
	if satNumList(index(cnt)) > satNumList(bestIdx)
		bestIdx = index(cnt)
	end
end

bestDesign = newDesignSets{bestIdx};