add.mark("a","top");
f <- function() {
    add.mark("a", "func");
    for(i in 1:10) {
        print("iter");
        print(i);
        add.mark("a","loop");
        helper("a");
    }
}

helper <- function(x) {
    print(marks(x));
}

f();
