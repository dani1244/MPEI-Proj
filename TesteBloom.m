% Carregar o dataset
dataset = readcell("SmallTestData.csv");
dataset = dataset(2:end, :); % Ignorar cabeçalhos, se existirem

% Teste 1
disp("Input : {'S1', 'S3'}");
[~, sintomasFiltrados] = BloomFilter(dataset, {'S1', 'S3'});
disp("Output:");
disp(sintomasFiltrados);

% Teste 2
disp("Input : {'S1', 'S2', 'S3'}");
[~, sintomasFiltrados] = BloomFilter(dataset, {'S1', 'S2', 'S3'});
disp("Output:");
disp(sintomasFiltrados);

% Teste 3
disp("Input : {'S2'}");
[~, sintomasFiltrados] = BloomFilter(dataset, {'S2'});
disp("Output:");
disp(sintomasFiltrados);

% Teste 4
disp("Input : {'S4'}");
[~, sintomasFiltrados] = BloomFilter(dataset, {'S4'});
disp("Output:");
disp(sintomasFiltrados);
