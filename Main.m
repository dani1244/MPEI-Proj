dataset = readcell("SmallTestData.csv")
dataset = dataset(2:end, :);

%Inputs: dataset, printsIntermedios, sintomasInput
disp(NaiveBayes(dataset, true,{'S1', 'S3'})); %Os dois ultimos serão mais tarde dados pelo utilizador