% plot_place_field_spikes.m

  % Find the X,Y position of the animal when each AP occurs by finding the
  % X,Y position at the position sample just before the AP
  % (More advanced: Use interp1q to find the X,Y position of every AP in 
  % one line)
  num_APs = length(t_AP_peak);
  X_AP = zeros(num_APs,1);
  Y_AP = zeros(num_APs,1);
  for i = 1:num_APs
    t_curr_AP = t_AP_peak(i);
    indices_before_curr_AP = find(t_XYL<=t_curr_AP);
    curr_index_t_XYL = max(indices_before_curr_AP);
      % Also could mention the function min
    X_AP(i) = X(curr_index_t_XYL);
    Y_AP(i) = Y(curr_index_t_XYL);
  end
  
  % Plot the location of each spike on top of the animal's trajectory (as
  % done in papers from various labs - show on in the lecture)
  figure(2); plot(X,Y)
    xlabel(['X (cm)'])
    ylabel(['Y (cm)'])
    title(['animal position'])
    hold on; plot(X_AP,Y_AP,'r.')