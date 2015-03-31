f <- function() {
    add.mark("foo","f");
    g();
}

g <- function() {
    add.mark("foo","g");
    h();
}

h <- function() {
    add.mark("foo","h");
    print(marks("foo"));
}

add.mark("foo","top");
f();
