#!/usr/local/bin/R

##  make sRNA depth plot according to specifying sRNA depth file and library
# input: Rscript *.R *.txt lib*

#setwd('F://....//all_summary_plot//')
#list.files(pattern="txt")->files
commandArgs(T)[1]->files
commandArgs(T)[2]->lib
library(ggplot2)

for(a in 1:length(files))
#read.table('F://....//all_summary_plot//try.txt',sep="\t",stringsAsFactors=F,header=F)->try
   {read.table(files[a],sep="\t",stringsAsFactors=F,header=F)->try;
    end<-max(try$V2)
    try<-subset(try,V3>19 & V3<25);

    library(RColorBrewer)
    brewer.pal(8,"Set1")[c(1,2,3,4)]->col
    le=sort(unique(try$V3))
    co=rep("gray",length(le))
    for(i in 1:length(co)){
       if(le[i]==21){
          co[i]=col[1]}else if(le[i]==22){
          co[i]=col[2]}else if(le[i]==23){
          co[i]=col[3]}else if(le[i]==24){
          co[i]=col[4]}
    }   
    col_len=data.frame(length=le,color=co)
    colnames(try)=c("count","site","length")
    try$length=factor(try$length,levels=sort(unique(try$length)))
    col_len$length=factor(col_len$length,levels=factor(col_len$length))

    inter=10^(floor(log10(max(try$site))))

    png(file=paste0(strsplit(files[a],"\\.t")[[1]][1],"_",lib,".png"),height=700,width=1900,res = 500,family="sans")
    #pdf(file=paste0(strsplit(files[a],"\\.")[[1]][1],"depth.pdf"),height=1.2,width=4)
    print(ggplot(try,aes(x=site,y=count/1000,fill=length))+geom_bar(stat="identity",width=1)+
    labs(x="position(nt)",y="(reads count)*1000",title=paste0(strsplit(files[a],"\\.t")[[1]][1],"-",lib))+
    scale_fill_manual(values=as.character(col_len$color))+
    geom_hline(aes(yintercept=0),color="black")+
    xlim(1,max(try$site))+
    theme(
         axis.line = element_line(size=0.5, colour = "black"),
         plot.title=element_text(size=7,color="black"),
         axis.title.y=element_text(color="black",size=7),
         axis.title.x=element_text(color="black",size=7),
         axis.text.y=element_text(color="black",size=7),
         axis.text.x=element_text(color="black",size=7),
         panel.grid=element_blank(),
         panel.background=element_rect(fill="transparent",color="black"),
         legend.position="right",
         legend.key.height=unit(7,"pt"),
         legend.key.width=unit(7,"pt"),
         legend.text=element_text(size=7),
         legend.title=element_text(size=7))+
         #scale_y_continuous(breaks=c(-15,-10,-5,0,5,10))+
         scale_x_continuous(breaks=c(1,seq(inter,max(try$site)-1,inter),max(try$site))))
    dev.off()
}


