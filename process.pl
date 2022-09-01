#!/usr/bin/env perl

use strict;
use warnings;
use GraphViz;

my $gls;
my $line;

my $readme   = "./README.md";

my $acronyms = "./acronyms.tex";
my $glossary = "./glossary.tex";
my $csv      = "./acronyms.csv";
my $yaml     = "./acronyms.yaml";
my $json     = "./acronyms.json";
my $xml      = "./acronyms.xml";
my $skill    = "./acronyms.il";
my $svg      = "./acronyms.svg";
#my $png      = "./acronyms.png";

my $graph    = GraphViz->new();

open(README, $readme)          or die "Cannot open $readme: $!";
open(ACRONYMS, '>', $acronyms) or die "Cannot open $acronyms $!";
open(GLOSSARY, '>', $glossary) or die "Cannot open $glossary $!";
open(CSV, '>', $csv)           or die "Cannot open $csv $!";
open(YAML, '>', $yaml)         or die "Cannot open $yaml $!";
open(JSON, '>', $json)         or die "Cannot open $json $!";
open(XML, '>', $xml)           or die "Cannot open $xml $!";
open(SKILL, '>', $skill)       or die "Cannot open $skill $!";
open(SVG, '>', $svg)           or die "Cannot open $svg $!";

print ACRONYMS "\\usepackage{acronym}\n\n";
print GLOSSARY "\\usepackage[]{glossaries}\n\\makeglossaries\n\\include{glossaryentries}\n\n";
print CSV "Acronym,Full\n";
print YAML "acronyms:\n";
print JSON "{ \"acronyms\": [\n";
print XML "<acronyms>\n";
print SKILL "(setq acronyms (list nil";

while ($line=<README>)
{
    if ($line =~ /-\s(.+)\s\((.+)\)/gm)
    {
        my $acr = $2;
        my $full = $1;
        my $gls = lc $acr;
        (my $sym = $acr) =~ s/ /_/g;
        print ACRONYMS "\\acrodef{$acr}{$full}\n";
        print GLOSSARY "\\newglossaryentry{$gls}\n{ name={$acr}\n, description={}\n, first={$full ($acr)}\n, long={$full}\n}\n";
        print CSV "$acr,\"$full\"\n";
        print YAML "  - $acr: \"$full\"\n";
        print JSON "\t{ \"acronym\": \"$acr\"\n\t, \"full\": \"$full\" }";
        print JSON ",\n" if not eof;
        print XML "\t<ac>\n\t\t<acronym>$acr</acronym>\n\t\t<full>$full</full>\n\t</ac>\n";
        print SKILL "\n\t'$sym\t\"$full\"";

        my $chr;
        my $itr;
        foreach $chr (split //, $acr) {
            $graph->add_node(uc $chr);
        }
        for $itr (0 .. length($acr)-2) {
            my $fst = substr($acr, $itr, 1);
            my $snd = substr($acr, ($itr + 1), 1);
            $graph->add_edge($fst => $snd);
        }
    }
}

#$graph->as_png($png);
print SVG $graph->as_svg;

print JSON "\n\t]\n}";
print XML "</acronyms>";
print SKILL "))";
