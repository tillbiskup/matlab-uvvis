% GBCSPECASCIIREAD Read ASCII export data from GBC UV/Vis spectra
%
% Usage
%   data = GBCspecASCIIRead(filename)
%
% fileName  - string
%             Name of the file containing the ASCII export of the data
%
% data      - struct
%             fields: data, parameters
%             data       - nx2 matrix with x,y axis
%             parameters - struct with parameters from file header
%

% (c) 2011, Till Biskup
% 2011-09-07

function data = GBCspecASCIIRead(filename)

    % Check whether file exists
    if ~exist(filename,'file')
        data = struct();
        return;
    end

    % Read data
    data = importdata(filename, '', 14);
    
    % Get field names from header
    fieldNames = ...
        cellfun(@(x) lower(strrep(...
        strrep(x(3:strfind(x,'=')-1),' ',''),'/','')),...
        data.textdata,'UniformOutput',false);
   
    % Get field values from header
    fieldValues = ...
        cellfun(@(x) x(strfind(x,'=')+1:end),...
        data.textdata,'UniformOutput',false);
    
    % Create empty parameters structure
    data.parameters = struct();
    
    for k=1:length(fieldNames)
        data.parameters = ...
            setfield(data.parameters,...
            char(fieldNames(k)),...
            char(fieldValues(k)));
    end
    
    % Clean up data variable
    data = rmfield(data,'textdata');
    data = rmfield(data,'colheaders');
    
    % Create axis, but first copy data to second column of data field
    data.data(:,2) = data.data;
    data.data(:,1) = linspace(...
        str2double(data.parameters.firstx),...
        str2double(data.parameters.lastx),...
        str2double(data.parameters.npoints));

end

