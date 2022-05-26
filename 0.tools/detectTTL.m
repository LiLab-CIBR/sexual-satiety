function [tRise_1y, tDur_1y] = detectTTL(data_1v, adjacent_type, adjacent_value)
%过滤出TTL通道的数字信号，用上升沿和持续时间表述
%[tRise_1y, tDur_1y] = detectTTL(data_1v)
%[tRise_1y, tDur_1y] = detectTTL(data_1v, 'up-up', 20)
%
% ---------------------------Input---------------------------
% data_1v     :  TTL通道的连续采样数据。或者 [bool 0 | bool 1]数据
% adjacent    :  毗邻的类型['up-up', 'down-up', 'down-down']
% adjacent_value: 毗邻的值 [>=0]
%
% ---------------------------Output--------------------------
% tRise_1y    :  TTL的上升沿时刻，单位采样点
% tDur_1y     :  TTL的高电平持续时长，单位采样点
%
    assert( isvector(data_1v) );
    if islogical(data_1v)
        TTL = double(data_1v);
    else
        mean_data = 0.5*(max(data_1v) + min(data_1v));
        TTL = double( data_1v > mean_data );
    end
    TTL = [0; set1y(TTL); 0]; %HEAD & TAIL with 0
    TTLdiff = diff(TTL);
    tRise_1y = find(TTLdiff==1);
    tDown_1y = find(TTLdiff==-1);
    tDur_1y = tDown_1y - tRise_1y;
    
    if length(tRise_1y) <= 1 || ~exist('adjacent_type', 'var')
        return;
    end
    switch adjacent_type
        case 'up-up'
            tRest = tRise_1y(2:end) - tRise_1y(1:end-1);
        case 'down-up'
            tRest = tRise_1y(2:end) - tDown_1y(1:end-1);
        case 'down-down'
            tRest = tDown_1y(2:end) - tDown_1y(1:end-1);
        otherwise
            error('错误的参数');
    end

    ind_merge = tRest < adjacent_value;
    tRise_1y([false; ind_merge]) = [];
    tDown_1y([ind_merge; false]) = [];
    tDur_1y = tDown_1y - tRise_1y;