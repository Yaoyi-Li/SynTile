function relat = symEachTile(tile1, tile2)
%
%by Yaoyi Li
%Feb 2015

[M, N] = size(tile1);
blank = ones(M,N);
tile1 = blank - (tile1);
tile2 = blank - (tile2);

rangM = floor(0.05*M);
rangN = floor(0.05*N);

relatList = zeros(1,4*rangM*rangN);

for startM = 1:rangM
	for startN = 1:rangN
	
		tile1tmp = tile1(startM:end, startN:end);
		tile2tmp = tile2(1:end+1-startM, 1:end+1-startN);
		
		%relatList(rangM*(startM-1)+startN) = sum(sum(tile1tmp&tile2tmp))/sum(sum(tile1tmp|tile2tmp));
		relatList(rangM*(startM-1)+startN) = sum(sum(tile1tmp.*tile2tmp))/sum(sum(ceil((tile1tmp+tile2tmp)/2)));
	end
end

for startM = 1:rangM
	for startN = 1:rangN
	
		tile1tmp = tile1(1:end+1-startM, 1:end+1-startN);
		tile2tmp = tile2(startM:end, startN:end);
		
		%relatList(rangM*(startM-1)+startN) = sum(sum(tile1tmp&tile2tmp))/sum(sum(tile1tmp|tile2tmp));
		relatList(rangM*rangN+rangM*(startM-1)+startN) = sum(sum(tile1tmp.*tile2tmp))/sum(sum(ceil((tile1tmp+tile2tmp)/2)));
	end
end

for startM = 1:rangM
	for startN = 1:rangN
	
		tile1tmp = tile1(startM:end, 1:end+1-startN);
		tile2tmp = tile2(1:end+1-startM, startN:end);
		
		%relatList(rangM*(startM-1)+startN) = sum(sum(tile1tmp&tile2tmp))/sum(sum(tile1tmp|tile2tmp));
		relatList(2*rangM*rangN+rangM*(startM-1)+startN) = sum(sum(tile1tmp.*tile2tmp))/sum(sum(ceil((tile1tmp+tile2tmp)/2)));
	end
end

for startM = 1:rangM
	for startN = 1:rangN
	
		tile1tmp = tile1(1:end+1-startM, startN:end);
		tile2tmp = tile2(startM:end, 1:end+1-startN);
		
		%relatList(rangM*(startM-1)+startN) = sum(sum(tile1tmp&tile2tmp))/sum(sum(tile1tmp|tile2tmp));
		relatList(3*rangM*rangN+rangM*(startM-1)+startN) = sum(sum(tile1tmp.*tile2tmp))/sum(sum(ceil((tile1tmp+tile2tmp)/2)));
	end
end
%relat = 0;
relat = max(relatList);