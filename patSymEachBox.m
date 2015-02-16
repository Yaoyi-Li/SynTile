function isSym = patSymEachBox(box, horRelat, verRelat)
%
%by Yaoyi Li
%Feb 2015

ishSym = 1;
isvSym = 1;

[M, N] = size(box);

boxLR = fliplr(box);
boxUD = flipud(box);

jumpFlag = false;

for cntM = 1:M
	if jumpFlag
		break;
	end
	
	for cntN = 1:N
		if horRelat(box(cntM, cntN), boxLR(cntM, cntN)) < 0.5
			ishSym = 0;
			jumpFlag = true;
			break;
		end		
	end
end

jumpFlag = false;

for cntM = 1:M
	if jumpFlag
		break;
	end
	
	for cntN = 1:N
		if verRelat(box(cntM, cntN), boxUD(cntM, cntN)) < 0.5
			isvSym = 0;
			jumpFlag = true;
			break;
		end		
	end
end

isSym = ishSym + isvSym;