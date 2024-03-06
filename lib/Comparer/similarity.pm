package Comparer::similarity;

use 5.010001;
use strict;
use warnings;

use Text::Levenshtein::XS;

# AUTHORITY
# DATE
# DIST
# VERSION

sub meta {
    return +{
        v => 1,
        args => {
            string => {schema=>'str*', req=>1},
            reverse => {schema => 'bool*'},
            ci => {schema => 'bool*'},
        },
    };
}

sub gen_comparer {
    my %args = @_;

    my $string = $args{string};
    my $lc_string = lc $string;
    my $reverse = $args{reverse};
    my $ci = $args{ci};

    sub {
        (
            $ci ? (Text::Levenshtein::XS::distance($lc_string, lc($_[0])) <=> Text::Levenshtein::XS::distance($lc_string, lc($_[1]))) :
            (Text::Levenshtein::XS::distance($string, $_[0]) <=> Text::Levenshtein::XS::distance($string, $_[1]))
        ) * ($reverse ? -1 : 1)
    };
}

1;
# ABSTRACT: Compare similarity to a reference string

=for Pod::Coverage ^(meta|gen_comparer)$

=head1 SYNOPSIS

 use Comparer::similarity;

 my $cmp = Comparer::similarity::gen_comparer(string => 'foo');
 my @sorted = sort { $cmp->($a,$b) } "food", "foolish", "foo", "bar";
 # => ("foo","food","bar","foolish")


=head1 DESCRIPTION

=cut
