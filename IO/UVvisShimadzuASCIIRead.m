function data = UVvisShimadzuASCIIRead(filename)
% UVVISSHIMADZUASCIIREAD Read ASCII export data from Shimadzu UV/Vis spectra
%
% Usage
%   data = UVvisShimadzuASCIIRead(filename)
%
% fileName  - string
%             Name of the file containing the ASCII export of the data
%
% data      - struct
%             fields: data, parameters, header
%             data       - nx2 matrix with x,y axis
%             parameters - struct with parameters
%             header     - cell array with header lines
%

% (c) 2012-13, Till Biskup
% 2013-07-31

% Define default output parameter
data = struct();

if (nargin == 0)
    help UVvisShimadzuASCIIRead;
    return;
end

headerLines1D = 2;
headerLines2D = 1;

% Check whether file exists
if ~exist(filename,'file')
    fprintf('File "%s" doesn''t exist.',filename);
    return;
end

% Read data
fid = fopen(filename);
if fid < 0
    return;
end

try
    k=1;
    fileContent = cell(0);
    while 1
        tline = fgetl(fid);
        if ~ischar(tline)
            break
        end
        fileContent{k} = tline;
        k=k+1;
    end
    fclose(fid);
catch
    fclose(fid);
end

% Check whether we have 1D or 2D data, where 1D is the direct ASCII export
% from the UVProbe program, and 2D is a manual export via copy&paste.
if strcmpi(fileContent{1}(1),'"') || strcmpi(fileContent{1}(1),'''')
    onedim = true;
else
    onedim = false;
end

if onedim
    % In case we have one-dimensional data
    data.header = fileContent(1:headerLines1D);
    for k=headerLines1D+1:length(fileContent)
        data.data(k-headerLines1D,:) = ...
            cell2mat(textscan(strrep(fileContent{k},',','.'),'%f %f'));
    end
    
    % Create empty parameters structure
    data.parameters = struct();
    
    data.parameters.filename = filename;
    data.parameters.axis.x.measure = 'wavelength';
    data.parameters.axis.x.unit = 'nm';
    
    % Set y axis depending on data file
    if any(strfind(data.header{2},'Abs'))
        data.parameters.axis.y.measure = 'absorption';
        data.parameters.axis.y.unit = 'a.u.';
    end
    
else
    % In case we have manually exported two-dimensional data
    data.header = fileContent{1:headerLines2D};

    for k=headerLines2D+1:length(fileContent)
        data.data(k-headerLines2D,:) = cellfun(@(x)str2double(x),...
            regexp(strrep(fileContent{k},',','.'),'\t','split'));
    end
    
    % Create empty parameters structure
    data.parameters = struct();
    
    data.parameters.filename = filename;
    data.parameters.axis.x.measure = 'wavelength';
    data.parameters.axis.x.unit = 'nm';
    data.parameters.axis.x.values = data.data(:,1);
    data.parameters.axis.y.measure = 'absorption';
    data.parameters.axis.y.unit = 'a.u.';
    
    data.data = data.data(:,2:end);
end

end

