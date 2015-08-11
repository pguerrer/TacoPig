% Stationary Mean GP Function
% The value of the mean is constant and learnt during training.

classdef CustomDifferentiableMean < tacopig.meanfn.MeanFunc
    
    properties
		nParams
		meanFunc
		meanGrad
	end
    methods
        function n = npar(obj, ~) 
            % Returns the number of parameters required by the class
            % n = GP.MeanFn.npar()
            % Always returns 1.
            n = obj.nParams; 
        end
        
        function mu = eval(obj, X, GP) 
            % Returns the value of the mean at the location X
            %
            % mu = GP.MeanFn.eval(X, GP)
            %
            % Gp.MeanFn is an instantiation of the StationaryMean mean function class
            % Inputs: X = the input locations
            % GP = The GP class instance can be passed to give the mean function access to its properties
            
            par = tacopig.meanfn.MeanFunc.getMeanPar(GP);
            if (numel(par)~=obj.nParams)
                error('tacopig:inputInvalidLength','wrong number of hyperparameters!')
            end
            
            mu = obj.meanFunc(X, par);
        end
        
        function g = gradient(obj, X, GP) 
            %Evaluate the gradient of the mean function at locations X with respect to the parameters
            %
            % g = GP.MeanFn.gradient(X)
            %
            % Gp.MeanFn is an instantiation of the StationaryMean mean function class
            % Inputs:  X = D x N Input locations 
            % Outputs: g = the gradient of the mean function at locations X with respect to the parameters (A cell of dimensionality 1 x Number of parameters. Each element is an array of dimensionality N x N)
            %
            % For this class g is a 1 x 1 cell array (because it only has 1 parameter) with the element being a 1 x N matrix.
			
			if (numel(par)~=obj.nParams)
                error('tacopig:inputInvalidLength','wrong number of hyperparameters!')
            end
			par = tacopig.meanfn.MeanFunc.getMeanPar(GP);
            g = obj.meanGrad(X, par);
        end
    end
end    


