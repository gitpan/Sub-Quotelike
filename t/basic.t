#!perl -w

BEGIN {
    unshift @INC, './lib';
}

use strict;
use Sub::Quotelike;

print "1..5\n";

sub rot13 (") {
    local $_ = shift;
    tr/a-zA-Z/n-za-mN-ZA-M/;
    $_;
}

sub
	foo('){"ok $_[0]\n"}

my $foo = 'bx';
print rot13(bx 1\n);
print rot13/$foo 2\n/;
print rot13{bx ${\(1+2)}
};
print foo$4$;
print &rot13("bx 5\n");
