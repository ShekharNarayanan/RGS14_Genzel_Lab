
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION: number_of_windows
% AUTHOR: Stephen Faul
% DATE: 30th April 2004
%
% DESCRIPTION: Returns the number of windows that will result
%             from windowing a data length with a window of a
%             particular size and overlap.
%
%         num_windows=number_of_windows(data_len,window_size,overlap)
%           
% INPUTS: data_len: length of input data
%         window_size: length of the window
%         overlap: how many samples one window overlaps the next by
%
% OUPUTS: num_windows: the number of windows that will result from the data and window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function num_windows=number_of_windows(data_len,window_size,overlap)
end_point=window_size;
start_point=1;
num_windows=0;
while end_point<=data_len
    num_windows=num_windows+1;
    start_point=start_point+(window_size-overlap);
    end_point=start_point+window_size-1;

end
    