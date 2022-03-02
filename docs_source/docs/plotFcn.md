# Custom Plot Functions

Function header: function [y, x, c] = demo_fcn(data, varargin)

Outputs:

- Output y: new y data to be plotted
- Output x: new x vector to be used for plotting (useful for fft and other special plots, leave empty if unused)
- Output c: overrride the data plot colour, leave empty to use standard colours

Inputs supplied by kVIS:

- Input data: yChannel data as defined in the plot definition
- Input varargin: cell structure with content: 
	- {1}: fds structure 
	- {2}: selected data limits - must be applied to output to get consistent vector lengths 
	- {3}: string read from column FunctionChannel to be processed by the function.
	
## Example
This function will add another channel or a constant to the current yChannel:
	
```
function [y, x, c] = kVIS_add_fcn(data, varargin)

x = [];
c = [];

% first argument is the data structure
fds  = varargin{1};

% second argument is the data range (if set)
pts  = varargin{2};

% separate argument string supplied from spreadsheet
if ~isnumeric(varargin{3})
    
    operatorChPath = varargin{3};
    
    ccF = strsplit(operatorChPath, '/');
    operatorCh = kVIS_fdsGetChannel(fds, ccF{1}, ccF{2});
    
    if operatorCh == -1
        disp('Function channel not found... Ignoring.')
        y = data;
        return
    end
    
    operatorCh = operatorCh(pts);
else
    
    % add a constant to data
    operatorCh = ones(length(data),1) * varargin{3};
    
end

y = data + operatorCh;
end
```

## List of included custom plot functions
The definitions can be found in ```/src/Tab_Plots/kVIS_CustomPlotFcn```

- kVIS_add_fcn: Add another channel or a constant to the current yChannel
- kVIS_multiply_fcn: Multiply the current yChannel with another channel or a constant
- kVIS_subtract_fcn: Subtract another channel or a constant from the current yChannel
- kVIS_errorColor_fcn: Apply a different colour to data outside set error bounds
- kVIS_limit_fcn: Delete data points outside set limits
- kVIS_diff_fcn: Differentiate yChannel with respect to time