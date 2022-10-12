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
my $svgl     = "./letters.svg";
my $svgw     = "./words.svg";
my $png      = "./acronyms.png";
my $dotl     = "./letters.dot";
my $dotw     = "./words.dot";

my $l_graph  = GraphViz->new();
my $w_graph  = GraphViz->new();

open(README, $readme)          or die "Cannot open $readme $!";
open(ACRONYMS, '>', $acronyms) or die "Cannot open $acronyms $!";
open(GLOSSARY, '>', $glossary) or die "Cannot open $glossary $!";
open(CSV, '>', $csv)           or die "Cannot open $csv $!";
open(YAML, '>', $yaml)         or die "Cannot open $yaml $!";
open(JSON, '>', $json)         or die "Cannot open $json $!";
open(XML, '>', $xml)           or die "Cannot open $xml $!";
open(SKILL, '>', $skill)       or die "Cannot open $skill $!";
open(SVGL, '>', $svgl)         or die "Cannot open $svgl $!";
open(SVGW, '>', $svgw)         or die "Cannot open $svgw $!";
open(DOTL, '>', $dotl)         or die "Cannot open $dotl $!";
open(DOTW, '>', $dotw)         or die "Cannot open $dotw $!";

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
        foreach $chr (split //, $acr) 
        {
            $l_graph->add_node(uc $chr);
        }
        for $itr (0 .. length($acr)-2) 
        {
            my $fst = substr($acr, $itr, 1);
            my $snd = substr($acr, ($itr + 1), 1);
            $l_graph->add_edge($fst => $snd);
        }

        my $wrd;
        $full =~ s/[^a-zA-Z0-9]/ /g;
        my @words = split(/\s+/, $full);
        my %seen;
        my @uniq = grep { !$seen{$_}++ } @words;
        foreach $wrd (@uniq) 
        {
            $wrd = "EGDE" if lc($wrd) eq "edge";
            $wrd = "GARPH" if lc($wrd) eq "graph";
            $w_graph->add_node(uc $wrd, label => $wrd);
        }
        for $itr (0 .. scalar(@words)-2) 
        {
            my $fst = uc ($words[$itr]);
            my $snd = uc ($words[$itr + 1]);
            if (lc($fst) eq "edge") { $fst = "EGDE"; }
            if (lc($snd) eq "edge") { $snd = "EGDE"; }
            if (lc($fst) eq "graph") { $fst = "GARPH"; }
            if (lc($snd) eq "graph") { $snd = "GARPH"; }
            $w_graph->add_edge($fst => $snd);
        }
    }
}

#$w_graph->as_png($png);
print SVGL $l_graph->as_svg;
print SVGW $w_graph->as_svg;
print DOTL $l_graph->as_debug;
print DOTW $w_graph->as_debug;

print JSON "\n\t]\n}";
print XML "</acronyms>";
print SKILL "))";
