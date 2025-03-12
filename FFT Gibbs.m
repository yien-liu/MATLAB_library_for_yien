% FFT Gibbs
% version 1.0

% 备注
% Gibbs现象: 对一个非周期函数进行傅里叶级数分解，在端点处会产生误差
clc;
clear;

% 基本参数
L = 2*pi;                     % 周期
x = linspace(0, 2*L, 1000);   % 横坐标，显示两个周期
f = mod(x, L);               % 周期延拓的 f(x)=x

% 创建动画
figure;
for N = 1:2:60  % 每次加2项，变化更明显（你可以改为1:1:60）
    % 初始化傅里叶级数重建值
    f_fs = zeros(size(x));
    
    % 常数项
    a0 = L/2;
    f_fs = a0 * ones(size(x));
    
    % 加余弦和正弦项
    for n = 1:N
        an = 0;  % f(x)=x 是奇函数，an=0
        bn = -L / (n*pi);
        f_fs = f_fs + an*cos(n*2*pi*x/L) + bn*sin(n*2*pi*x/L);
    end

    % 绘图
    plot(x, f, 'k--', 'LineWidth', 1.5); hold on;
    plot(x, f_fs, 'r', 'LineWidth', 2);
    xlabel('x'); ylabel('f(x)');
    legend('Periodic extension of f(x)=x', ['Fourier reconstruction, N=' num2str(N)]);
    title('Gibbs Phenomenon: Fourier Series Approximation');
    grid on;
    ylim([-0.5, 7]);  % 固定纵坐标范围便于比较
    
    pause(0.2);  % 控制动画速度
    hold off;
end
