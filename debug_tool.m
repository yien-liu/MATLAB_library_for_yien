%寻找矩阵A的异常数值，并定位到EQ(i).eq的某行某列
%chatgpt方案
% 找出 A 中 NaN 或 Inf 的行和列索引
[row_idx, col_idx] = find(isnan(A) | isinf(A));

% 计算每个 EQ(i).eq 的行范围
row_start = 1; % 记录当前 EQ(i).eq 在 A 中的起始行
for i = 1:17
    num_rows = size(EQ(i).eq, 1); % EQ(i).eq 的行数
    row_end = row_start + num_rows - 1; % 计算 EQ(i).eq 在 A 中的终止行

    % 找出 NaN/Inf 出现在哪个 EQ(i).eq 中
    affected_rows = row_idx(row_idx >= row_start & row_idx <= row_end);
    
    if ~isempty(affected_rows)
        fprintf('NaN/Inf 出现在 EQ(%d).eq 中的以下行（在 A 中的行号）：\n', i);
        for j = 1:length(affected_rows)
            fprintf('  A 中的行 %d（对应 EQ(%d).eq 的第 %d 行），列 %d\n', ...
                affected_rows(j), i, affected_rows(j) - row_start + 1, col_idx(j));
        end
    end

    row_start = row_end + 1; % 更新起始行索引
end

%%
%寻找矩阵A的异常数值，并定位到EQ(i).eq的某行某列
%deepseek方案
% 假设 A 是由多个 EQ(i).eq 垂直拼接而成
A = vertcat(EQ(1).eq, EQ(2).eq, EQ(3).eq, EQ(4).eq, EQ(5).eq, EQ(6).eq, ...
    EQ(7).eq, EQ(8).eq, EQ(9).eq, EQ(10).eq, EQ(11).eq, EQ(12).eq, EQ(13).eq, ...
    EQ(14).eq, EQ(15).eq, EQ(16).eq, EQ(17).eq);

% 检查 NaN
nan_indices = find(isnan(A));

% 检查 Inf 或 -Inf
inf_indices = find(isinf(A));

% 合并所有异常值的索引
abnormal_indices = union(nan_indices, inf_indices);

% 转换为行和列的索引
[abnormal_rows, abnormal_cols] = ind2sub(size(A), abnormal_indices);

% 获取每个 EQ(i).eq 的行数
eq_sizes = cellfun(@(x) size(x, 1), {EQ.eq});

% 计算每个 EQ(i).eq 在 A 中的行范围
eq_ranges = [0, cumsum(eq_sizes)];

% 遍历所有异常值的行
for i = 1:length(abnormal_rows)
    row = abnormal_rows(i);
    col = abnormal_cols(i);
    
    % 确定该行属于哪个 EQ(i).eq
    eq_index = find(row > eq_ranges(1:end-1) & row <= eq_ranges(2:end));
    
    fprintf('异常值出现在 EQ(%d).eq 的第 %d 行，第 %d 列\n', eq_index, row - eq_ranges(eq_index), col);
end
%%
% 假设 EQ 是一个包含所有方程的结构数组
num_eq = length(EQ); % 方程数量
dimensions = zeros(num_eq, 2); % 存储每个 EQ(i).eq 的维度

% 遍历所有 EQ(i).eq，获取其维度
for i = 1:num_eq
    [rows, cols] = size(EQ(i).eq);
    dimensions(i, :) = [rows, cols];
    fprintf('EQ(%d).eq: %d x %d\n', i, rows, cols); % 打印每个矩阵的维度
end
%%

% 检查维度是否一致
unique_dims = unique(dimensions, 'rows');
if size(unique_dims, 1) > 1
    fprintf('\n警告: 存在维度不一致的矩阵！\n');
    disp('不同的维度有：');
    disp(unique_dims);
else
    fprintf('\n所有矩阵的维度一致: %d x %d\n', unique_dims(1, 1), unique_dims(1, 2));
end
row_sums = sum(abs(equation_matrix) > 1e-12, 2);
zero_rows = find(row_sums == 0);
disp('Zero rows:');
disp(zero_rows);

col_sums = sum(abs(equation_matrix) > 1e-12, 1);
zero_cols = find(col_sums == 0);
disp('Zero columns:');
disp(zero_cols);
%%
% 假设 equation_matrix 是 A, solution_x 是解向量 x, rhs_b 是 b
% 如果你的变量名称不同，请替换为对应名称

% 计算 Ax
Ax = equation_matrix * coeff_vector;

% 计算残差
residual = norm(Ax - source_vector);

% 输出残差
disp(['Residual: ', num2str(residual)]);