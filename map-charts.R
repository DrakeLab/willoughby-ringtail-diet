library(ggplot2)
library(tidyverse)

studies <- read.csv('Study_Coordinates.csv')
studies$method <- studies$method.2

studies$TemporalPeriod <- as.factor(studies$TemporalPeriod)

temporal.data <- studies %>% group_by(ecoregion, TemporalPeriod, method) %>% summarise(n=n())

eco6 <- temporal.data %>% filter(ecoregion==6)
eco8 <- temporal.data %>% filter(ecoregion==8)
eco9 <- temporal.data %>% filter(ecoregion==9)
eco10 <- temporal.data %>% filter(ecoregion==10)
eco11 <- temporal.data %>% filter(ecoregion==11)
eco12 <- temporal.data %>% filter(ecoregion==12)
eco13 <- temporal.data %>% filter(ecoregion==13)
eco14 <- temporal.data %>% filter(ecoregion==14)

ggplot(eco8) +
  geom_bar(aes(x=TemporalPeriod, y=n, group=method), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656')) +
  ggtitle('Eastern Temperate Forest') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#FCF6CC'))  

ggplot(eco6) +
  geom_bar(aes(x=TemporalPeriod, y=n, group=method), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656')) +
  ggtitle('Northwestern Forested Mountains') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#F8D493'))    

ggplot(eco9) +
  geom_bar(aes(x=TemporalPeriod, y=n), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656', '#878787', '#B9B9B9')) +
  ggtitle('Great Plains') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#D4C3A5'))  

ggplot(eco10) +
  geom_bar(aes(x=TemporalPeriod, y=n, group=method), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656', '#878787', '#B9B9B9')) +
  ggtitle('North American Desert') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#E9D1FB'))    

ggplot(eco11) +
  geom_bar(aes(x=TemporalPeriod, y=n), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656', '#878787', '#B9B9B9')) +
  ggtitle('Mediteranean California') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#C9EFAC'))

ggplot(eco12) +
  geom_bar(aes(x=TemporalPeriod, y=n), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656', '#878787', '#B9B9B9')) +
  ggtitle('Southern Semiarid Highlands') +
  ylab('Study Count') +
  xlab('') + theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#FFB0B0')) 

ggplot(eco13) +
  geom_bar(aes(x=TemporalPeriod, y=n), stat="identity") +
  theme_minimal() +
  scale_fill_manual(values=c('#222222','#565656', '#878787', '#B9B9B9')) +
  ggtitle('Temperate Sierras') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill='#ABCFD9')) 

ggplot(eco14) +
  geom_bar(aes(x=TemporalPeriod, y=n), stat="identity") +
  theme_minimal()+
  scale_fill_manual(values=c('#222222','#565656', '#878787', '#B9B9B9')) +
  ggtitle('Tropical Dry Forests') +
  ylab('Study Count') +
  xlab('') + 
  theme(plot.title= element_text(hjust=.5), 
                   panel.background = element_rect(fill="#FDDAEC"))

  
