f <- function() {
    add.mark("a", "alpha");
    g();
}

g <- function() {
    add.mark("b", "beta");
    h();
}

h <- function() {
    add.mark("a", "gamma");
    c(marks("a"), marks("b"));
}

h2 <- function() {
    with.mark("a", "gamma", {
        print(c(marks("a"), marks("b")));
    })
    print(c(marks("a"), marks("b")));
}

add.mark <- function(name, val) {
    pframe <- parent.frame(1)
    if(!is.environment(pframe[["marks"]])) {
        pframe[["marks"]] <- new.env();
    }
    pframe[["marks"]][[name]] <- val;
}

with.mark <- function(name,val,body) {
    pframe <- parent.frame(1)
    if(!is.environment(pframe[["marks"]])) {
        pframe[["marks"]] <- new.env();
    }
    pframe[["marks"]][[name]] <- val;
    body;
}

marks <- function(type) {
    p <- 1; # possilby use sys.nframe()
    frames <- c();
    currentenv <- environment()
    while(!identical(currentenv,.GlobalEnv)) {
        currentenv <- parent.frame(p);
        if(is.environment(currentenv$marks)) {
            if(exists(type,currentenv$marks)) {
                frames <- c(currentenv$marks[[type]],frames);
            }
        }
        p <- p + 1;
    }
    frames;
}
