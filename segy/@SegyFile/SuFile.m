	classdef SuFile < File

    %
    %SegyFile Class
    % Open a SEG-Y file for reading or writing and get basic
    % information about the file, such as the format of the
    % text header and the byte order of the disk file
    %
  
    properties
        textheader=NaN;           %
        binaryheader=NaN;         % 
        traceheader;          %
        tracedata;            %
                              % 
%         computerEndian;       % output from computer()
%                               %   string containing 'B' or 'L'
    end % end properties
    
    methods
        %Constructor/Destructor
        function obj = SuFile(filename,varargin)
            %function obj = SuFile(filname,varargin)
            %
            % Example:
            %   SuFile('file.su','machineformat','ieee-be')
            %
            % Where:
            %   filename      = string containing full segy file name
            %   permission    = permissions for fopen(); default is 'r'
            %   machineformat = string containing 'ieee-be' or 'ieee-le'
            %                   for big and little endian (optional)
            %   textfmt       = string containing 'ebcdic' or 'ascii'
            %
            
            % process varargin
            
            %Superclass constructors
            if(nargin==0)
                filename = [];
            end
            obj = obj@File(filename,varargin{:});
            
            if nargin > 0
                %   read contents of input arguments
%                 for i = 1:2:length(varargin)
%                     name = varargin{i};
%                     value = varargin{i+1};
%                     if(~ischar(name) || ~ischar(value))
%                         error('Error: input to SegyFile() must be character strings');
%                     end
%                     switch name
%                         case 'machineformat'
%                             obj.machineformat = value;
%                         case 'textfmt'
%                             obj.textformat = value;
%                         case 'mode'
%                             obj.permission = value;
%                         otherwise
%                     end
%                 end
                
                %   check byte order values
                if (~(strcmp(obj.machineformat,'ieee-be') || strcmp(obj.machineformat,'ieee-le')))
                    %warning('crewes:segy:SegyFile','endian argument not supplied or invalid. Checking file...');
                    %obj.machineformat = guessByteOrder(obj);
                end
                
                % get computer endianness
                %[c m obj.computerEndian] = computer();
                
                % read file headers                
                %obj.textheader = TextHeader(obj.fid);
                %obj.binaryheader = BinaryHeader(obj.fid);
            end
        end
        function delete(obj)
            if(obj.fid)
                fclose(obj.fid);
            end
        end                    
    end % end methods
    
    methods (Static)
        ibm = ieee2ibm(ieee);
        ieee = ibm2ieee(ibm,fmt);
    end % end static methods    
    
end % end classdef