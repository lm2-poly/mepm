function [ReqError,dRi] = calculateReqError(R_eq,Ri,alpha,D,L,eta,deta)

%input format: alpha & v = scalars, D & L = 2xalpha, eta & deta = 1xalpha

dRi = ones(1,alpha);
sum_terms = zeros(1,alpha);

for i = 1:alpha
    dRi(i) = (pi/128)*sum(1./Ri)^(-2).*sqrt(((D(1,i).^2./(eta(i).*L(1,i))).^4.*(L(1,i).*deta(i)).^2)+((eta(i).*L(2,i)).^2)+...
        16.*((eta(i).*L(1,i).*D(2,i)/D(1,i))).^2);
    sum_terms(i) = (dRi(i)/Ri(i)^2)^2;
end

%dRi = transpose(dRi);
ReqError = R_eq^2*sqrt(sum(sum_terms));

end

