function obj = readHeader ( obj )
%
%function obj = readHeader ( obj )
%
% Read the trace headers from a SEG-Y or SU file
% Returns:
%   header = a structure array containing the trace header information.
%     Each structure heading is a variable defined in headerdefininitions
%

try
    %position pointer at start of header
    fseek(obj.fid,obj.hdroffset,'bof');
    %get size of traceheader definitions
    sz=size(obj.definitions.values);
    %create variables to hold assorted things
    nsforall=[];
    val=1;
    % test to find where ns (number of samples is located);
    nsind=0;
    nspos=find(strcmp(obj.definitions.values(:,strcmp(obj.definitions.keys,'Name')),'ns'));
    if nspos
        nsind=nspos;
    end
    troffset=obj.hdroffset;
    %create waitbar and associated variables.
    nontypecastheader=uint8([]);
    count=0;
    fileinfo=dir(obj.filename);
    totcount=fileinfo.bytes/2000;
    hwait=waitbar(count/totcount,'Please Wait as Trace Headers Load');
    %read trace header values
    m=1;  % is the number of traces that have been read in
    while(~isempty(val))
        % read in traceheader as nusigned byte intergers
        val=fread(obj.fid,[obj.hdrsize,1] ,'*uint8');
        if isempty(val)
            break
        end
        nontypecastheader(:,m)=val;
        
        
        if nsind
            st=str2double(obj.definitions.values(nsind,strcmp(obj.definitions.keys,'startByte')));
            ed=str2double(obj.definitions.values(nsind,strcmp(obj.definitions.keys,'endByte')));
            typ=obj.definitions.values{nsind,strcmp(obj.definitions.keys,'Type')};
            ns=typecast(nontypecastheader(st:ed,m)',typ);
            ns=checkforrightbyteorder(ns,obj.filefmt);
        end
        ns=double(ns);
        
        % ask user to imput number of samples if trace header does not exist
        if ~nsind || ns==0 && isempty(nsforall)
            ns=str2double(inputdlg({['The number of samples in the trace was not found.',...
                'Please enter the number of samples in the trace.']},...
                'Number of Samples NOT FOUND',1,{'500'}));
            if isempty(ns)
                warndlg('Invalid Number Of Samples Entered, Exiting Script')
                delete(hwait);
                return
            end
            nsforall=questdlg(['You have entered ',num2str(ns),' as the number of samples in this trace.  ',...
                'Would you like to use this value for all traces in the file?'],...
                'Constant Number of Samples','Yes','No','Yes');
            if strcmp(nsforall,'No'),nsforall=[];else nsforall=ns;end;
        end
        
        if ~isempty(nsforall), ns=nsforall; end
        if (ftell(obj.fid)+(ns*obj.tracetype{1}))>fileinfo.bytes
            fseek(obj.fid,0,'eof');
        else
        fseek(obj.fid,ns*obj.tracetype{1},'cof');
        end
        troffset(1,m+1)=troffset(m)+double(240+ns*obj.tracetype{1});
        
        %Adjust waitbar
        totcount=ceil(double((fileinfo.bytes-obj.hdroffset))/double((obj.hdrsize+ns*obj.tracetype{1})));
        count=count+1;
        waitbar(count/totcount);
        
        % See if additional space needs to be added to preallocate for
        % speed
        matsz=size(nontypecastheader);
        if matsz(2)<totcount;
            mryflag=obj.memoryallowancecheck([matsz(1) totcount],'uint8');
            if mryflag
            adnan=NaN(matsz(1),(totcount-matsz(2)));
            nontypecastheader=[nontypecastheader,adnan];
            troffset=[troffset,NaN(1,(totcount-matsz(2)))];
            else
                warndlg('Not Enough Memory to Read Trace Headers')
                delete(hwait);
                return
            end
        end
        
        % add one to m for the times it has gone arround the while loop
        m=m+1;
    end
    
    % remove additional entries
    nontypecastheader= nontypecastheader(:,1:m-1);
    troffset=troffset(:,1:m);
    
    
    % set the object header property
    obj.traceoffsets=troffset;
    obj.nontypecasthdr=nontypecastheader;
catch me
    delete(hwait);
    error (me.message);
end
delete(hwait);
end
