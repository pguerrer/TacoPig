
   % The value of the noise is a constant and learnt during training.
   %
   % Example instantiation:
   % GP.NoiseFn = tacopig.noisefn.Stationary()
   % 
   % Creates an instance of the Stationary noise function class as the
   % NoiseFn property of a Gaussian process class named GP.
   
classdef Sum < tacopig.noisefn.NoiseFunc
   
	 properties
		 nBaseNoiseFuncs
		 baseNoiseFunc
	 end
	 methods
		 function n_theta = npar(this, D)
			n_theta = 0;
			for i=1:this.nBaseNoiseFuncs
				n_theta = n_theta + this.baseNoiseFunc{i}.npar(D);
			end
        end
        
        function noise = eval(this, X, GP)
            % Returns the value of the noise at the location X
            %
            % noise = GP.NoiseFn.eval(X, GP)
            %
            % Gp.NoiseFn is an instantiation of the Stationary noise function class
            % Inputs: X = the input locations (D x N) 
            %         GP = The GP class instance can be passed to give the noise function access to its properties
            % Outputs : noise matrix (N x N)
			noise = 0;
			ps = ParameterSupplier;
			currentParIndex=1;
			[D,N] = size(X); %N number of points in X
			par = tacopig.noisefn.NoiseFunc.getNoisePar(GP);
			for i=1:this.nBaseNoiseFuncs
				parLength = this.baseNoiseFunc{i}.npar(D);
				ps.parameters = par(currentParIndex:currentParIndex+parLength-1);
				noise = noise + this.baseNoiseFunc{i}.eval(X, ps);
				currentParIndex = currentParIndex + parLength;
			end
        end
	 end

    methods(Static) 
        
        
        
        function [g] = gradient(X, GP)
            %Evaluate the gradient of the noise matrix at locations X with respect to the parameters
            %
            % g = GP.NoiseFn.gradient(X,GP)
            %
            % Gp.NoiseFn is an instantiation of the Stationary noise function class
            % Inputs:  X = D x N Input locations 
            % Outputs: g = the gradient of the noise function at locations X with respect to the parameters (A cell of dimensionality 1 x Number of parameters. Each element is an array of dimensionality N x N)
            %
            % For this class g is a 1 x NumberOfNoiseParameters cell array with the element being a N x N matrix (the gradient of the noise matrix with respect to the ith parameter).
         
			g = 0;
			ps = ParameterSupplier;
			currentParIndex=1;
			[D,N] = size(X); %N number of points in X
			par = tacopig.noisefn.NoiseFunc.getNoisePar(GP);
			for i=1:this.nBaseNoiseFuncs
				parLength = this.baseNoiseFunc{i}.npar(D);
				ps.parameters = par(currentParIndex:currentParIndex+parLength-1);
				g = g + this.baseNoiseFunc{i}.gradient(X, ps);
				currentParIndex = currentParIndex + parLength;
			end
        end

    end
end
