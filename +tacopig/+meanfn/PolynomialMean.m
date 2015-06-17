% Polynomial Mean GP Function
% The mean is a polynomial function

classdef PolynomialMean < tacopig.meanfn.MeanFunc
    
    properties
        degree
    end
    methods
        function this = PolynomialMean(degree)
            if (nargin<1)
                this.degree = 1;
            else
                if (degree < 0 || degree ~= round(degree))
                    error('tacopig:inputInvalid','wrong polynomial degree!')
                end
                this.degree = degree;
            end
        end
        function n = npar(this, D) 
            % Returns the number of parameters required by the class
            % n = GP.MeanFn.npar()
            % returns 1 + the degree of the polynomial times the dimensionality of X. The 'zero' parameter corresponds to a constant (which is multiplied to X.^0).
            n = this.degree * D + 1; 
        end
        
        function mu = eval(this, X, GP) 
            % Returns the value of the mean at the location X
            %
            % mu = GP.MeanFn.eval(X, GP)
            %
            % Gp.MeanFn is an instantiation of the PolynomialMean mean function class
            % Inputs: X = the input locations
            % GP = The GP class instance can be passed to give the mean function access to its properties
            
            D = size(X, 1);
            
            par = tacopig.meanfn.MeanFunc.getMeanPar(GP);
            if (numel(par)~=this.npar(D) )
                error('tacopig:inputInvalidLength','wrong number of hyperparameters!')
            end
            
            exponents = permute (1:this.degree, [1 3 2]);
            powersOfX = bsxfun(@power, X, exponents);
            coefficients = reshape(par(2:end),[D, 1, this.degree]);
            terms = bsxfun(@times,coefficients,powersOfX);
            
            mu = par(1) + sum(sum(terms, 3), 1);
        end
        
        function g = gradient(this, X, ~)
            %Evaluate the gradient of the mean function at locations X with respect to the parameters
            %
            % g = GP.MeanFn.gradient(X)
            %
            % Gp.MeanFn is an instantiation of the StationaryMean mean function class
            % Inputs:  X = D x N Input locations 
            % Outputs: g = the gradient of the mean function at locations X with respect to the parameters (A cell of dimensionality 1 x Number of parameters. Each element is an array of dimensionality N x N)
            %
            % For this class g is a 1 x 1 cell array (because it only has 1 parameter) with the element being a 1 x N matrix.
            
            [D, N] = size(X);
            
            exponents = permute (1:this.degree, [1 3 2]);
            powersOfX = bsxfun(@power, X, exponents);
            gradMat = reshape(permute(powersOfX,[1 3 2]),[D*this.degree,N]);
            
            g = cell(1, this.npar(D) );
            g{1} = ones(1, N);
            g(2:end) = num2cell(gradMat,2)';
        end
    end
end    


