function varargout = UVVISinfo(varargin)
% INFO Display/return information about the UV/Vis toolbox
% UVVISinfo without any input and output parameters displays information
% about the UV/Vis toolbox at the Matlab(r) command line.
%
% If called with an output parameter, UVVISinfo returns a structure
% "info" that contains all the information known to Matlab(r) about the
% UV/Vis toolbox.
%
% Usage
%   UVVISinfo
%
%   info = UVVISinfo;
%
%   version = UVVISinfo('version')
%   url = UVVISinfo('url')
%   dir = UVVISinfo('dir')
%   modules = UVVISinfo('modules')
%
%   info    - struct
%             Fields: maintainer, url, bugtracker, vcs, version, path
%
%             maintainer - struct
%                          Fields: name, email
%
%             url        - string
%                          URL of the toolbox website
%
%             bugtracker - struct
%                          Fields: type, url
%
%             vcs        - struct
%                          Fields: type, url
%
%             version    - struct
%                          Fields: Name, Version, Release, Date
%                          This struct is identical to the output of the
%                          Matlab(r) "ver" command.
%
%             path       - string
%                          installation directory of the toolbox
%
%   version - string
%             <version> yyyy-mm-dd
%
%   url     - string
%             URL of the toolbox website
%
%   dir     - string
%             installation directory of the toolbox
%
%   modules - cell array of structs
%             Struct fields: maintainer, url, bugtracker, vcs, version, path
%
% See also VER

% (c) 2014, Deborah Meyer
% (c) 2014, Till Biskup
% 2014-04-07

% The place to centrally manage the revision number and date is the file
% "Contents.m" in the root directory of the UV/Vis toolbox.
%
% Additional information about the maintainer, the URL, etcetera, are
% stored below.
%
% THESE VALUES SHOULD ONLY BE CHANGED BY THE OFFICIAL MAINTAINER OF THE
% TOOLBOX!

info = struct();
info.maintainer(1) = struct(...
    'name','Deborah Meyer',...
    'email','deborah.meyer@physchem.uni-freiburg.de'...
    );
info.maintainer(2) = struct(...
    'name','Till Biskup',...
    'email','till@till-biskup.de'...
    );
info.url = ''; %'http://till-biskup.de/en/software/matlab/uvvis/';
info.bugtracker = struct(...
    'type','BugZilla',...
    'url','https://r3c.de/bugs/till/'...
    );
info.vcs = struct(...
    'type','git',...
    'url',''...
    );
info.description = ...
    'a Matlab toolbox for handling optical absorption (UV/Vis) data';

% Get install directory
[path,~,~] = fileparts(mfilename('fullpath'));
info.path = path(1:end-9);

if nargin
    command = varargin{1};
elseif nargout
    command = 'structure';
else
    command = 'display';
end
if nargout
    varargout{1} = commonInfo(info,command);
else
    commonInfo(info,command)
end

end % End of main function

