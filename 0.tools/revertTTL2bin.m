function data = revertTTL2bin(tRise, tDur, Fs, tlen)
%detectTTL的逆过程。从上升沿和持续时间建立连续的bool数据
%data = revertTTL2bin(tRise, tDur)
%data = revertTTL2bin(tRise, tDur, Fs, tlen)
%
% ---------------------------Input---------------------------
% tRise     :  TTL的上升沿时刻，单位sec
% tDur      :  TTL的高电平持续时长，单位sec
% Fs        :  采样率
% tlen      :  data 的补充时长
%
% ---------------------------Output--------------------------
% data      :  bool连续数据，1y

assert(isvector(tRise) && isvector(tDur));
assert(length(tRise) == length(tDur));
if ~exist('Fs', 'var'); Fs = 1; end
if ~exist('tlen', 'var'); tlen = tRise(end)+tDur(end) + 1/Fs; end

%% 计算
nlen = round(tlen * Fs);
data = false(nlen, 1);
tDown = tRise + tDur;
tRise_n_dt = round(tRise * Fs);
tDown_n_dt = round(tDown * Fs)-1;
for i=1:length(tRise)
    data(tRise_n_dt(i):tDown_n_dt(i)) = true;
end