dataset = readcell("SmallTestData.csv")
dataset = dataset(2:end, :);

disp("Input : {'S1', 'S3'}")
disp("Output(Similaridades de Jaccard):")
disp(Minhash(dataset,{'S1', 'S3'}));

disp("Input : {'S1', 'S2', 'S3'}")
disp("Output(Similaridades de Jaccard):")
disp(Minhash(dataset,{'S1', 'S2', 'S3'}));

disp("Input : {'S2'}")
disp("Output(Similaridades de Jaccard):")
disp(Minhash(dataset,{'S2'}));

disp("Input : {'S4'} (sintoma não existente no dataset)")
disp("Output(Similaridades de Jaccard):")
disp(Minhash(dataset,{'S4'}));
