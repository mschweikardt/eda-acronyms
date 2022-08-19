#!/usr/bin/env perl

use strict;
use warnings;

my $gls;
my $line;
my $readme = "./README.md";
my $acronyms = "./acronyms.tex";
my $glossary = "./glossary.tex";

open(README, $readme) or die "Cannot open $readme: $!";
open(ACRONYMS, '>', $acronyms) or die "Cannot open $acronyms $!";
open(GLOSSARY, '>', $glossary) or die "Cannot open $glossary $!";

print ACRONYMS "\\usepackage{acronym}\n\n";

while ($line=<README>)
{
    if ($line =~ /-\s(.+)\s\((.+)\)/gm)
    {
        $gls = lc $2;
        print ACRONYMS "\\acrodef{$2}{$1}\n";
        print GLOSSARY "\\newglossaryentry{$gls}\n{ name={$2}\n, description={}\n, first={$1 ($2)}\n, long={$1}\n}\n";
    }
}
