#list.files(pattern="txt")->files
commandArgs(T)[1]->files
commandArgs(T)[2]->lib
library(ggplot2)
for(a in 1:length(files))
#read.table('F://....//all_summary_plot//try.txt',sep="\t",stringsAsFactors=F,header=F)->try
{read.table(files[a],sep="\t",stringsAsFactors=F,header=F)->try;
library(RColorBrewer)
brewer.pal(8,"Set1")[c(1,2,3,4)]->col
le=sort(unique(try$V1))
co=rep("gray",length(le))
for(i in 1:length(co)){
if(le[i]==21){
co[i]=col[1]}else if(le[i]==22){
co[i]=col[2]}else if(le[i]==23){
co[i]=col[3]}else if(le[i]==24){
co[i]=col[4]}
}
col_len=data.frame(length=le,color=co)
colnames(try)=c("length","count")
try$length=factor(try$length,levels=sort(unique(try$length)))
col_len$length=factor(col_len$length,levels=factor(col_len$length))
png(file=paste0(strsplit(files[a],"\\.t")[[1]][1],"_",lib,".png"),height=600,width=1000,res=500,family="sans")
#png(file=paste(strsplit(files[a],"\\.")[[1]][1],"png",sep="."),height=250,width=240)
#pdf(file=paste0(strsplit(files[a],"\\.")[[1]][1],"dis.pdf"),height=1.2,width=2.2)
print(ggplot(try,aes(x=length,y=count/1e3,fill=length))+
#geom_hline(aes(yintercept=0))+
geom_bar(stat="identity",width=0.9,position="dodge")+
labs(x="length(nt)",y="(reads count)*1000",title=paste0(strsplit(files[a],"\\.t")[[1]][1],"-",lib))+
scale_fill_manual(values=as.character(col_len$color))+
theme(
plot.title=element_text(size=6),
axis.text.x=element_text(size=7,color="black"),
axis.title.y=element_text(size=7),
axis.title.x=element_text(size=7,color="black"),
axis.text.y=element_text(color="black",size=6),
panel.grid=element_blank(),
panel.background=element_rect(fill="transparent",color="black"),
axis.line.y = element_line(size=0.5, colour = "black"),
axis.line.x = element_line(size=0.5,color="black"),
#axis.ticks.x = element_blank(),
legend.position="none",
legend.key.height=unit(5,"pt"),
legend.key.width=unit(5,"pt"),
legend.text=element_text(size=5),
legend.title=element_text(size=5))+
geom_hline(aes(yintercept=0)))
#+xlim(1,max(try$site))+theme(axis.line = element_line(size=1, colour = "black"))+scale_x_continuous(breaks=seq(0, max(try$site),max(try$site))))
dev.off()
}
