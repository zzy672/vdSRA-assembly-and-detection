#### sRNA contig to RPV genome
library(RColorBrewer)
#display.brewer.all()
read.table(f[1],header=F)->info


col=brewer.pal(8,"Set1")[1:4]

color=ifelse(info[,3]>100,"red","gray")

xleft=info[,2]


# y count
np=length(which(info[,1]=="+"))
nm=length(which(info[,1]=="-"))

np_mean=ceiling(np/2)
p=rep(0:np_mean,times=2)

nm_mean=ceiling(nm/3)
m=rep(0:nm_mean,times=3)

site=info[,2]
site[which(info[,1]=="+")]<-p[1:np]
site[which(info[,1]=="-")]<-m[1:nm]

ybottom <-c()
for(i in 1:nrow(info)){
  if(info[i,1]=="+"){
     ybottom[i]=6+3*site[i]
	 ytop=ybottom+1.5
     }
  else
     {ybottom[i]=-8-3*site[i]
	  ytop=ybottom+1.5
     }
}
xright=info[,2]+info[,3]-1

####
#ybottom[c(14:17)]<-ybottom[c(14:17)]+3
#ytop<-ybottom+1.5
####

par(mar=c(3,2,1,2))
plot(c(-100,7200), c(-min(ybottom)-3,max(ytop)+3),yaxt="n",ann=F,bty="n",
xlim = c(-100,7200), ylim = c(min(ybottom)-3,max(ytop)+3), type = "n")
rect(xleft = xleft, ybottom = ybottom, xright = xright, 
ytop = ytop,col=color)

rect(xleft = 1, ybottom = -0.5, xright = 5914, 
ytop = 0.5,border=NA,col="black")

#abline(h=0,lwd=3,xlim=c(1,5914))
text(100,4,"5'",cex=0.8,font=2)
text(5900,4,"3'",cex=0.8,font=2)
text(100,-4,"3'",cex=0.8,font=2)
text(5900,-4,"5'",cex=0.8,font=2)


text(-200,0,"1",cex=1,font=2,adj=0)
text(6014,0,"5914nt",cex=1,font=2,adj=0)


paste(xleft,"-",xright,sep="")->labels
#name=c(1.1,1.2,2:16)
name=1:27

for(i in 1:nrow(info)){
paste0("conitg",name[i],":",xleft[i],"-",xright[i])->labels
text(xright[i],ybottom[i]+1,labels,cex=0.7,adj=0)}

### reads to sRNA contigs##############################################
library(RColorBrewer)
#display.brewer.all()
#read.table('sRNA_contigs_length.txt')[,2]->length
read.table('contig-len.txt')[,2]->length
read.table('contig-len.txt')[,1]->name
#length=c(5914,119,108,135,137,162,199,135,125,121,113)
#name=c(1.1,1.2,2:16)

for(seq in 1:27){
#seq=10
read.table(paste0(name[seq],"_sRNA_contig.txt"),header=F)->info
info[order(info[,2]),]->info


###### color set
#col=brewer.pal(8,"Set2")[1:4]
col=c("gray","#DC0000FF","#00A087FF",
"#3C5488FF","#F39B7FFF")[c(1,3,5,2)]
color=ifelse(info[,4]==1,col[1],
ifelse(info[,4]>1 & info[,4]<=10,col[2],
ifelse(info[,4]>10 & info[,4]<=100,col[3],col[4])))

#### position cal
xleft=info[,2]

# y count
np=length(which(info[,1]=="+"))
nm=length(which(info[,1]=="-"))

np_mean=ceiling(np/floor(length[seq]/50))
p=rep(0:np_mean,times=floor(length[seq]/50))

nm_mean=ceiling(nm/floor(length[seq]/50))
m=rep(0:nm_mean,times=floor(length[seq]/50))

site=info[,2]
site[which(info[,1]=="+")]<-p[1:np]
site[which(info[,1]=="-")]<-m[1:nm]

# get y position
ybottom <-c()
for(i in 1:nrow(info)){
  if(info[i,1]=="+"){
     ybottom[i]=(np_mean/10)+3*site[i]
	 ytop=ybottom+2
     }
  else
     {ybottom[i]=-(np_mean/10-2)-3*site[i]
	  ytop=ybottom+2
     }
}
xright=info[,2]+info[,3]-1

######### plot
start=1  ##
end=length[seq]  ## contig end

pdf(paste0(name[seq],"_sRNA_contig.pdf"),width=5.5,height=3)
par(mar=c(3,2,1,2))
plot(c(start-end/30,end+end/10), 
c(-min(ybottom)+min(ybottom)/50,max(ytop)+max(ytop)/50),yaxt="n",ann=F,bty="n",
xlim = c(start-end/30,end+end/10), 
ylim = c(min(ybottom)+min(ybottom)/50,
max(ytop)+max(ytop)/5), type = "n")
rect(xleft = xleft, ybottom = ybottom, xright = xright, 
ytop = ytop,border=NA,col=color)

### add genome black bar
rect(xleft = start, ybottom = -max(2,np_mean/50), xright = end, 
ytop = max(2,np_mean/50),border=NA,col="black")

### add number
text(start,np_mean/4.5,"5'",cex=0.8,font=2,adj=0)
text(end,np_mean/4.5,"3'",cex=0.8,font=2,adj=1)
text(start,-np_mean/4.5,"3'",cex=0.8,font=2,adj=0)
text(end,-np_mean/4.5,"5'",cex=0.8,font=2,adj=1)


text(start-end/50,0,"1",cex=1,font=2,adj=1)
text(end+end/100,0,paste0(end,"nt"),cex=1,font=2,adj=0)

#### legend
legend("top",legend=rev(c(">100",">10",">1","1")),
fill=col,bty="n",adj=0,cex=0.8,border=NA,horiz=T)
dev.off()
}