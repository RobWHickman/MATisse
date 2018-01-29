function [water, fit] = glm_regress(table, fractals, divisions, reward)

    table(isnan(table.win), :) = [];
    table.rewarded = double(table.offer_value == table.reward);
    table.bundle_liquid = 1.2 - (1.2*table.bundle_water_perc);
    groups = findgroups(table.offer_value, table.bundle_liquid);
    munged_perc = splitapply(@mean,table.rewarded, groups);
    munged_sum = splitapply(@sum,table.win, groups);

    if length(munged_perc) == fractals * divisions
        water = (repmat(1:divisions, 1, fractals)/ 10) * 1.2;
        x = repmat(1:fractals,divisions,1);
        juice = vertcat(x(:,1),x(:,2),x(:,3));
        matrix = mat2dataset(horzcat(juice, water', munged_perc, munged_sum),'VarNames',{'Juice','Water','Percent', 'Number'});
    else
        warning('!not at least one observation per condition!');
    end

	sub = matrix(double(matrix(:,1)) == reward,:);
	b = glmfit(sub.Water,[sub.Percent sub.Number],'binomial','link','probit');
	fit = glmval(b,sub.Water,'probit','size',sub.Number);
    
    water = unique(matrix.Water);
