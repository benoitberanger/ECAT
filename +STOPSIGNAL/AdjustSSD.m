function AdjustSSD( EP, evt, adjust, stepsize )

col_sc  = EP.Get('Staircase');
col_ssd = EP.Get('StopSignalDelay');

sc = cell2mat(EP.Data(:,col_sc));

sc(1:evt-1 +1) = 0;

next = find( sc == EP.Data{evt,col_sc} , 1 , 'first' );

switch adjust
    case 'up'
        sgn = +1;
    case 'down'
        sgn = -1;
end

if ~isempty(next)
    EP.Data{next+1,col_ssd} = EP.Data{evt,col_ssd} + sgn*stepsize; % milliseconds
end

end % function
