# (1) Import MCD43 from an Earth Engine export
# (2) Gapfill it with single spectrum analysis 
# (3) Smooth it with savitzy golay 

library(Rssa)
library(tidyverse); library(data.table); library(dtplyr, warn.conflicts = F)
library(lubridate)
setDTthreads(threads = 3)

# Import and filter out first blank
tmp <- read_csv("../data_general/Oz_misc_data/MCD43_OzFlux_HS_SP (2).csv") %>% 
  filter(is.na(BRDF_Albedo_Band_Quality_Band1)==T) %>% # filter out the 'blank' image that instantiated the reducer columns
  select(-starts_with('BRDF'),-c('.geo'))

# Fortify dataset with full sequence of dates in case of dropped dates
base <- expand_grid(date = seq(min(tmp$date), max(tmp$date), by='1 day'), 
            site = unique(tmp$site))

dat <- full_join(base, tmp, by=c("date","site"))
dat <- dat %>% mutate(doy = yday(date)) %>%
  filter(doy <= 365) %>% # throwout last day of leap year
  select(-doy)

dat <- dat %>% as.data.table()

fn_gapfill <- function(dat){
  dat <- dat %>% arrange(date) %>%
    mutate(nirv_fill=nirv) %>% 
    tidyr::fill(nirv_fill, .direction = 'downup')

  # cast to ts
  x0 <- ts(dat$nirv, 
          start=c(year(dat$date %>% min),yday(dat$date %>% min)), 
          end=c(year(dat$date %>% max),yday(dat$date %>% max)+1),
          frequency=365)
  x <- ts(dat$nirv_fill, 
          start=c(year(dat$date %>% min),yday(dat$date %>% min)), 
          end=c(year(dat$date %>% max),yday(dat$date %>% max)+1),
          frequency=365)
  
  # short window SSA to gapfill ts
  s1 <- ssa(x, L=33) # optimal L?
  
  # 1st group is trend, 2 & 3 are seasonal. One could select more, but the risk 
  # of bringing in garbage eigenvalues increases with greater groups 
  x2 <- reconstruct(s1, groups = list(c(1,2,3)))$F1
  # plot(x0); lines(x2,col='red') # plot original and gapfilled
  
  x3 <- ts(coalesce(x0,x2), # apply x2 to holes in x0
           start=c(year(dat$date %>% min),yday(dat$date %>% min)), 
           end=c(year(dat$date %>% max),yday(dat$date %>% max)),
           frequency=365)
  dat$nirv_g <- as.numeric(x3)
  return(dat)
}

# apply gapfilling with single spectrum analysis
dat <- dat[,fn_gapfill(.SD),by=site]


fn_sg <- function(dat){
  # p: polynomial order
  # n: window size
  # m: derivative
  dat <- dat %>% lazy_dt() %>% 
    mutate(nirv_sg = signal::sgolayfilt(nirv_g,p=3,n=31,m=0), 
           delta_nirv_sg = signal::sgolayfilt(nirv_g,p=3,n=31,m=1)) %>% 
    as.data.table()
  return(dat)
}

# apply savitzky-golay filter
dat <- dat[,fn_sg(.SD),by=site]



dat %>% as_tibble() %>% 
  mutate(year=year(date)) %>% 
  filter(year==2003) %>% 
  select(nirv, nirv_g, nirv_sg, site, date) %>% 
  gather(-site, -date, key='method',value = 'NIRV') %>% 
  ggplot(data=., aes(date, NIRV, color=method))+
  geom_point()+
  scale_color_viridis_d(end=0.8)+
  facet_grid(method~site)
