function miu = factorsFunNS(G, curO, posM, posN)
%Parameter:
%	G			factor graph
%	curO		current pattern 
%	posM		row number of the anchor in the curretn design 
%	posN		column number of the anchor in the curretn design 
%Return:
%	miu			value of factor function
%
%by Yaoyi Li
%Jan 30, 2015

%miu = zeros(6, 1);
%miu(1) = posM;
%miu(2) = posN;
%miu(3) = factorFunNS(G, curO, '2H', posM, posN);
%miu(4) = factorFunNS(G, curO, '2V', posM, posN);
%miu(5) = factorFunNS(G, curO, '4H', posM, posN);
%miu(6) = factorFunNS(G, curO, '4V', posM, posN);

miu = zeros(4, 1);
miu(1) = factorFunNS(G, curO, '2H', posM, posN);
miu(2) = factorFunNS(G, curO, '2V', posM, posN);
miu(3) = factorFunNS(G, curO, '4H', posM, posN);
miu(4) = factorFunNS(G, curO, '4V', posM, posN);
