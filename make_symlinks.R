#make directories

options(stringsAsFactors = FALSE)

#load in life history and number of unk's to get folder names

lh<-read.csv("../Desktop/Database Data/LifeHistory_20190603.csv")

dols<-lh$Dolphin.ID

unks<-paste0("UNK", 1205:1483)

namedirs<-paste("mkdir", c(dols,unks))

writeLines(namedirs, "../Desktop/Field Season 2019/namedirs.bat")

#make symlink bat file

#pull and clean names and dates from photo file (selected columns from allfilm)
photos<-read.csv("../Desktop/Field Season 2019/film_to_symlink.csv")

photos<-photos[photos$Identifications!="",]

res<-lapply(1:nrow(photos),
            function(x) {
              ids <- unlist(strsplit(photos[x,"Identifications"], " "))
              date <- photos[x, "Date"]
              frame <- data.frame(Dolphin.ID=ids, photos[x,])
              return(frame)
            }
)

film_res<-do.call("rbind", res)
film_res$Dolphin.ID<-toupper(trimws(film_res$Dolphin.ID))

film_sort<-film_res[film_res$Dolphin.ID %in% c(dols,unks),]

film_sort$Date<-as.Date(film_sort$Date, format="%d-%b-%y")

#create names for your symbolic links
film_sort$symlink_name<-paste0("D:\\symlinks2019\\", 
                               film_sort$Dolphin.ID,
                               "\\",
                               film_sort$Date, "_",
                               film_sort$RollCard,"_",
                               film_sort$FileNumber,
                               ".JPG")

symlink_names<-paste0("mklink ",'"',film_sort$symlink_name,'" "',film_sort$fullpath,'"')

#write batch scripts
writeLines(symlink_names, "../Desktop/Field Season 2019/make_symlinks.bat")

#note you will need to run scripts with administrator privileges



