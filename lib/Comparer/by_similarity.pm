package Comparer::by_similarity;

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

    my $reverse = $args{reverse};
    my $ci = $args{ci};

    sub {
        (
            $args{ci} ? (Text::Levenshtein::XS::distance(lc($args{string}), lc($_[0])) <=> Text::Levenshtein::XS::distance(lc($args{string}), lc($_[1]))) :
            (Text::Levenshtein::XS::distance($args{string}, $_[0]) <=> Text::Levenshtein::XS::distance($args{string}, $_[1]))
        ) * ($args{reverse} ? -1 : 1)
    };
}

1;
# ABSTRACT: Compare similarity to a reference string

=for Pod::Coverage ^(meta|gen_sorter)$

=head1 SYNOPSIS

 use Comparer::by_similarity;

 my $cmp = Comparer::by_similarity::gen_sorter(string => 'foo');
 my @sorted = sort { $cmp->($a,$b) } "food", "foolish", "foo", "bar";


=head1 DESCRIPTION

=cut
