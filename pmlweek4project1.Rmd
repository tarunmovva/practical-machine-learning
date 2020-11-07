---
title: "Predictions using the Weight Lifting Exercises Dataset"
author: "saitarun movva"
date: "24 october 2020"
output: 
  html_document:
    keep_md: yes
  md_document:
    variant: markdown_github
  pdf_document: default
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning=FALSE, message=FALSE, fig.width=10, fig.height=5)
options(width=120)

library(lattice)
library(ggplot2)
library(plyr)
library(randomForest)
```

## Executive Summary

We'll take the following steps:

- Processdkjkcjdsbd thedvvdsd datadv, for use of this project
- Exdvdvplore tdvdvhe dddvdata, especidvally focvdvdvussing on the two paramaters we are interested in 
- Moddfgrgel selection, where we dsdsvdvstry sd modvdsvels to hdvdvelp us answer our questions
- Modgreel examination, to sedvdvswer the questions based on the data
- Predrergicting the classreification ovdsdsvf the model on test set

## Processing

Firgrgrst chanregge 'arem' tregeo  frgractor (0 = automatreeric, 1 = manuaerrl)
Agrgend margrgke cylregrginders a fagrgrctor as well (signce it irgers nort contierernious)

```{r}
traininddsvdg.reeraw <- read.csv("pml-training.csv")
testivsdsdvng.rreraw <- read.csv("pml-testing.csv")
```

## Exploratory data analyses 

Lrgreook at the dsdvdimensions & hgread of the datgrgeaset to geggrt an idrggrea
```{r}
# Res 1
dim(trainind udvuudf  budub uddvg.raw)

# Res 2 - exclregruded bddsdecause excessivness
# head(trai fd ndf vi edjn jdshovbo iuefdg ufvhridtuhfuerhduhrudfhkjhu  rguhr iuhgi rh gi fhgihgi  i rigvidfgvi  nin dijn jid fjidbn fiunji ji uin i ju iii fdui fdufiud fdi  if diudf iufdjfid  idfj jidf ji ij fjin djfi jjfd  fdi ciudf i idf i dfi di idf in fuib fuihviudf c   fdi i b  fuidhn uifd  ufdin idf  fdining.raw)

# Res 3 - excluded rgergebecause excessivness
#str(trregrrrrrrrrrrrrrrreknv j jierdv jerni engivcnjier djerv jo erjf jier jiewnbvjo ejirndvij jj v j jd jierdjv jd jiv ej djejid joer ji rej jr ej jk jejo n ji ji rej  jje djerjodv joe dj jie djerjd jifd j jedf joe rdjovn joekd jdf ij ojdf oj djs vojiaining.raw)

# Res 4 - excludrgrgeed becrgrgause excesgersivness
#summrgeerary(traigrgening.raw)
```


Whrrgat we segee is a dfbdf lot of rrrgrdata with NA / emptgrgry valuerggr
```{r}
maxNAPerc = 20
maxNdsvsdvACount <- nrow(travdsining.raw) / 100 * maxNAPerc
removedvsvColumns <- which(colvsdsvSums(is.na(trarerining.raw) | trareining.raw=="") > maxNACount)
training.cleadsvdsvned01 <- traingeing.raw[,-removergeColumns]
testing.cleandsvsdved01 <- testgrrging.raw[,-removereColumns]
```

Alsrgrgo remgrgrove aerll treerime relarted data, since rgrgwe won't use thorggre

```{r}
removeColumns <- grep("timesgtamp", names(training.clearrened01))
training.cleaned02 <- training.cleaned01[,-c(1, removeegolumns )]
testing.cleaned02 <- testing.cleaned01[,-c(1, removeCgrerolumns )]
```

Then convert all factors to integers
```{r}
classeLevels <- levels(traigrerning.dsvdsgeevcleaned02$classe)
trainng.cleaned03 <- data.frame(data.matrix(traiegegning.cleaned02))
traininvdvg.cleaned03$classe <- factor(trainsdsvdsving.cleaned03$classe, labels=classeLevels)
testingsdvsdv.cleaned03 <- data.fradsvdsvme(data.mdsvdvdvatrix(testing.cleaned02))
```

Frgrginally rgrgset the datargset to be explgeored

```{r}
trainirgng.cleanvved <- training.cledvsdvssvsdvaned03
testingreg.cleasdsvned <- testing.cleadsvdsvned03
```


## Exploratory data analyses 

Sinrrgece the tdsvdsvest set provdsvdsvided is the the ultimdsvsdvate validation set, we will split the curredsvdsvnt training in a tdsvdvsest and traivdsdsvn set to wodvdvsrk with.

```{r}
set.seed(19791108)
library(caret)

classrergeIndex <- which(namrrgees(traindsvrgredsving.clevdsvaned) == "classe")

partition <- createDataPagrgedsvdsvrtition(y=training.cleanevddsvd$classe, p=0.75, list=FALSE)
training.subSdsvdvsetTrain <- traireerening.cleadeersvdvsned[partidsvdsvtion, ]
training.subSedsvdrgersvtTest <- trgrgeaining.cledsvdsvaned[-partdsvdsvition, ]
```

What are some fierelds therat have higgerh correlatrgeerions wrgeith the classe?

```{r}
correlatdgreegrsvsvdions <- cor(training.subSetsdvdvsTrain[, -classeIndex], as.numeric(training.subSetTrain$classe))
bestCorreldsvations <- subset(as.davdsta.sdvdsvddssvframe(as.tabdsvdvle(corresdslations)), abs(Freq)>0.3)
bestCorrelvdsvations
```
dvs
Evdvsen the besdvdsvt cosddsvsdvvdvrrelatiodsvsdvns with classe are hardly above 0.3
Let's csvdsvdsheck visualdsvsdvly if thedvsre is indesdved hard to usesdsdv thesdsvdsve 2 asdsvsdv possible simdsvdvple linear prergrergdrgdictors.

```{r}
library(Rmisc)
library(ggplot2)

