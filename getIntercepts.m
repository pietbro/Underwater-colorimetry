function y_intercepts = getIntercepts(rgbValues)
    % Calculate the y-intercept for each channel line

    % Extract the individual channels
    redChannel = rgbValues(:, 1);
    greenChannel = rgbValues(:, 2);
    blueChannel = rgbValues(:, 3);

    luminance = [90.0 59.1 36.2 19.8 9 3.1]';

%     figure;
%     scatter(redChannel,luminance, 'rx');
%     hold on
%     scatter(greenChannel,luminance, 'gx');
%     hold on
%     scatter(blueChannel,luminance, 'bx');
%     hold on

    % Fit a line for each channel
    redLine = fit(luminance, redChannel, 'poly1');
    greenLine = fit(luminance, greenChannel, 'poly1');
    blueLine = fit(luminance, blueChannel, 'poly1');



%     figure;
   
%     plot(redLine,luminance, redChannel, 'rx');
%     hold on
%     plot(greenLine,luminance, greenChannel,'gx');
%     hold on
%     plot(blueLine,luminance, blueChannel, 'bx');
%     title('Backscatter RGB')
%     ylabel('RGB')
%     xlabel('Y')

    % Get the y-intercepts for each line
    redIntercept = redLine(0);
    greenIntercept = greenLine(0);
    blueIntercept = blueLine(0);

    % Store the y-intercepts in an array

    y_intercepts = [redIntercept, greenIntercept, blueIntercept];
    y_intercepts(y_intercepts < 0) = 0;