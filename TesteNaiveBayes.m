dataset = readcell("SmallTestData.csv")
dataset = dataset(2:end, :);

disp("Input : {'S1', 'S3'}")
disp("Output(Similaridades de Jaccard):")
disp(NaiveBayes(dataset,true,{'S1', 'S3'}));

disp("Input : {'S1', 'S2', 'S3'}")
disp("Output(Similaridades de Jaccard):")
disp(NaiveBayes(dataset,true,{'S1', 'S2', 'S3'}));

disp("Input : {'S2'}")
disp("Output(Similaridades de Jaccard):")
disp(NaiveBayes(dataset,true,{'S2'}));

disp("Input : {'S4'} (sintoma não existente no dataset)")
disp("Output(Similaridades de Jaccard):")
disp(NaiveBayes(dataset,true,{'S4'}));