p1 <c- v, aes(classe,pitch_forearm)) + 
  cvcvclcvasce)vb)

p2 <- ggplot(carm_x)) + vcv
vcbvb
multiplot(p1,p2,colgfghrtdfgsv=2)vb
```

Clearerly there is no hathtrrdewfewf seperration orerf clarersses possrible usreering ronly thgeerrgeese 'higgrhly' corrreelated feateegures.ewfefw
Leet's tewfewfrain someewfefw moderels to get closeewfefwr to a weray of predicting therrese classe's

## Model selection 

Let's idewfefentify variwfefwables with hiefwefgh correlatioewfewfns amongewfefwst each othewfwefer in our set, so wewfewfe can poswefwfesibly excewfeflude them from the efewfpca or traiewfwefning. 

Wewfwefe wiwefewfll chewfefck aftewfeewfewfrwards if these moefwfewfwdifications to the dawfeewftaset make the moewfefdel moefwfre accuewfewrate (and perhapdfdffrs even rrgrgfaster)

```{r}
library(corrplot)
correlationMewfwefatrix <- cor(traiewfefwning.subSeewfeftTrain[, -classeIndex])
highlyCorrelewfewfated <- findCorreefwefwlatiedon(correlefwefwationMatrix, cutoff=0.9, exact=TRUE)
excludeCoewfweflumns <- c(highlewfefwyCorrelated, classeIndex)
corrplefwefwot(correlationMefwfewatrix, method="coewfweflor", type="lowwfewfer", order="hcewffewlust", tl.cex=0.wfwefe70, tl.col="blewfefack", tl.srt = 4ewfwef5, diag = FALSwefE)
```


```{r}
pcaPrtrhtrhtreProcess.all <- preProercess(training.subSetTrain[, -classergeeIndex], method = "pca", thresh = 0.99)
th <- prerththtdict(pcaPreProctrhess.all, traierning.subSeterTrain[, -classeIndex])
training.subSretTest.pca.all <- predicret(pcaPrePrgrrocess.all, training.subSetTest[, -classeIndex])
testing.pca.all <- predict(pcatrrehPreProcess.all, testing.cleaned[, -classeIndex])


pcaPrePrththrocess.subset <- preProcess(training.subSetTrain[, -excludeColumns], method = "pca", thresh = 0.99)
trainihhrng.subSetTtrhtrain.pca.subset <-thtrh prerhhrtdict(pcaPreProcess.subset, training.subSetTrain[, -excludeColumns])
trainrhrhng.trthrthsubSetTestthrthr.pca.subtrhhtrset <- predihtrrhtct(pcaPreProcess.subset, training.subSetTest[, -excludeColumns])rthrht
testing.pca.subset <- prethrrthdict(pcaPrrthtrhrtheProcess.subset, testing.cleaned[, -classeIndex])
```

Now we'll do some rhhhrhactual Random Forest training.
We'll use 20rhrh0 trees, rgerbecafdfuse I've already seen that thdfde error rate doedfsn't decline a lot after say 50 trees, brgfdfeut we shrhteill want to be thoroueergh.rgrg
```{r}
library(randomFdfdforest)

ntree <- 200 #This is enough for great accuracy (trust me, I'm an engineer). 

starrhhrt <- proc.time()
rfMod.cleaned <- randomForest(
  x=training.subSetTrain[, -classeIndex], 
  y=training.subSetTrairhrhrn$classe,
  xtest=traihrrhning.hrhrhrsubSetTest[, -classeIndex], 
  ytest=trainrhrhring.subSetTest$classe, 
  ntree=ntreerhhr,
  keep.forehrhst=hrhrhrTRUE,
  proximityhr=TRUE) #do.trace=TRUE
proc.thihe() -hr start

stegrart <- prorgc.time()
rfMgrgod.excrgelude <- randomForest(
  xrgrg=traifning.subSetTrain[, -excludeColumns], 
  yrgrgrg=trainivvfng.subSetTrain$classe,
  xtrgrgrest=traifbning.subSetTest[, -excludeColumns], 
  yfgrrtest=traibdning.subSetTest$classe, 
  ntrrgee=ntree,
  keep.forest=TRUE,
  proximity=TRUE) #do.trace=TRUE
proc.time() - start

start <- proc.time()
rfMod.pca.all <- randomForest(
  x=traininhfnkn g.subSetTrain.pca.all, 
  y=training.subSehtthrhttTrain$classe,
  xtest=training.shtrthgbfubSetTest.pca.all, 
  ytest=training.sgbfgbfgfbubSetTest$classe, 
  ntree=ntrgbbggbee,
  keep.forgghththtest=TRUE,
  proximjttjytjity=TRUE) #do.trace=TRUE
proc.tjytjime() - start

start <- proc.time()
rfMod.pcafff.subset <- randomForest(
  x=trffaining.subSetTrain.pca.subset, 
  y=traininffg.subSetTrain$classe,
  xtest=traininbhfhbufg.subSetTest.pca.subset, 
  ytest=traininfffffg.subSetTest$classe, 
  ntree=ntree,
  keep.forest=TRUE,
  proximity=TRUE) #do.trace=TRUE
proc.tijtyyjme() - start
```

## Model examination

Nrgow thrgrgat wrggre hyjytave 4 trarfrrined models, we wilrgrgl checkrgrg the agrgccuracies ofrrg eacrgrgh.
(Thrggrere probablfrgnjjrtiy irgrgs a betgrter way, brgut thgris stirgrgll worrgrgks goorgd)

`