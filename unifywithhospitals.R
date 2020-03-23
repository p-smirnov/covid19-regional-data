library(readxl)

library(data.table)
options(stringsAsFactors=FALSE)

# cur.ontario.stat <- data.table(read.csv(url("https://docs.google.com/spreadsheets/d/1D6okqtBS3S2NRC7GFVHzaZ67DuTw7LX49-fqSLwJyeo/export?format=csv&id=1D6okqtBS3S2NRC7GFVHzaZ67DuTw7LX49-fqSLwJyeo"), skip=2))
# cur.ontario.stat <- cur.ontario.stat[province=="Ontario"]

hospital.stats <- data.table(read_excel("input/Hospital numbers.xlsx"))


# unique(cur.ontario.stat$health_region)

# unique(hospital.stats$`Health region`)

map.regions <- data.frame("Cases Region" = unique(cur.ontario.stat$health_region), "LHIN" = NA_character_, "Major Health Region" = NA_character_)

lhin.to.regions <- read.csv("input/lhin_to_region.csv")

hospital.stats[,`General Region`:= lhin.to.regions[match(`Health region`, lhin.to.regions$LHIN.Region), "General.Region"]]

hospital.stats.trunc <- hospital.stats[1:143,]

write.csv(hospital.stats.trunc, file="output/hospital_stats_by_region.csv")

totals.by.regions <- hospital.stats.trunc[,.(sum(as.numeric(`Intensive Care`), na.rm=T), sum(as.numeric(`Other Acute`), na.rm=T)), `General Region`]

colnames(totals.by.regions)[2:3] <- c("Intensive Care", "Other Acute")

fwrite(totals.by.regions, file="output/total_hospital_stats_by_region.csv")
