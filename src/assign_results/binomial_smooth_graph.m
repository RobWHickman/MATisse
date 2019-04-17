%function that takes the results table and does a logit regression to graph
%the bionmial choice curves to visualise indifference poitns
function graph_data = binomial_smooth_graph(results_table)

%get the reward_value, bundle value (amount of water in the bundle) and
%whether or not the bundle was chosen
%paid might give errors with probabilistic stimuli but works for now
rv = results_table.reward_value;
bv = results_table.second_budget_value;
p = results_table.paid;

%filter out NaNs (e.g. errors)
nans = (isnan(p) | isnan(rv) | isnan(p));
rv = rv(~nans);
bv = bv(~nans);
p = p(~nans);

%create a matrix of the prob of choosing bundle for each fractal/bundle
%combination
means = splitapply(@mean,p,findgroups(rv,bv));
mat = unique([rv, bv], 'rows');
mat = [mat, means];

mat = [mat, histc(findgroups(rv,bv), unique(findgroups(rv,bv)))];
mat = [mat mat(:,3) .* mat(:,4)];
mat = [mat mat(:,4) - mat(:,5)];

%format the graph data
%3 columns: the fractal value in bundle, the water in the bundle, the log
%fit of choose/not choose for each combination
graph_data = mat(:,1:2);
graph_data_fit = [];
for fractal = unique(mat(:,1))'
    bundle_water = mat(mat(:,1) == fractal,2);
    trials_per_bundle = mat(mat(:,1) == fractal, 4);
    bundles_chosen = mat(mat(:,1) == fractal, 5);
    
    %bundle_proportions = bundles_chosen ./ trials_per_bundle;
    
    [logitCoef, dev] = glmfit(bundle_water, [bundles_chosen trials_per_bundle], 'binomial', 'logit');
    logitFit = glmval(logitCoef,bundle_water,'logit');
    graph_data_fit = [graph_data_fit, logitFit'];
end

graph_data(:,3) = graph_data_fit';


