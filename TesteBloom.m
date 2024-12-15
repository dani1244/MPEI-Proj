% Carregar o dataset
dataset = readcell("SmallTestData.csv");
dataset = dataset(2:end, :); % Ignorar cabeçalhos, se existirem


% Extrair sintomas únicos do dataset
totalSintomas = {};
for i = 1:size(dataset, 1)
    linhaAtual = dataset(i, 2:end); % Pega os sintomas da linha atual
    linhaAtual = linhaAtual(~ismissing(linhaAtual)); % Remove valores 'missing'
    linhaAtual = linhaAtual(~cellfun(@isempty, linhaAtual)); % Remove células vazias
    totalSintomas = [totalSintomas, linhaAtual];
end

% Garantir que totalSintomas contém apenas valores válidos
sintomasLimpos = {};
for i = 1:length(totalSintomas)
    if ~ismissing(totalSintomas{i}) & ~isempty(totalSintomas{i})
        sintomasLimpos{end+1} = totalSintomas{i};
    end
end

% Atualizar totalSintomas
totalSintomas = sintomasLimpos;

% Converter para strings (caso necessário)
totalSintomas = cellfun(@char, totalSintomas, 'UniformOutput', false);

% Extrair valores únicos
sintomasUnicos = unique(totalSintomas);





% Parâmetros do filtro de Bloom
numHashFuncs = 3; % Número de funções hash
tamanhoFiltro = 10 * length(sintomasUnicos); % Tamanho do filtro

% Teste 1
disp("Input : {'S1', 'S3'}");
[~, sintomasFiltrados] = BloomFilter(sintomasUnicos, {'S1', 'S3'}, numHashFuncs, tamanhoFiltro);
disp("Output:");
disp(sintomasFiltrados);

% Teste 2
disp("Input : {'S1', 'S2', 'S3'}");
[~, sintomasFiltrados] = BloomFilter(sintomasUnicos, {'S1', 'S2', 'S3'}, numHashFuncs, tamanhoFiltro);
disp("Output:");
disp(sintomasFiltrados);

% Teste 3
disp("Input : {'S2'}");
[~, sintomasFiltrados] = BloomFilter(sintomasUnicos, {'S2'}, numHashFuncs, tamanhoFiltro);
disp("Output:");
disp(sintomasFiltrados);

% Teste 4
disp("Input : {'S4'}");
[~, sintomasFiltrados] = BloomFilter(sintomasUnicos, {'S4'}, numHashFuncs, tamanhoFiltro);
disp("Output:");
disp(sintomasFiltrados);
