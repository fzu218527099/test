clc;
clear;
%原始数列 A
X = [2.144028797 3.798688759 4.951345063 5.818193294 7.140924566 9.160345241 10.24552796 12.13639905 10.64889612 10.96634319];
n = length(X);
B = cumsum(X);%累加
for i = 2:n    %对数列 B 做紧邻均值生成
    Z(i) = (B(i) + B(i - 1))/2; 
end
Z(1) = []; %补充 C（1）
B = [-Z;ones(1,n-1)]
Y = X;
Y(1) = [];
Y = Y';
%使用最小二乘法计算参数 a(发展系数)和b(灰作用量)
U = inv(B*B')*B*Y;
U = U';
a = U(1);
b = U(2);
%预测后续数据
F = []; 
F(1) = X(1);
for i = 2:(n+10)
    F(i) = (X(1)-b/a)/exp(a*(i-1))+ b/a;
end
%对数列 F 累减还原,得到预测出的数据
G = []; G(1) = X(1);
for i = 2:(n+10)
    G(i) = F(i) - F(i-1); 
    %得到预测出来的数据G(i)
end

disp('预测数据为：');
G
n

%模型检验
H = G(1:10);
%计算残差序列
epsilon = X - H;
%相对残差Q检验、计算相对误差序列
delta = abs(epsilon./X);
%计算相对误差Q
disp('相对残差Q检验：')
Q = mean(delta)    
% 若大于 0.2 则不行
%方差比C检验
disp('方差比C检验：')
Z = std(epsilon, 1)/std(X, 1)
%小误差概率P检验
S1 = std(X, 1);
tmp = find(abs(epsilon - mean(epsilon))< 0.6745 * S1);
P = length(tmp)/n;
disp(['小误差概率P检验：',num2str(P)])

%绘制曲线图
t1 = (1:1:10);
t2 = (1:1:20);
plot(t1, X, 'ro'); hold on;
plot(t2, G, 'g-');
xlabel('时间'); ylabel('累计位移量/mm');
legend('cx-1实测累计位移量','cx-1预测累计位移量');
grid on;