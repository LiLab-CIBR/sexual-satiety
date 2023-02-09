function hpatch = barpatch(x,x_dur, HL, varargin)
%????????2017-3-23????????
%????barline_old()????????????????????????????
%
%function hpatch = barpatch(x,x_dur, HL, varargin)
% -----Input ????--------
% x              : bar(x), 1_vector
% x_dur          : duration of x, 1_vector
% HL             : High and Low, 2_nums
% varargin       : pars for 'plot()'
%
% -----Output ????--------
% hline          : handle for plot-line, 1x1

    %% ???????? -- barline_old()????
    if ~exist('HL','var');HL=[0 1];end
    switch length(HL)
        case 0
            HL = [0 1];
        case 1
            HL=HL+[0 1];
        case 2
        otherwise
            error('Entry a number')
    end
    if isempty(x)
        hpatch = [];
        warning('barpatch for empty data');
        return;
    end
    if ~isvector(x);error('input:x show be a vector');end
    x = reshape(x,[],1); %1y
    HL = reshape(HL,1,[]); %1x
    x_dur = reshape(x_dur, [], 1);
    x_end = x + x_dur;
    
    %% ????????
    if isempty(varargin)
        color = 'red';
    else
        color = varargin{1};
        varargin = varargin(2:end);
    end
    hold on;
    for i=1:length(x)
        xtick = [x(i), x_end(i), x_end(i),x(i)];
        ytick = HL([2,2, 1,1]);
        hpatch(i) = patch(xtick, ytick, color, 'facealpha', 0.4, 'linestyle', 'none');
        
    end
     %% ???????? -- barline_old()????
%     hpatch = patch(xtick', ytick', 'red', varargin{:});
%     if isempty(varargin)
%         set(hpatch,'facealpha', 0.4, 'linestyle', 'none')
%     end
    if nargout==0;
        clear hline
    end
    