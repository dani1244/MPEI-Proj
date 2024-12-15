dataset = readcell("SmallTestData.csv")
dataset = dataset(2:end, :);

disp("Input : {'S1', 'S3'}")
disp("Output:")
disp(Minhash(dataset,{'S1', 'S3'}));

disp("Input : {'S1', 'S2', 'S3'}")
disp("Output:")
disp(Minhash(dataset,{'S1', 'S2', 'S3'}));

disp("Input : {'s2'}")
disp("Output:")
disp(Minhash(dataset,{'S2'}));

disp("Input : {'s4'}")
disp("Output:")
disp(Minhash(dataset,{'s4'}));