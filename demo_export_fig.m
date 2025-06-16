% demo_export_fig.m

% 创建图像
figure;
x = linspace(0, 2*pi, 500);
y = sin(3*x) .* exp(-0.3*x);
plot(x, y, 'LineWidth', 2);
title('Damped Sinusoid');
xlabel('Time (rad)');
ylabel('Amplitude');
grid on;

% 设置文件路径
filepath_pdf = 'damped_sinusoid.pdf';
filepath_svg = 'damped_sinusoid.svg';

% 导出为 PDF 和 SVG
export_fig(gcf, '-pdf', filepath_pdf);
export_fig(gcf, '-svg', filepath_svg);
