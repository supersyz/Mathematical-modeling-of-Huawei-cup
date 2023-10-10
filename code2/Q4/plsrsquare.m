clear;clc;
load 'X.mat';
mu=mean(X);sig=std(X);%���ֵ�ͱ�׼��
rr=corrcoef(X);%�����ϵ������
data=zscore(X); %���ݱ�׼��,�������� X*�� Y*
n=22;m=2; %n ���Ա����ĸ���,m ��������ĸ���
x0=X(:,1:n);y0=X(:,n+1:end); %ԭʼ���Ա��������������
e0=data(:,1:n);f0=data(:,n+1:end); %��׼������Ա��������������
num=size(e0,1);%��������ĸ���
[XL,YL,XS,YS,BETA,PCTVAR,MSE,stats] =plsregress(e0,f0);
xw = stats.W; %���Ա�������ɷ�ϵ����ÿ�ж�Ӧһ���ɷ֣�����xw����stats.W
yw = f0\YS;  %�����������ɷֵ�ϵ��
a_0=PCTVAR(1,:);b_0=PCTVAR(2,:);
a_1=cumsum(a_0);b_1=cumsum(b_0);
i=1;%����ʼֵ
%�ж�����ɷֶԵĸ���
while ((a_1(i)<0.9)&(a_0(i)>0.05)&(b_1(i)<0.9)&(b_0(i)>0.05))
    i=i+1;
end
ncomp=i;
fprintf('%d�Գɷֱַ�Ϊ��\n',ncomp);

for i=1:ncomp
    fprintf('��%d�Գɷ֣�\n',i);
    fprintf('u%d=',i);
    for k=1:22%�˴�Ϊ����x�ĸ���
        fprintf('+(%f*x_%d)',xw(k,i),k);
    end
    fprintf('\n');
        fprintf('v%d=',i);
    for k=1:2%�˴�Ϊ����y�ĸ���
        fprintf('+(%f*y_%d)',yw(k,i),k);
    end
    fprintf('\n');
    
end

[XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] =plsregress(e0,f0,ncomp);
n=size(e0,2); m=size(f0,2);%n���Ա����ĸ���,m��������ĸ���
beta3(1,:)=mu(n+1:end)-mu(1:n)./sig(1:n)*BETA2([2:end],:).*sig(n+1:end); %ԭʼ���ݻع鷽�̵ĳ�����
beta3([2:n+1],:)=(1./sig(1:n))'*sig(n+1:end).*BETA2([2:end],:); %����ԭʼ����x1,...,xn��ϵ����ÿһ����һ���ع鷽��
fprintf('���ó����»ع鷽�̣�\n')
for i=1:2%�˴�Ϊ����y�ĸ���
    fprintf('y%d=%f',i,beta3(1,i));
    for j=1:22%�˴�Ϊ����x�ĸ���
        fprintf('+(%f*x%d)',beta3(j+1,i),j);
    end
    fprintf('\n');
end
figure(1)
a = BETA2(:,1)';
bar(BETA2(:,1)',0.8,'k')   %��ֱ��ͼ
xlabel('�Ա������')
ylabel('�Ա�����׼��ϵ��')
% for i=1:length(a)
% 
%     text(i,a(i),num2str(a(i))
% 
% end
fprintf('�����y��Ԥ��ֵ��\n');
yhat=repmat(beta3(1,:),[size(e0,1),1])+X(:,[1:n])*beta3([2:end],:);  %��y1,..,ym��Ԥ��ֵ

e = yhat-y0;
er = e./y0;
max(abs(er))
min(abs(er))
mean(abs(er))
ymax=max([yhat;X(:,[n+1:end])]); %��Ԥ��ֵ�͹۲�ֵ�����ֵ
%���滭y1,y2,y3��Ԥ��ͼ������ֱ��y=x
figure(2)
plot(yhat(:,1),X(:,n+1),'*',[0:100],[0:100],'Color','k')
legend('����ֵԤ��ͼ')
axis([82,94,82,94]);
% plot(yhat(:,2),X(:,n+2),'O',[0:ymax(2)],[0:ymax(2)],'Color','k')
% legend('�����ɼ�Ԥ��ͼ',2)
figure(3)
 bar(beta3(:,1)',0.8,'k') 
xlabel('�Ա������')
ylabel('�Ա���ϵ��')

