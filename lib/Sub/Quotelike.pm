package Sub::Quotelike;

use strict;
use warnings;
use Filter::Simple;

our $VERSION = 0.01;
our @qq_subs = ();

FILTER {
    while (s/(\bsub\s+(\w+)\s*)\((["'])\)/$1(\$)/) {
	push @qq_subs, [ $2, $3 ];
    }
    for my $qq_sub (@qq_subs) {
	my $s = $qq_sub->[0];
	my $qq = $qq_sub->[1] eq q(") ? 'qq' : 'q';
	s/\bsub\s+$s\b/sub __qUoTeLiKe_$s/g;
	s/(?<![\$\@%&])\b$s\b/__qUoTeLiKe_$s $qq/g;
	s/&$s\b/&__qUoTeLiKe_$s/g;
    }
};

1;

__END__

=head1 NAME

Sub::Quotelike - Allow to define quotelike functions

=head1 SYNOPSIS

    use Sub::Quotelike;

    sub myq (') {
	my $s = shift;
	# Do something with $s...
	return $s;
    }

    sub myqq (") {
	my $s = shift;
	# Do something with $s...
	return $s;
    }

    print myq/abc def/;
    print myqq{abc $def @ghi\n};

=head1 DESCRIPTION

This module allows to define quotelike functions, that mimic the
syntax of the builtin operators C<q()>, C<qq()>, C<qw()>, etc.

To define a quotelike function that interpolates quoted text, use
the new C<(")> prototype. For non-interpolating functions, use C<(')>.
That's all.

=head1 BUGS

This module does have bugs !!

It uses Filter::Simple internally. As I don't want to reimplement the
perl tokenizer today, this means that it only performs some heuristic
substitutions on the perl source code, to replace quotelike function
calls by something more meaningful to plain perl 5.

Basically, if you have a quotelike function C<foo>, you'll be able to
use variables $foo, @foo, and %foo, and to use &foo(...) if you want to
bypass the quotelike syntax. But you'll have problems if you write
a literal word 'foo' in your code at other places (like C<$hash{foo}>
or C<print "xxx foo yyy">).

So my advice is to use meaningful names, unlikely to clash, for your
quotelike functions : e.g. names that begin with 'q_' or 'qq_'.

=head1 AUTHOR

Copyright (c) 2001 Rafael Garcia-Suarez. All rights reserved. This
program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
