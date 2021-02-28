library(glmnet)
library(survival)
library(ggplot2)
library(plotmo)
dat=as.data.frame(read.csv("/home/ibab/project/python/forRegression.csv"))
dat2=as.data.frame(read.csv("/home/ibab/project/python/forRegressionTest.tsv",sep = "\t"))
dat3=as.data.frame(read.csv("/home/ibab/project/python/comb_gene.csv"))

#FOR FIRST DATA
status=dat$Status
time=dat$Time
x=dat[,4:67]
cv.fit=cv.glmnet(as.matrix(x),Surv(time,status),family="cox",standardize=T,nfolds=10)


print(cv.fit)
print(coef(cv.fit, s=cv.fit$lambda.min))
coefficients=coef(cv.fit, s=cv.fit$lambda.min)

sig_names=c()
for(i in as.data.frame(summary(coefficients)$i)){
  sig_names=c(sig_names,names(x[i]))
}
coefs=as.data.frame(summary(coefficients)$x)
tab=data.frame(sig_names,coefs)

plot_glmnet(cv.fit$glmnet.fit)
ggplot(data=tab,aes(x=summary.coefficients..x,y=sig_names))+geom_bar(stat="identity")
write.csv(tab,file="coef.csv")

#FOR SECOND DATA
status=dat2$Status
time=dat2$Time
x=dat2[,4:9]
cv.fit=cv.glmnet(as.matrix(x),Surv(time,status),family="cox",standardize=T,nfolds=10)


print(cv.fit)
print(coef(cv.fit, s=cv.fit$lambda.min))
coefficients=coef(cv.fit, s=cv.fit$lambda.min)

sig_names=c()
for(i in as.data.frame(summary(coefficients)$i)){
  sig_names=c(sig_names,names(x[i]))
}
coefs=as.data.frame(summary(coefficients)$x)
tab=data.frame(sig_names,coefs)

plot_glmnet(cv.fit$glmnet.fit)
ggplot(data=tab,aes(x=summary.coefficients..x,y=sig_names))+geom_bar(stat="identity")
write.csv(tab,file="coef2.csv")

#FOR COMBINED DATA
status=dat3$Status
time=dat3$Time
x=dat3[,4:73]
cv.fit=cv.glmnet(as.matrix(x),Surv(time,status),family="cox",standardize=T,nfolds=10)


print(cv.fit)
print(coef(cv.fit, s=cv.fit$lambda.min))
coefficients=coef(cv.fit, s=cv.fit$lambda.min)

sig_names=c()
for(i in as.data.frame(summary(coefficients)$i)){
  sig_names=c(sig_names,names(x[i]))
}
coefs=as.data.frame(summary(coefficients)$x)
tab=data.frame(sig_names,coefs)

plot_glmnet(cv.fit$glmnet.fit)
ggplot(data=tab,aes(x=summary.coefficients..x,y=sig_names))+geom_bar(stat="identity")
write.csv(tab,file="coef3.csv")