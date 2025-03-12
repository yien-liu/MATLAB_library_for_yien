% FFT Gibbs solve
% version 1.0

% 备注
% Gibbs现象对一个非周期函数进行傅里叶级数分解，再端点处的误差
% 通过偶延拓可以大大削弱Gibbs现象
% 在端点处，重构函数的导数值可以更接近原函数的导数值
clc;
clear;

% 区间参数
L = 2*pi;
x = linspace(0, 2*L, 1000);  % 原函数定义域
x_ext = linspace(-L, L, 1000);  % 延拓后的对称域

% 原函数 (偶延拓)
f_even = abs(x_ext);  % 相当于 f(x)=x 在 [-2pi,2pi] 做偶延拓 → |x|

% Fourier Cosine Series 展开
N = 50;  % 项数
a0 = (1/L) * trapz(x_ext, f_even)/2;
f_cos = a0 * ones(size(x_ext));  % 常数项

% 余弦项展开
for n = 1:N
    an = (1/L) * trapz(x_ext, f_even .* cos(n*pi*x_ext/L));
    f_cos = f_cos + an * cos(n*pi*x_ext/L);
end

% 绘图比较
figure;
plot(x_ext, f_even, 'k--', 'LineWidth', 1.5); hold on;
plot(x_ext, f_cos, 'b', 'LineWidth', 2);
xlabel('x'); ylabel('f(x)');
legend('Even extension |x|', 'Cosine series reconstruction');
title(['Fourier Cosine Series Approximation (N=' num2str(N) ')']);
grid on;
