source("marks.R");

loop <- function(x) {
    #add.mark("a", x);
    if(x == 0) {
        #marks("a");
    } else {
        loop(x - 1);
    }
}

for(i in 1 : 100) {
    loop(1000);
}
