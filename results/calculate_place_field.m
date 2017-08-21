% calculate_place_field.m

  % Determine bins of 2D environment (note that they don't have to be
  % disjoint)
  if 1
  % Simple and can see the matrix values, but surface plot not smooth
  X_bin_center_list = [207.5:5:242.5];
  X_bin_left_list = X_bin_center_list - 2.5;
  X_bin_right_list = X_bin_center_list + 2.5;
  Y_bin_center_list = [162.5:5:257.5];
  Y_bin_left_list = Y_bin_center_list - 2.5;
  Y_bin_right_list = Y_bin_center_list + 2.5;
  end
  if 0
  % Surface plot looks like standard place field (boxcar smoothing)
  X_bin_center_list = [200:2:250];
  X_bin_left_list = X_bin_center_list - 5;
  X_bin_right_list = X_bin_center_list + 5;
  Y_bin_center_list = [155:2:265];
  Y_bin_left_list = Y_bin_center_list - 5;
  Y_bin_right_list = Y_bin_center_list + 5;
  end
  
  % Prepare the output variables
  num_X_bins = length(X_bin_center_list)
  num_Y_bins = length(Y_bin_center_list)
  total_num_positionsamples_XY_matrix = zeros(num_X_bins,num_Y_bins);
  total_num_APs_XY_matrix = zeros(num_X_bins,num_Y_bins);
  
  % Key: Loop through each 2D bin in X and Y, and for each bin find how
  % many X,Y position samples occur within the bin, and also how many APs
  for i_x = 1:num_X_bins
    for i_y = 1:num_Y_bins
      positionsamples_in_currentbin_indices = find(X>=X_bin_left_list(i_x) & X<X_bin_right_list(i_x) & Y>=Y_bin_left_list(i_y) & Y<Y_bin_right_list(i_y));
      total_num_positionsamples_XY_matrix(i_x,i_y) = length(positionsamples_in_currentbin_indices);
      APs_in_currentbin_indices = find(X_AP>=X_bin_left_list(i_x) & X_AP<X_bin_right_list(i_x) & Y_AP>=Y_bin_left_list(i_y) & Y_AP<Y_bin_right_list(i_y));
      total_num_APs_XY_matrix(i_x,i_y) = length(APs_in_currentbin_indices);
    end
  end

  % Convert from number of position samples in each X,Y bin to total time
  % in seconds to give firing rate in AP/sec, i.e. Hz
  sec_per_positionsample = median(diff(t_XYL));
    % Approximate by using median time between position samples
    % Could instead use a 10th to 90th percentile trimmed mean, which would
    %   be more accurate (and could use the Matlab command "sort" to
    %   compute a trimmed mean)
    % To be exactly correct, should not include position samples that occur
    %   when there is no Vm data and vice versa
  total_time_XY_matrix = total_num_positionsamples_XY_matrix * sec_per_positionsample;
  
  % Plot results
  if 0
  APs_in_currentbin_indices
    % Can see the figure-8 shape with the 5cm disjoint bins
  total_num_positionsamples_XY_matrix
    % Can see the figure-8 shape with the 5cm disjoint bins
  end
  firingrate_XY_matrix = total_num_APs_XY_matrix./total_time_XY_matrix;
  figure; sh = surf(X_bin_center_list,Y_bin_center_list,firingrate_XY_matrix');
  view(0,90)
  axis equal
  colormap hot
  colormap jet
  colorbar('location','EastOutside')
  xlabel(['X position (cm)'])
  ylabel(['Y position (cm)'])
  title(['Place field (Hz)'])
  set(sh,'EdgeColor','none')
  