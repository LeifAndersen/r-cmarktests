source("main.R")

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
