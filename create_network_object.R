
# load raw nomination data, where each participant was tie1, tie2, etc as subsequent columns. each row is a participant.
DATA <- read.csv("/Users/LOCATION/FILE.csv") # for mac (for pc, do something like read.csv("C:/USERNAME/FILE.csv"
names(DATA) # check which columns are relevant to the network you're making

# install.packages(dplyr) download package dplyr if you don't have it
NETWORK_DATA <- dplyr::select(DATA[ , c(TIE1:TIE10, TIE1_CLOSENESS:TIE10_CLOSENESS)]) # in this adaptation I have 10 possible ties per participant, so DATA[ , c[1]] participant ID, DATA[ , c(2:11)] are tie names, DATA[ , c(12:21)] are tie closeness scores (eventually weight)
NETWORK_DATA[TIE1==""] <- NA # blank is NA
NETWORK_LONG <- melt(NETWORK_DATA, na.rm=FALSE, id.vars="ID",   # get relevant variables and melt them into 3 columns!
                     measure.vars=c("TIE1", "TIE2", "TIE3", # whatever variables you have for the edges themselves
                                    "TIE4", "TIE5", "TIE6", "TIE7",
                                    "TIE8", "TIE9", "TIE10",
                                    "TIE1_CLOSENESS","TIE2_CLOSENESS","TIE3_CLOSENESS", # whatever variables you have for weight
                                    "TIE4_CLOSENESS","TIE5_CLOSENESS","TIE6_CLOSENESS",
                                    "TIE7_CLOSENESS", "TIE8_CLOSENESS","TIE9_CLOSENESS", 
                                    "TIE10_CLOSENESS"))
1ST_HALF <- nrow(NETWORK_LONG)/2
2ND_HALF <- nrow(NETWORK_LONG) 
TIES_LONG <- subset(NETWORK_LONG[1:(nrow(NETWORK_LONG)/2), ])
TIES_LONG$weight <- NETWORK_LONG[(nrow(NETWORK_LONG)/2)+1:nrow(NETWORK_LONG), 3] # column 3 is weight
names(TIES_LONG) <- c("from", "variable", "to", "weight") # from (node) to (node)
TIES_LONG_CENT <- subset(TIES_LONG, select=c("from","to","weight")) # don't need "variable" column

TIES_LONG_CENT$weight <- ifelse(is.na(TIES_LONG_CENT$to), NA, TIES_LONG_CENT$weight) # if it's not an NA, then put the "weight" value
TIES_LONG_CENTcent$to <- ifelse(is.na(TIES_LONG_CENT$to), TIES_LONG_CENT$from, TIES_LONG_CENT$to) # if it's not an NA, then put the "to" value
TIES_LONG_CENT <- unique(TIES_LONG_CENT) # only want each tie once
MY_LEVELS <- unique(c(as.character(TIES_LONG_CENT$from), as.character(TIES_LONG_CENT$to))) # make IDs levels of a factor bc they'll auto order later
TIES_LONG_CENT$from <- factor(flong1.cent$from, levels = MY_LEVELS) # make "weight" a factor w/ MY_LEVELS
TIES_LONG_CENT$to <- factor(TIES_LONG_CENT$to, levels = MY_LEVELS) $ make "to" a factor w/ MY_LEVELS
TIES_LONG_CENT$weight <- ifelse(TIES_LONG_CENT$from==TIES_LONG_CENT$to, 0, TIES_LONG_CENT$weight) # if "from" equals "to", then put zero bc this means the node is nominating herself. That's not considered an outgoing tie. If "to" and "from" aren't the same, then put the weight.
TIES_LONG_CENT <- na.omit(TIES_LONG_CENT) # goodbye NAs

MATRIX <- reshape2::acast(TIES_LONG_CENT, from~to, value.var="weight", fill=0, drop=F) # make matrix
write.csv(fmat1, file = "MY_SOCIAL_NETWORK_MATRIX.csv") # I like to always turn my new objects into files on my harddrive bc I'm neurotic and paranoid

# now you have a network matrix!
