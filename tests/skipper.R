f <- function() {
    add.mark("foo","f");
    g();
}

g <- function() {
    add.mark("foo2","g");
    h();
}

h <- function() {
    add.mark("foo","h");
    print(marks("foo"));
    print(marks("foo2"));
}

add.mark("foo","top");
print(marks("foo"));
print(marks("foo2"));
f();
print(marks("foo"));
print(marks("foo2"));
