function miu = factorFun(G, curO, facType, posM, posN)
%Parameter:
%	G			factor graph
%	curO		current pattern 
%	facType		type of factor shape
%	posM		row number of the anchor in the curretn design 
%	posN		column number of the anchor in the curretn design 
%Return:
%	miu			value of factor function
%
%by Yaoyi Li
%Jan 10, 2015

EPSILON = 0.1;
[M, N] = size(curO);

if curO(posM, posN) == -1
	miu = -1;
	return;
end

switch facType
	case '2H'
		isFind = false;
		if posN >= N% || curO(posM, posN+1) == 0
			miu = 1;
			return;
		end
		
		fac = curO(posM, [posN,posN+1]);
		for cnt = 1:numel(G{1}{1})		
			if isequal(fac, G{1}{1}{cnt})
				isFind = true;
			end
		end
		
		if isFind
			miu = 1;
		else
			miu = 0;
		end
		
	case '2V'
		isFind = false;
		if posM >= M% || curO(posM+1, posN) == 0
			miu = 1;
			return;
		end
		
		fac = curO([posM, posM+1], posN);
		for cnt = 1:numel(G{1}{2})		
			if isequal(fac, G{1}{2}{cnt})
				isFind = true;
			end
		end
		
		if isFind
			miu = 1;
		else
			miu = 0;
		end
	
	case '4H'
		isFind = false;
		if posN+3 > N || curO(posM, posN+3) == 0
			miu = 1+EPSILON;
			return;
		end
		
		fac = curO(posM, [posN,posN+3]);
		for cnt = 1:numel(G{2}{1})		
			if isequal(fac, G{2}{1}{cnt})
				isFind = true;
			end
		end
		
		if isFind
			miu = 1+EPSILON;
		else
			miu = 1;
		end
				
	case '4V'
		isFind = false;
		if posM+3 > M || curO(posM+3, posN) == 0
			miu = 1+EPSILON;
			return;
		end
		
		fac = curO([posM, posM+3], posN);
		for cnt = 1:numel(G{2}{2})		
			if isequal(fac, G{2}{2}{cnt})
				isFind = true;
			end
		end
		
		if isFind
			miu = 1+EPSILON;
		else
			miu = 1;
		end
	
	otherwise
end
