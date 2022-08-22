#!/usr/bin/env perl

use strict;
use warnings;

my $gls;
my $line;

my $readme   = "./README.md";

my $acronyms = "./acronyms.tex";
my $glossary = "./glossary.tex";
my $csv      = "./acronyms.csv";
my $yaml     = "./acronyms.yaml";
my $json     = "./acronyms.json";
my $xml      = "./acronyms.xml";

open(README, $readme)          or die "Cannot open $readme: $!";
open(ACRONYMS, '>', $acronyms) or die "Cannot open $acronyms $!";
open(GLOSSARY, '>', $glossary) or die "Cannot open $glossary $!";
open(CSV, '>', $csv)           or die "Cannot open $csv $!";
open(YAML, '>', $yaml)         or die "Cannot open $yaml $!";
open(JSON, '>', $json)         or die "Cannot open $json $!";
open(XML, '>', $xml)           or die "Cannot open $xml $!";

print ACRONYMS "\\usepackage{acronym}\n\n";
print GLOSSARY "\\usepackage[]{glossaries}\n\\makeglossaries\n\\include{glossaryentries}\n\n";
print CSV "Acronym,Full\n";
print YAML "acronyms:\n";
print JSON "{ \"acronyms\": [\n";
print XML "<acronyms>\n";

while ($line=<README>)
{
    if ($line =~ /-\s(.+)\s\((.+)\)/gm)
    {
        $gls = lc $2;
        print ACRONYMS "\\acrodef{$2}{$1}\n";
        print GLOSSARY "\\newglossaryentry{$gls}\n{ name={$2}\n, description={}\n, first={$1 ($2)}\n, long={$1}\n}\n";
        print CSV "$2,\"$1\"\n";
        print YAML "  - $2: \"$1\"\n";
        print JSON "\t{ \"acronym\": \"$2\"\n\t, \"full\": \"$1\" }";
        print JSON ",\n" if not eof;
        print XML "\t<ac>\n\t\t<acronym>$2</acronym>\n\t\t<full>$1</full>\n\t</ac>\n";
    }
}

print JSON "\n\t]\n}";
print XML "</acronyms>";
