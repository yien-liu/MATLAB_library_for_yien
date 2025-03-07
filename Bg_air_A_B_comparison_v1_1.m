% Bg_air_A_B_comparison
% version v1.1

% 备注：
% 1：model_A&B Bg_air comparison
% 2：绘制 Bg_air 时域曲线
% 3：绘制 magnitude 和 phase 频谱对比图

clc; clear; close all;

% 读取 Model A 数据
ydata_A = readmatrix("Model_A\Bg_air_A_负载.csv");
theta_A = linspace(0, 2*pi, length(ydata_A(:,2))); % 角度坐标
Bg_air_A = ydata_A(:,3);
A = abs(fft(Bg_air_A))/(length(Bg_air_A)/2);
A(1) = A(1)/2;
P = angle(fft(Bg_air_A)) * 180/pi;

magnitude_A = A;
phase_A = P;

% 读取 Model B 数据
ydata_B = readmatrix("Model_B\Bg_air_B_负载.csv");
theta_B = linspace(0, 2*pi, length(ydata_B(:,2))); % 角度坐标
Bg_air_B = ydata_B(:,3);
B = abs(fft(Bg_air_B))/(length(Bg_air_B)/2);
B(1) = B(1)/2;
P = angle(fft(Bg_air_B)) * 180/pi;

magnitude_B = B;
phase_B = P;

% 绘制 Bg_air 在 0~2pi 范围内的曲线对比
figure;
plot(theta_A, Bg_air_A, 'b-', 'LineWidth', 1.5); hold on;
plot(theta_B, Bg_air_B, 'r--', 'LineWidth', 1.5);
xlabel('\theta (rad)');
ylabel('Bg\_air (T)');
legend('Model A', 'Model B');
title('Bg\_air 时域曲线对比');
grid on;

% 计算谐波阶次
% N = length(magnitude_A);
N = 150;
freq_axis = (0:N-1);

% 绘制 magnitude 频谱对比
figure;
stem(freq_axis, magnitude_A(1:N), 'bo', 'LineWidth', 1.5); hold on;
stem(freq_axis, magnitude_B(1:N), 'ro', 'LineWidth', 1.5);
xlabel('Harmonic Order');
ylabel('Magnitude');
legend('Model A', 'Model B');
title('各次谐波幅值对比');
grid on;

% 绘制 phase 频谱对比
figure;
stem(freq_axis, phase_A(1:N), 'bo', 'LineWidth', 1.5); hold on;
stem(freq_axis, phase_B(1:N), 'ro', 'LineWidth', 1.5);
xlabel('Harmonic Order');
ylabel('Phase (rad)');
legend('Model A', 'Model B');
title('各次谐波相位对比');
grid on;

%%
% 计算 FFT 幅值较大的谐波次数并保存数据到 CSV

% 设置阈值，筛选出较大的谐波分量（可以调整）
threshold_A = 0.03 * max(magnitude_A(1:N)); 
threshold_B = 0.03 * max(magnitude_B(1:N)); 
% 找到大于阈值的谐波分量索引
significant_idx_A = find(magnitude_A(1:N) > threshold_A);
significant_idx_B = find(magnitude_B(1:N) > threshold_B);

% 取两个模型共同的谐波分量
significant_idx = unique([significant_idx_A; significant_idx_B]);

% 提取这些谐波的阶次、幅值
harmonic_orders = significant_idx - 1; % MATLAB 索引从1开始，需要减1
magnitude_A_significant = magnitude_A(significant_idx);
magnitude_B_significant = magnitude_B(significant_idx);
phase_A_significant = phase_A(significant_idx);
phase_B_significant = phase_B(significant_idx);

% 计算幅值变化百分比
magnitude_increase_percentage = ((magnitude_B_significant - magnitude_A_significant) ./ magnitude_A_significant) * 100;

% 计算相位变化（差值）
phase_difference = phase_B_significant - phase_A_significant;
% 创建表格
harmonic_table = table(harmonic_orders, magnitude_A_significant, magnitude_B_significant, ...
    magnitude_increase_percentage, phase_A_significant, phase_B_significant, phase_difference);

% 保存为 CSV 文件
csv_filename = "harmonic_comparison.csv";
writetable(harmonic_table, csv_filename);

% 显示表格数据
disp("显著谐波分量已提取并保存至 CSV 文件（包含相位信息）。");
disp(harmonic_table);